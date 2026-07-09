// ============================================================
// PHC AI Assistant - App Configuration (compile-time flags)
// ============================================================

enum SttEngine {
  /// Android system recognizer only: live word-by-word, but needs the language's
  /// speech pack installed on the device.
  ///
  /// The original phc_ai_assistant also had a `whisper`/`hybrid` mode (offline
  /// Whisper fallback for languages with no installed system pack). That mode
  /// depended on `whisper_ggml`, which hard-pins `flutter_riverpod: ^2.6.1` in
  /// every published version — incompatible with phc-patient's Riverpod 3
  /// architecture. Dropped when porting into phc-patient; `system` is the only
  /// engine here.
  system,
}

class AppConfig {
  AppConfig._();

  static const SttEngine sttEngine = SttEngine.system;
}
