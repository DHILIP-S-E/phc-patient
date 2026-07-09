// ============================================================
// PHC AI Assistant - App Constants
// ============================================================

class AppConstants {
  AppConstants._();

  static const String appName = 'PHC AI Assistant';
  static const String appVersion = '1.0.0';
  static const int appBuildNumber = 1;

  // ── SharedPreferences Keys ────────────────────────────────
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keySelectedLanguage = 'selected_language';
  static const String keyAvatarGender = 'avatar_gender';
  static const String keyTtsSpeed = 'tts_speed';
  static const String keyTtsPitch = 'tts_pitch';
  static const String keyModelVersion = 'model_version';
  static const String keyModelDownloaded = 'model_downloaded';
  static const String keyModelPath = 'model_path';
  static const String keyModelChecksum = 'model_checksum';

  // ── Hive Box Names ────────────────────────────────────────
  static const String hiveBoxSettings = 'settings';
  static const String hiveBoxModelMeta = 'model_meta';
  static const String hiveBoxConversation = 'conversation';

  // ── Animation Durations ───────────────────────────────────
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animNormal = Duration(milliseconds: 350);
  static const Duration animSlow = Duration(milliseconds: 600);
  static const Duration animVerySlow = Duration(milliseconds: 1000);

  // ── TTS Defaults ─────────────────────────────────────────
  static const double defaultTtsSpeed = 0.85;
  static const double defaultTtsPitch = 1.0;
  static const double defaultTtsVolume = 1.0;

  // ── Voice ─────────────────────────────────────────────────
  static const int voiceListenTimeout = 20; // seconds (hard cap for one utterance)
  static const double voiceConfidenceThreshold = 0.6;
  // Finalize ~1s after the user stops talking, so the reply comes right after
  // they pause (conversational) instead of waiting out the whole listen window.
  static const int silenceThresholdMs = 700; // ms of silence before finalizing

  // ── Avatar ────────────────────────────────────────────────
  static const String defaultAvatarGender = 'female';
  static const double avatarHeightRatio = 0.60; // 60% of screen height

  // ── UI ────────────────────────────────────────────────────
  static const double borderRadiusSm = 8.0;
  static const double borderRadiusMd = 16.0;
  static const double borderRadiusLg = 24.0;
  static const double borderRadiusXl = 32.0;
  static const double borderRadiusCircle = 100.0;

  static const double paddingSm = 8.0;
  static const double paddingMd = 16.0;
  static const double paddingLg = 24.0;
  static const double paddingXl = 32.0;

  // ── Healthcare Prompt System ──────────────────────────────
  static const int maxConversationHistory = 2;   // shorter prompt = faster
  static const int maxResponseTokens = 64;
}
