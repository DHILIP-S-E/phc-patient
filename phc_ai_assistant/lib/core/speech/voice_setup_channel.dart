import 'package:flutter/services.dart';

class VoiceSetupChannel {
  static const MethodChannel _channel = MethodChannel('com.example.phc_ai_assistant/voice_setup');

  Future<bool> initialize() async {
    try {
      return await _channel.invokeMethod<bool>('initialize') ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<void> openVoiceInputSettings() async {}
  Future<void> installTtsData() async {}
}
