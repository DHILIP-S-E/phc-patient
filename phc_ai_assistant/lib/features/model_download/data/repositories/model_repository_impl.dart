// ============================================================
// PHC AI Assistant - Model Repository Implementation
// ============================================================

import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/model_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/checksum_util.dart';
import '../../domain/entities/download_progress.dart';
import '../../domain/entities/model_info.dart';
import '../../domain/repositories/model_repository.dart';
import '../datasources/model_download_datasource.dart';

class ModelRepositoryImpl implements ModelRepository {
  final ModelDownloadDataSource _dataSource;
  final SharedPreferences _prefs;

  ModelRepositoryImpl({
    required ModelDownloadDataSource dataSource,
    required SharedPreferences prefs,
  })  : _dataSource = dataSource,
        _prefs = prefs;

  @override
  Future<Either<Failure, bool>> checkModelExists() async {
    try {
      final exists = await _dataSource.modelExists();
      if (!exists) return const Right(false);
      final verified = _prefs.getBool(AppConstants.keyModelDownloaded) ?? false;
      return Right(verified);
    } catch (e) {
      return Left(StorageFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ModelInfo>> getModelInfo() async {
    try {
      final localPath = await _dataSource.modelFilePath;
      final exists = await _dataSource.modelExists();
      final isVerified = _prefs.getBool(AppConstants.keyModelDownloaded) ?? false;
      final downloadedAtMs = _prefs.getInt('model_downloaded_at');

      return Right(ModelInfo(
        name: ModelConstants.modelName,
        version: ModelConstants.modelVersion,
        fileName: ModelConstants.modelFileName,
        downloadUrl: ModelConstants.modelDownloadUrl,
        checksum: ModelConstants.modelChecksum,
        sizeBytes: ModelConstants.modelSizeBytes,
        localPath: exists ? localPath : null,
        isVerified: isVerified,
        downloadedAt: downloadedAtMs != null
            ? DateTime.fromMillisecondsSinceEpoch(downloadedAtMs)
            : null,
      ));
    } catch (e) {
      return Left(StorageFailure(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, DownloadProgress>> downloadModel() async* {
    await for (final progress in _dataSource.downloadModel()) {
      if (progress.status == DownloadStatus.failed) {
        yield Left(DownloadFailure(message: progress.errorMessage ?? 'Download failed'));
      } else {
        if (progress.status == DownloadStatus.verifying) {
          await _prefs.setBool(AppConstants.keyModelDownloaded, false);
        }
        yield Right(progress);
      }
    }
  }

  @override
  Future<Either<Failure, void>> pauseDownload() async {
    try {
      _dataSource.pause();
      return const Right(null);
    } catch (e) {
      return Left(DownloadFailure(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, DownloadProgress>> resumeDownload() async* {
    await for (final progress in _dataSource.resume()) {
      if (progress.status == DownloadStatus.failed) {
        yield Left(DownloadFailure(message: progress.errorMessage ?? 'Resume failed'));
      } else {
        yield Right(progress);
      }
    }
  }

  @override
  Future<Either<Failure, void>> cancelDownload() async {
    try {
      await _dataSource.cancel();
      return const Right(null);
    } catch (e) {
      return Left(DownloadFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyModel({
    void Function(double progress)? onProgress,
  }) async {
    try {
      final path = await _dataSource.modelFilePath;
      final isValid = await ChecksumUtil.verifyFile(
        path,
        ModelConstants.modelChecksum,
        onProgress: onProgress,
      );

      if (isValid) {
        await _prefs.setBool(AppConstants.keyModelDownloaded, true);
        await _prefs.setString(AppConstants.keyModelVersion, ModelConstants.modelVersion);
        await _prefs.setInt('model_downloaded_at', DateTime.now().millisecondsSinceEpoch);
        await _prefs.setString(AppConstants.keyModelPath, path);
        await _prefs.setString(AppConstants.keyModelChecksum, ModelConstants.modelChecksum);
      } else {
        // Checksum mismatch — delete corrupted file
        await _dataSource.deleteModel();
        await _prefs.setBool(AppConstants.keyModelDownloaded, false);
      }

      return Right(isValid);
    } catch (e) {
      return Left(ChecksumFailure(message: 'Verification failed: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteModel() async {
    try {
      await _dataSource.deleteModel();
      await _prefs.setBool(AppConstants.keyModelDownloaded, false);
      await _prefs.remove(AppConstants.keyModelVersion);
      await _prefs.remove(AppConstants.keyModelPath);
      await _prefs.remove(AppConstants.keyModelChecksum);
      await _prefs.remove('model_downloaded_at');
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ModelInfo?>> checkForUpdate() async {
    // TODO: Implement remote version check against ModelConstants.modelMetaUrl
    // For now, return null (no update)
    return const Right(null);
  }

  @override
  Future<Either<Failure, int>> getAvailableStorage() async {
    try {
      final bytes = await _dataSource.getAvailableStorage();
      return Right(bytes);
    } catch (e) {
      return Left(StorageFailure(message: e.toString()));
    }
  }
}
