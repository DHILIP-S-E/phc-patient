// ============================================================
// PHC AI Assistant - Text to Speech Data Source
// Android TTS with language support + lip sync callbacks
// ============================================================

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:logger/logger.dart';
import 'package:phc_ai_assistant/core/constants/language_constants.dart';

typedef LipSyncCallback = void Function(bool isSpeaking);

class TextToSpeechDataSource {
  final FlutterTts _tts = FlutterTts();
  final Logger _logger = Logger();

  LipSyncCallback? onSpeakingChanged;
  VoidCallback? onComplete;

  bool _isSpeaking = false;
  bool get isSpeaking => _isSpeaking;

  // ── Initialize ────────────────────────────────────────────
  Future<void> initialize() async {
    await _tts.setSharedInstance(true);
    await _tts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.playback,
      [
        IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
        IosTextToSpeechAudioCategoryOptions.mixWithOthers,
      ],
    );

    _tts.setStartHandler(() {
      _isSpeaking = true;
      onSpeakingChanged?.call(true);
      _logger.d('[TTS] Started speaking');
    });

    _tts.setCompletionHandler(() {
      _isSpeaking = false;
      onSpeakingChanged?.call(false);
      onComplete?.call();
      _logger.d('[TTS] Completed');
    });

    _tts.setErrorHandler((msg) {
      _isSpeaking = false;
      onSpeakingChanged?.call(false);
      _logger.e('[TTS] Error: $msg');
    });

    _tts.setCancelHandler(() {
      _isSpeaking = false;
      onSpeakingChanged?.call(false);
    });

    await _tts.awaitSpeakCompletion(true);
    _logger.i('[TTS] Initialized');
  }

  // ── Set Language ──────────────────────────────────────────
  Future<void> setLanguage(String languageCode) async {
    final lang = LanguageConstants.getLanguage(languageCode);
    final locale = lang.ttsLocale.replaceAll('_', '-'); // e.g. ta-IN
    try {
      // Don't force an English fallback on a non-1 return code — that was making
      // Tamil read in English even when the Tamil voice was installed. Set the
      // requested voice; only warn (don't override) if it isn't available.
      final avail = await _tts.isLanguageAvailable(locale);
      final isAvail =
          avail == true || avail == 1 || (avail is int && avail >= 1);
      final res = await _tts.setLanguage(locale);
      if (isAvail) {
        _logger.i('[TTS] Language set to $locale (res=$res)');
      } else {
        _logger.w('[TTS] "$locale" voice is NOT installed on this device, so '
            'speech will sound wrong/English. Install it: Settings > System > '
            'Languages & input > Text-to-speech output > (engine) > Install voice '
            'data > ${lang.name}.');
      }
    } catch (e) {
      _logger.e('[TTS] setLanguage($locale) failed: $e');
    }
  }


  /// Whether the on-device TTS voice for [languageCode] is installed.
  Future<bool> isLanguageAvailable(String languageCode) async {
    final lang = LanguageConstants.getLanguage(languageCode);
    final locale = lang.ttsLocale.replaceAll('_', '-');
    try {
      final avail = await _tts.isLanguageAvailable(locale);
      return avail == true || avail == 1 || (avail is int && avail >= 1);
    } catch (e) {
      _logger.w('[TTS] isLanguageAvailable($locale) failed: $e');
      return false;
    }
  }

  // ── Configure Voice Parameters ────────────────────────────
  Future<void> configure({
    double? speechRate,
    double? pitch,
    double? volume,
  }) async {
    if (speechRate != null) await _tts.setSpeechRate(speechRate);
    if (pitch != null) await _tts.setPitch(pitch);
    if (volume != null) await _tts.setVolume(volume);
  }

  // ── Speak ─────────────────────────────────────────────────
  Future<void> speak(String text) async {
    if (text.isEmpty) return;
    await stop();
    await _tts.speak(text);
  }

  /// Speak a chunk sequentially without stopping current playback (for queued streaming)
  Future<void> speakSequential(String text) async {
    if (text.isEmpty) return;
    await _tts.speak(text);
  }

  // ── Stop ──────────────────────────────────────────────────
  Future<void> stop() async {
    if (_isSpeaking) {
      await _tts.stop();
      _isSpeaking = false;
      onSpeakingChanged?.call(false);
    }
  }

  // ── Pause ─────────────────────────────────────────────────
  Future<void> pause() async {
    if (_isSpeaking) {
      await _tts.pause();
    }
  }

  // ── Get Available Languages ───────────────────────────────
  Future<List<dynamic>> getLanguages() async {
    return await _tts.getLanguages;
  }

  void dispose() {
    _tts.stop();
  }
}
