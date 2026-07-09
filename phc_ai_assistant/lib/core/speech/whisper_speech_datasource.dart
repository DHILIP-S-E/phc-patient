// ============================================================
// PHC AI Assistant - Whisper Speech Data Source (offline STT)
// Fully on-device speech recognition via whisper.cpp (whisper_ggml). Works for
// ALL Indian languages including Tamil with a single multilingual model, with no
// dependency on Google speech packs and no settings redirect.
//
// Flow: tap mic → record 16kHz mono WAV → auto-stop after a short silence →
// whisper transcribes the utterance → emit final text. Whisper is chunk-based,
// so there are no live word-by-word partials (it transcribes after you pause).
// ============================================================

import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:whisper_ggml/whisper_ggml.dart';
import 'package:phc_ai_assistant/core/constants/app_constants.dart';
import 'speech_recognizer.dart';

class WhisperSpeechDataSource implements SpeechRecognizer {
  final Logger _logger = Logger();
  final AudioRecorder _recorder = AudioRecorder();
  final WhisperController _whisper = WhisperController();

  // 'base' = multilingual, ~140MB, good balance for phone CPU. Bump to
  // WhisperModel.small for better Indian-language accuracy (~460MB) if desired.
  static const WhisperModel _model = WhisperModel.base;

  final _partialController = StreamController<String>.broadcast();
  final _finalController = StreamController<String>.broadcast();
  final _errorController = StreamController<String>.broadcast();
  final _downloadController = StreamController<double>.broadcast();
  final Dio _dio = Dio();

  @override
  Stream<String> get partialResults => _partialController.stream;
  @override
  Stream<String> get finalResults => _finalController.stream;
  @override
  Stream<String> get errors => _errorController.stream;
  @override
  Stream<double> get modelDownloadProgress => _downloadController.stream;
  @override
  bool get isReady => _modelReady;

  String _lang = 'en';
  bool _modelReady = false;
  bool _isListening = false;
  String? _recordPath;
  StreamSubscription<Amplitude>? _ampSub;
  DateTime? _lastLoud;
  Timer? _silenceTimer;

  bool get isListening => _isListening;

  @override
  Future<bool> initialize() async {
    try {
      final granted = await _recorder.hasPermission();
      if (!granted) {
        _logger.e('[Whisper] Microphone permission denied');
        return false;
      }
      // NOTE: no auto-download here. In hybrid mode we only need the Whisper
      // model when a language has no system pack — the model is fetched then
      // (via prefetchModel / on first listen) so we don't pull ~140MB uselessly.
      return true;
    } catch (e) {
      _logger.e('[Whisper] init failed: $e');
      return false;
    }
  }

  /// Start downloading the model ahead of time (e.g. when a pack-less language
  /// is selected) so it's ready before the user speaks.
  Future<void> prefetchModel() => _ensureModel();

  Future<void> _ensureModel() async {
    if (_modelReady) return;
    try {
      final path = await _whisper.getPath(_model);
      final file = File(path);
      if (await file.exists() && await file.length() > 1024 * 1024) {
        _modelReady = true;
        _downloadController.add(1.0);
        _logger.i('[Whisper] Model already present: $path');
        return;
      }
      // Download with progress (reported to the UI) instead of the package's
      // silent all-in-memory download. ~140MB, one time, covers all languages.
      _logger.i('[Whisper] Downloading model "${_model.modelName}" (~140MB)…');
      _downloadController.add(0.0);
      final tmp = '$path.part';
      await _dio.download(
        _model.modelUri.toString(),
        tmp,
        onReceiveProgress: (received, total) {
          if (total > 0) _downloadController.add(received / total);
        },
      );
      await File(tmp).rename(path);
      _modelReady = true;
      _downloadController.add(1.0);
      _logger.i('[Whisper] Model ready: $path');
    } catch (e) {
      _logger.e('[Whisper] model download failed: $e');
      _downloadController.add(-1.0);
    }
  }

  @override
  void setLanguage(String languageCode) {
    _lang = languageCode;
    _logger.d('[Whisper] language = $_lang');
  }

  @override
  Future<bool> isLanguageAvailable(String languageCode) async {
    // Whisper is multilingual — every supported language works from the single
    // model. So there is never a missing-pack prompt / settings redirect.
    return true;
  }

  @override
  Future<void> startListening({bool background = false}) async {
    if (_isListening) return;
    if (!_modelReady) {
      await _ensureModel();
      if (!_modelReady) {
        _errorController.add('model_not_ready');
        return;
      }
    }

    final dir = await getTemporaryDirectory();
    _recordPath =
        '${dir.path}/phc_utt_${DateTime.now().millisecondsSinceEpoch}.wav';

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 16000, // whisper wants 16kHz
        numChannels: 1, // mono
      ),
      path: _recordPath!,
    );
    _isListening = true;
    _lastLoud = DateTime.now();
    _startSilenceWatch();
    _logger.i('[Whisper] recording… background:$background');
  }

  /// Auto-stop after a short silence (conversational endpointing), mirroring the
  /// system recognizer's pauseFor behaviour.
  void _startSilenceWatch() {
    _ampSub?.cancel();
    _ampSub = _recorder
        .onAmplitudeChanged(const Duration(milliseconds: 250))
        .listen((amp) {
      // amp.current is dBFS (~ -160 = silence, 0 = loud). Above ~-35dB = speech.
      if (amp.current > -35) {
        _lastLoud = DateTime.now();
        if (amp.current > -25) {
          _partialController.add("🗣️");
        }
      }
    });

    _silenceTimer?.cancel();
    _silenceTimer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      if (!_isListening) return;
      final since = DateTime.now().difference(_lastLoud ?? DateTime.now());
      if (since.inMilliseconds >= AppConstants.silenceThresholdMs) {
        _logger.i('[Whisper] silence → stop');
        stopListening();
      }
    });
  }

  @override
  Future<void> stopListening() async {
    if (!_isListening) return;
    _isListening = false;
    _silenceTimer?.cancel();
    await _ampSub?.cancel();

    String? path;
    try {
      path = await _recorder.stop();
    } catch (e) {
      _logger.e('[Whisper] stop error: $e');
    }
    path ??= _recordPath;
    if (path == null) {
      _errorController.add('no_audio');
      return;
    }
    await _transcribe(path);
  }

  Future<void> _transcribe(String path) async {
    try {
      _logger.i('[Whisper] transcribing ($_lang)…');
      final sw = Stopwatch()..start();
      
      final modelPath = await _whisper.getPath(_model);
      final whisper = Whisper(model: _model);
      final response = await whisper.transcribe(
        transcribeRequest: TranscribeRequest(
          audio: path,
          language: _lang,
          isTranslate: false,
          isNoTimestamps: true,
          isRealtime: true,
          threads: 4,     // 4 threads prevents context thrashing on mobile ARM cores
          speedUp: true,  // 2x speedup via whisper.cpp optimized beam search config
        ),
        modelPath: modelPath,
      );
      
      sw.stop();
      final text = response.text.trim();
      _logger.i('[Whisper] done in ${sw.elapsedMilliseconds}ms: "$text"');
      if (text.isEmpty) {
        _errorController.add('no_match');
      } else {
        _finalController.add(text);
      }
    } catch (e) {
      _logger.e('[Whisper] transcribe failed: $e');
      _errorController.add('transcribe_error');
    }
  }

  Future<void> cancelListening() async {
    _isListening = false;
    _silenceTimer?.cancel();
    await _ampSub?.cancel();
    try {
      await _recorder.cancel();
    } catch (_) {}
  }

  void dispose() {
    _silenceTimer?.cancel();
    _ampSub?.cancel();
    _recorder.dispose();
    _partialController.close();
    _finalController.close();
    _errorController.close();
    _downloadController.close();
  }
}
