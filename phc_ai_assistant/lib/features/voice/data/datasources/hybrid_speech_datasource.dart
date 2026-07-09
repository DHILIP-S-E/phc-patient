// ============================================================
// PHC AI Assistant - Hybrid Speech Recognizer
// Picks the best engine per language:
//   • language pack installed  → Android system recognizer (LIVE word-by-word)
//   • pack missing (e.g. Tamil) → offline Whisper (transcribes after the pause)
// ============================================================

import 'dart:async';
import 'package:logger/logger.dart';
import 'speech_recognizer.dart';
import 'speech_to_text_datasource.dart';
import 'whisper_speech_datasource.dart';

class HybridSpeechRecognizer implements SpeechRecognizer {
  final SpeechToTextDataSource _system;
  final WhisperSpeechDataSource _whisper;
  final Logger _logger = Logger();

  // Single unified output streams that the BLoC subscribes to.
  final _partial = StreamController<String>.broadcast();
  final _final = StreamController<String>.broadcast();
  final _errors = StreamController<String>.broadcast();
  final _download = StreamController<double>.broadcast();

  // Per-engine subscriptions — reconnected each startListening so we
  // only forward events from the engine that is actually active.
  StreamSubscription<String>? _partialSub;
  StreamSubscription<String>? _finalSub;
  StreamSubscription<String>? _errorSub;

  String _lang = 'en';
  SpeechRecognizer? _active; // engine handling the current utterance

  HybridSpeechRecognizer(this._system, this._whisper) {
    // Wire download progress (only Whisper downloads a model).
    _whisper.modelDownloadProgress.listen(_download.add);
  }

  @override
  Stream<String> get partialResults => _partial.stream;
  @override
  Stream<String> get finalResults => _final.stream;
  @override
  Stream<String> get errors => _errors.stream;
  @override
  Stream<double> get modelDownloadProgress => _download.stream;
  @override
  bool get isReady => true; // one engine or the other is always usable

  @override
  Future<bool> initialize() async {
    final a = await _system.initialize();
    final b = await _whisper.initialize();
    return a || b;
  }

  @override
  void setLanguage(String languageCode) {
    _lang = languageCode;
    _system.setLanguage(languageCode);
    _whisper.setLanguage(languageCode);
    // If the system recognizer has no pack for this language, warm up the
    // Whisper model in the background so it's ready before the user speaks.
    _system.isLanguageAvailable(languageCode).then((sysOk) {
      if (!sysOk) {
        _logger.i('[Hybrid] "$languageCode" has no system pack — prefetching '
            'Whisper model for offline fallback.');
        _whisper.prefetchModel();
      }
    });
  }

  @override
  Future<bool> isLanguageAvailable(String languageCode) async {
    // Always true: Whisper covers anything the system recognizer can't.
    return true;
  }

  /// Wire output streams from [engine] to our unified controllers.
  /// Cancels any previously active subscriptions first.
  void _attachEngine(SpeechRecognizer engine) {
    _partialSub?.cancel();
    _finalSub?.cancel();
    _errorSub?.cancel();

    _partialSub = engine.partialResults.listen(_partial.add);
    _finalSub   = engine.finalResults.listen(_final.add);
    _errorSub   = engine.errors.listen(_errors.add);
  }

  @override
  Future<void> startListening({bool background = false}) async {
    // Stop whatever was running first.
    await _active?.stopListening();

    final sysOk = await _system.isLanguageAvailable(_lang);
    _active = sysOk ? _system : _whisper;
    _logger.i('[Hybrid] "$_lang" → ${sysOk ? 'system (live)' : 'Whisper (offline)'} '
        'background:$background');

    // Re-wire streams so only the active engine's events reach the BLoC.
    _attachEngine(_active!);

    await _active!.startListening(background: background);
  }

  @override
  Future<void> stopListening() async {
    await _active?.stopListening();
  }
}
