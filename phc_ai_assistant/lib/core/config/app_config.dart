// ============================================================
// PHC AI Assistant - App Configuration (compile-time flags)
// ============================================================

enum SttEngine {
  /// Android system recognizer only: live word-by-word, but needs the language's
  /// speech pack installed on the device.
  system,

  /// Whisper only: fully offline, all Indian languages incl. Tamil, but
  /// transcribes AFTER you pause (not live word-by-word).
  whisper,

  /// Best of both: use the system recognizer (LIVE) when the language's pack is
  /// available, otherwise fall back to offline Whisper. Recommended.
  hybrid,
}

class AppConfig {
  AppConfig._();

  /// Speech-to-text engine strategy. Default hybrid = live where possible,
  /// offline Whisper where necessary (e.g. Tamil with no system pack).
  static const SttEngine sttEngine = SttEngine.hybrid;
}
