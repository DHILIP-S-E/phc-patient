// ============================================================
// PHC AI Assistant - Model Download Data Source
// Handles chunked download with pause/resume via Dio + byte-range
// ============================================================

import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/model_constants.dart';
import '../../domain/entities/download_progress.dart';

class ModelDownloadDataSource {
  final Dio _dio;
  final SharedPreferences _prefs;

  CancelToken? _cancelToken;
  bool _isPaused = false;
  int _downloadedBytes = 0;
  DateTime? _speedSampleTime;
  int _speedSampleBytes = 0;

  static const String _partialFileSuffix = '.partial';
  static const String _keyDownloadedBytes = 'download_resumed_bytes';

  ModelDownloadDataSource({
    required Dio dio,
    required SharedPreferences prefs,
  })  : _dio = dio,
        _prefs = prefs;

  // ── Get Model Directory ───────────────────────────────────
  Future<Directory> get _modelDir async {
    final appDir = await getApplicationSupportDirectory();
    final modelDir = Directory('${appDir.path}/${ModelConstants.modelDirectory}');
    await modelDir.create(recursive: true);
    return modelDir;
  }

  Future<String> get modelFilePath async {
    final dir = await _modelDir;
    return '${dir.path}/${ModelConstants.modelFileName}';
  }

  Future<String> get _partialFilePath async {
    final dir = await _modelDir;
    return '${dir.path}/${ModelConstants.modelFileName}$_partialFileSuffix';
  }

  // ── Check if Model Exists ─────────────────────────────────
  Future<bool> modelExists() async {
    final path = await modelFilePath;
    return File(path).exists();
  }

  // ── Get Available Storage ─────────────────────────────────
  Future<int> getAvailableStorage() async {
    try {
      final appDir = await getApplicationSupportDirectory();
      final stat = await FileStat.stat(appDir.path);
      // On Android, this is a rough estimate
      return stat.size > 0 ? stat.size : 2 * 1024 * 1024 * 1024; // 2GB fallback
    } catch (_) {
      return 2 * 1024 * 1024 * 1024;
    }
  }

  // ── Download Model with Progress ──────────────────────────
  Stream<DownloadProgress> downloadModel({int startByte = 0}) async* {
    _cancelToken = CancelToken();
    _isPaused = false;

    final partialPath = await _partialFilePath;
    final finalPath = await modelFilePath;

    // AUTO-RESUME: if an interrupted download left a .partial file, continue from
    // its current size instead of restarting from zero. This survives app close,
    // an incoming call, low battery, etc. -- the "don't re-download every time"
    // fix. Works even when the caller passed startByte=0 (e.g. a plain Start).
    if (startByte == 0) {
      final pf = File(partialPath);
      if (await pf.exists()) {
        final len = await pf.length();
        if (ModelConstants.modelSizeBytes > 0 &&
            len >= ModelConstants.modelSizeBytes) {
          // Already fully downloaded but never finalized -> finalize + verify.
          await pf.rename(finalPath);
          await _prefs.remove(_keyDownloadedBytes);
          yield DownloadProgress(
            status: DownloadStatus.verifying,
            downloadedBytes: len,
            totalBytes: len,
          );
          return;
        }
        startByte = len; // resume from what we already have
      }
    }

    _downloadedBytes = startByte;
    _speedSampleTime = DateTime.now();
    _speedSampleBytes = startByte;

    // Safety: a resume only makes sense if the partial file exists AND is exactly
    // startByte long. Otherwise appending would corrupt the file (right size, bad
    // bytes -> checksum mismatch). If it doesn't match, restart from scratch.
    if (startByte > 0) {
      final pf = File(partialPath);
      final existing = await pf.exists() ? await pf.length() : 0;
      if (existing != startByte) {
        startByte = 0;
        _downloadedBytes = 0;
        _speedSampleBytes = 0;
        if (await pf.exists()) await pf.delete();
      }
    }

    try {
      // Use byte-range header for resume support
      final headers = startByte > 0
          ? {'Range': 'bytes=$startByte-'}
          : <String, dynamic>{};

      final response = await _dio.get<ResponseBody>(
        ModelConstants.modelDownloadUrl,
        options: Options(
          responseType: ResponseType.stream,
          headers: headers,
          receiveTimeout: const Duration(minutes: 30),
        ),
        cancelToken: _cancelToken,
      );

      // If we requested a range but the server returned 200 (full file) instead
      // of 206 (partial), it ignored the range -> overwrite from 0, don't append.
      final serverHonoredRange = startByte > 0 && response.statusCode == 206;
      final effectiveStart = serverHonoredRange ? startByte : 0;

      final totalBytes = _parseTotalBytes(response, effectiveStart);
      final sink = File(partialPath).openWrite(
        mode: effectiveStart > 0 ? FileMode.append : FileMode.write,
      );

      try {
        int currentBytes = effectiveStart;
        _downloadedBytes = effectiveStart;
        _speedSampleBytes = effectiveStart;
        DateTime lastUpdate = DateTime.now();

        await for (final chunk in response.data!.stream) {
          if (_isPaused || (_cancelToken?.isCancelled ?? false)) {
            await _prefs.setInt(_keyDownloadedBytes, currentBytes);
            if (_isPaused) {
              yield DownloadProgress(
                status: DownloadStatus.paused,
                downloadedBytes: currentBytes,
                totalBytes: totalBytes,
              );
            }
            return;
          }

          sink.add(chunk);
          currentBytes += chunk.length;
          _downloadedBytes = currentBytes;

          final now = DateTime.now();
          final elapsed = now.difference(lastUpdate).inMilliseconds;
          if (elapsed >= 250) {
            final speed = _calculateSpeed(currentBytes, now);
            final remaining = totalBytes > 0 ? totalBytes - currentBytes : 0;
            final eta = speed > 0 ? (remaining / speed).round() : 0;

            yield DownloadProgress(
              status: DownloadStatus.downloading,
              downloadedBytes: currentBytes,
              totalBytes: totalBytes,
              speedBytesPerSecond: speed,
              etaSeconds: eta,
            );
            lastUpdate = now;
          }
        }

        await sink.flush();
      } finally {
        await sink.close();
      }

      // Move partial file to final location
      await File(partialPath).rename(finalPath);
      await _prefs.remove(_keyDownloadedBytes);

      yield DownloadProgress(
        status: DownloadStatus.verifying,
        downloadedBytes: _downloadedBytes,
        totalBytes: totalBytes,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        if (_isPaused) {
          await _prefs.setInt(_keyDownloadedBytes, _downloadedBytes);
          yield DownloadProgress(
            status: DownloadStatus.paused,
            downloadedBytes: _downloadedBytes,
            totalBytes: ModelConstants.modelSizeBytes,
          );
        } else {
          yield const DownloadProgress(status: DownloadStatus.cancelled);
        }
      } else {
        yield DownloadProgress(
          status: DownloadStatus.failed,
          errorMessage: 'Download failed: ${e.message}',
        );
      }
    } catch (e) {
      yield DownloadProgress(
        status: DownloadStatus.failed,
        errorMessage: 'Unexpected error: $e',
      );
    }
  }

  // ── Pause ─────────────────────────────────────────────────
  void pause() {
    _isPaused = true;
    _cancelToken?.cancel('download paused');
  }

  // ── Resume ────────────────────────────────────────────────
  Stream<DownloadProgress> resume() {
    final resumeByte = _prefs.getInt(_keyDownloadedBytes) ?? _downloadedBytes;
    _isPaused = false;
    return downloadModel(startByte: resumeByte);
  }

  // ── Cancel ────────────────────────────────────────────────
  Future<void> cancel() async {
    _cancelToken?.cancel('User cancelled download');
    final partialPath = await _partialFilePath;
    final partial = File(partialPath);
    if (await partial.exists()) await partial.delete();
    await _prefs.remove(_keyDownloadedBytes);
  }

  // ── Delete Model ──────────────────────────────────────────
  Future<void> deleteModel() async {
    final path = await modelFilePath;
    final file = File(path);
    if (await file.exists()) await file.delete();
  }

  // ── Helpers ───────────────────────────────────────────────
  int _parseTotalBytes(Response response, int startByte) {
    try {
      final contentRange = response.headers.value('content-range');
      if (contentRange != null) {
        final total = contentRange.split('/').last;
        return int.tryParse(total) ?? ModelConstants.modelSizeBytes;
      }
      final contentLength = response.headers.value('content-length');
      if (contentLength != null) {
        final length = int.tryParse(contentLength) ?? 0;
        return length + startByte;
      }
    } catch (_) {}
    return ModelConstants.modelSizeBytes;
  }

  double _calculateSpeed(int currentBytes, DateTime now) {
    final elapsed = now.difference(_speedSampleTime!).inMilliseconds;
    if (elapsed < 500) return 0;
    final bytesDelta = currentBytes - _speedSampleBytes;
    final speed = bytesDelta / (elapsed / 1000.0);
    // Update sample
    _speedSampleTime = now;
    _speedSampleBytes = currentBytes;
    return speed;
  }
}
