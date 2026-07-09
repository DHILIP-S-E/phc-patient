// ============================================================
// PHC AI Assistant - Speech to Text Data Source
// Uses speech_to_text package (on-device ML Kit backend)
// ============================================================

import 'dart:async';
import 'package:logger/logger.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:phc_ai_assistant/core/constants/app_constants.dart';
import 'package:phc_ai_assistant/core/constants/language_constants.dart';
import 'speech_recognizer.dart';

class SpeechToTextDataSource implements SpeechRecognizer {
  final SpeechToText _stt = SpeechToText();
  final Logger _logger = Logger();

  bool _isInitialized = false;
  String _languageCode = 'en';
  String _currentLocale = 'en_IN';

  // VAD state
  Timer? _silenceTimer;
  String _lastRecognizedWords = '';
  bool _isFinalized = false;

  // When true this session was started for barge-in background recording.
  // Errors and final results from this session are suppressed (they would
  // incorrectly cancel AI speech / retrigger the loop).
  bool _isBackground = false;

  final _partialResultController = StreamController<String>.broadcast();
  final _finalResultController = StreamController<String>.broadcast();
  final _errorController = StreamController<String>.broadcast();

  @override
  Stream<String> get partialResults => _partialResultController.stream;
  @override
  Stream<String> get finalResults => _finalResultController.stream;
  @override
  Stream<String> get errors => _errorController.stream;

  // System recognizer needs no downloadable model — always "ready".
  @override
  Stream<double> get modelDownloadProgress => Stream<double>.value(1.0);
  @override
  bool get isReady => true;

  bool get isListening => _stt.isListening;

  // ── Initialize ────────────────────────────────────────────
  @override
  Future<bool> initialize() async {
    if (_isInitialized) return true;
    try {
      _isInitialized = await _stt.initialize(
        onError: (error) {
          _logger.e('[STT] Error: ${error.errorMsg}');
          // Only surface errors from the active (non-background) session.
          if (!_isBackground) {
            _errorController.add(error.errorMsg);
          } else {
            _logger.d('[STT] Suppressing background session error: ${error.errorMsg}');
          }
        },
        onStatus: (status) {
          _logger.d('[STT] Status: $status');
        },
        debugLogging: false,
      );
      _logger.i('[STT] Initialized: $_isInitialized');
      return _isInitialized;
    } catch (e) {
      _logger.e('[STT] Init failed: $e');
      return false;
    }
  }

  // ── Set Language ──────────────────────────────────────────
  @override
  void setLanguage(String languageCode) {
    _languageCode = languageCode;
    final lang = LanguageConstants.getLanguage(languageCode);
    _currentLocale = lang.sttLocale;
    _logger.d('[STT] Language requested: $languageCode (fallback $_currentLocale)');
  }

  /// Resolve the locale id the device's recognizer actually exposes for the
  /// selected language. Different phones report ids as "ta_IN" OR "ta-IN"; using
  /// the exact device id is what makes Tamil (and other Indian languages) truly
  /// engage instead of silently defaulting to English recognition.
  Future<String> _resolveLocaleId(String languageCode) async {
    try {
      if (!_isInitialized) await initialize();
      final locales = await _stt.locales();
      String norm(String s) => s.replaceAll('-', '_').toLowerCase();
      final want = languageCode.toLowerCase();

      // 1) Prefer the Indian variant, e.g. ta_IN.
      for (final l in locales) {
        if (norm(l.localeId) == '${want}_in') {
          _logger.i('[STT] Resolved "$languageCode" -> "${l.localeId}" (${l.name})');
          return l.localeId;
        }
      }
      // 2) Otherwise any locale for that language, e.g. ta_LK / ta.
      for (final l in locales) {
        final id = norm(l.localeId);
        if (id == want || id.startsWith('${want}_')) {
          _logger.i('[STT] Resolved "$languageCode" -> "${l.localeId}" (${l.name})');
          return l.localeId;
        }
      }
      _logger.w('[STT] No on-device speech locale for "$languageCode". Falling back to '
          '$_currentLocale.');
    } catch (e) {
      _logger.e('[STT] locale resolution failed: $e');
    }
    return _currentLocale;
  }

  /// Whether the device's speech recognizer has an offline/online locale for [languageCode].
  @override
  Future<bool> isLanguageAvailable(String languageCode) async {
    try {
      if (!_isInitialized) await initialize();
      final locales = await _stt.locales();
      String norm(String s) => s.replaceAll('-', '_').toLowerCase();
      final want = languageCode.toLowerCase();
      return locales.any((l) {
        final id = norm(l.localeId);
        return id == want || id.startsWith('${want}_');
      });
    } catch (e) {
      _logger.w('[STT] isLanguageAvailable failed: $e');
      return false;
    }
  }

  // ── Get Available Locales ─────────────────────────────────
  Future<List<LocaleName>> getAvailableLocales() async {
    if (!_isInitialized) await initialize();
    return _stt.locales();
  }

  // ── Start Listening ───────────────────────────────────────
  /// [background] = true means this session is for barge-in capture only.
  /// Partial results still flow (so the user can interrupt), but errors and
  /// final results that have no content are silently swallowed.
  @override
  Future<void> startListening({bool background = false}) async {
    if (!_isInitialized) {
      final ok = await initialize();
      if (!ok) throw Exception('STT not initialized');
    }

    if (_stt.isListening) {
      await _internalStop();
    }

    _isBackground = background;
    _isFinalized = false;
    _lastRecognizedWords = '';
    _silenceTimer?.cancel();

    final localeId = await _resolveLocaleId(_languageCode);
    _logger.i('[STT] Listening in "$_languageCode" locale:$localeId background:$background');

    await _stt.listen(
      listenOptions: SpeechListenOptions(
        localeId: localeId,
        // Long hard cap so the OS doesn't auto-stop after a short pause.
        // Our custom VAD timer handles the actual silence detection.
        listenFor: Duration(seconds: AppConstants.voiceListenTimeout),
        // Set pauseFor to a much longer value than our custom timer so the
        // OS endpoint doesn't race us (our 700ms timer wins first).
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        listenMode: ListenMode.dictation,
      ),
      onResult: (SpeechRecognitionResult result) {
        final words = result.recognizedWords.trim();
        if (words.isEmpty) return;

        if (_isFinalized) {
          _logger.d('[STT] Already finalized, ignoring: "$words"');
          return;
        }

        _lastRecognizedWords = words;

        // Always emit partials (needed for barge-in detection in background mode too).
        _partialResultController.add(words);

        // Reset custom silence VAD timer on every new word.
        _silenceTimer?.cancel();
        _silenceTimer = Timer(
          Duration(milliseconds: AppConstants.silenceThresholdMs),
          () async {
            if (_isFinalized) return;
            _logger.i('[STT] VAD silence → finalizing: "$_lastRecognizedWords"');
            _isFinalized = true;
            _silenceTimer?.cancel();

            final textToEmit = _lastRecognizedWords;
            await _internalStop();

            // In background mode, suppress empty finals but pass non-empty ones
            // through so the user CAN barge in with words.
            if (textToEmit.isNotEmpty && !_isBackground) {
              _finalResultController.add(textToEmit);
            } else if (textToEmit.isNotEmpty && _isBackground) {
              // Barge-in with actual words — surface as final so BLoC can handle it.
              _logger.i('[STT] Background barge-in words: "$textToEmit"');
              _finalResultController.add(textToEmit);
            }
          },
        );

        // Also honour OS-level finalResult (belt + suspenders).
        if (result.finalResult) {
          _logger.i('[STT] OS finalResult: "$words"');
          _silenceTimer?.cancel();
          if (!_isFinalized) {
            _isFinalized = true;
            if (!_isBackground || words.isNotEmpty) {
              _finalResultController.add(words);
            }
          }
        }
      },
    );
  }

  // ── Stop Listening ────────────────────────────────────────
  @override
  Future<void> stopListening() async {
    _silenceTimer?.cancel();
    _isBackground = false;
    await _internalStop();
  }

  Future<void> _internalStop() async {
    _silenceTimer?.cancel();
    if (_stt.isListening) {
      try {
        await _stt.stop();
      } catch (e) {
        _logger.w('[STT] stop() threw: $e');
      }
    }
  }

  // ── Cancel Listening ──────────────────────────────────────
  Future<void> cancelListening() async {
    _silenceTimer?.cancel();
    _isBackground = false;
    if (_stt.isListening) {
      await _stt.cancel();
    }
  }

  void dispose() {
    _silenceTimer?.cancel();
    _partialResultController.close();
    _finalResultController.close();
    _errorController.close();
    _stt.cancel();
  }
}
