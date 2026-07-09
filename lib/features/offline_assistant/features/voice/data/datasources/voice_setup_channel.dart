// ============================================================
// PHC AI Assistant - Voice Setup Channel
// Bridges to native Android to launch the OS voice-data downloaders. Android
// does NOT permit silently installing TTS/STT language packs (privacy/security),
// so the best achievable "auto-download" is one-tap: open the system installer
// for the selected language when its pack is missing.
// ============================================================

import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class VoiceSetupChannel {
  static const _channel = MethodChannel('phc_ai/voice_setup');
  final Logger _logger = Logger();

  /// Open the system Text-To-Speech voice-data downloader (for reading aloud).
  Future<void> installTtsData() async {
    try {
      await _channel.invokeMethod('installTtsData');
      _logger.i('[VoiceSetup] Launched TTS voice-data installer');
    } catch (e) {
      _logger.w('[VoiceSetup] installTtsData failed: $e');
    }
  }

  /// Open voice-input settings so the user can download offline speech
  /// recognition packs (for understanding speech in the language).
  Future<void> openVoiceInputSettings() async {
    try {
      await _channel.invokeMethod('openVoiceInputSettings');
      _logger.i('[VoiceSetup] Opened voice-input settings');
    } catch (e) {
      _logger.w('[VoiceSetup] openVoiceInputSettings failed: $e');
    }
  }
}
