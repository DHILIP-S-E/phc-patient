// ============================================================
// PHC AI Assistant - Language Constants
// 12 Indian languages + English with locale mappings
// ============================================================

class LanguageConstants {
  LanguageConstants._();

  /// All supported languages with their metadata
  static const List<SupportedLanguage> supportedLanguages = [
    SupportedLanguage(
      code: 'en',
      name: 'English',
      nativeName: 'English',
      locale: 'en-IN',
      ttsLocale: 'en_IN',
      sttLocale: 'en_IN',
      script: 'Latin',
      flag: '🇮🇳',
    ),
    SupportedLanguage(
      code: 'hi',
      name: 'Hindi',
      nativeName: 'हिन्दी',
      locale: 'hi-IN',
      ttsLocale: 'hi_IN',
      sttLocale: 'hi_IN',
      script: 'Devanagari',
      flag: '🇮🇳',
    ),
    SupportedLanguage(
      code: 'ta',
      name: 'Tamil',
      nativeName: 'தமிழ்',
      locale: 'ta-IN',
      ttsLocale: 'ta_IN',
      sttLocale: 'ta_IN',
      script: 'Tamil',
      flag: '🇮🇳',
    ),
    SupportedLanguage(
      code: 'te',
      name: 'Telugu',
      nativeName: 'తెలుగు',
      locale: 'te-IN',
      ttsLocale: 'te_IN',
      sttLocale: 'te_IN',
      script: 'Telugu',
      flag: '🇮🇳',
    ),
    SupportedLanguage(
      code: 'ml',
      name: 'Malayalam',
      nativeName: 'മലയാളം',
      locale: 'ml-IN',
      ttsLocale: 'ml_IN',
      sttLocale: 'ml_IN',
      script: 'Malayalam',
      flag: '🇮🇳',
    ),
    SupportedLanguage(
      code: 'kn',
      name: 'Kannada',
      nativeName: 'ಕನ್ನಡ',
      locale: 'kn-IN',
      ttsLocale: 'kn_IN',
      sttLocale: 'kn_IN',
      script: 'Kannada',
      flag: '🇮🇳',
    ),
    SupportedLanguage(
      code: 'bn',
      name: 'Bengali',
      nativeName: 'বাংলা',
      locale: 'bn-IN',
      ttsLocale: 'bn_IN',
      sttLocale: 'bn_IN',
      script: 'Bengali',
      flag: '🇮🇳',
    ),
    SupportedLanguage(
      code: 'gu',
      name: 'Gujarati',
      nativeName: 'ગુજરાતી',
      locale: 'gu-IN',
      ttsLocale: 'gu_IN',
      sttLocale: 'gu_IN',
      script: 'Gujarati',
      flag: '🇮🇳',
    ),
    SupportedLanguage(
      code: 'mr',
      name: 'Marathi',
      nativeName: 'मराठी',
      locale: 'mr-IN',
      ttsLocale: 'mr_IN',
      sttLocale: 'mr_IN',
      script: 'Devanagari',
      flag: '🇮🇳',
    ),
    SupportedLanguage(
      code: 'pa',
      name: 'Punjabi',
      nativeName: 'ਪੰਜਾਬੀ',
      locale: 'pa-IN',
      ttsLocale: 'pa_IN',
      sttLocale: 'pa_IN',
      script: 'Gurmukhi',
      flag: '🇮🇳',
    ),
    SupportedLanguage(
      code: 'or',
      name: 'Odia',
      nativeName: 'ଓଡ଼ିଆ',
      locale: 'or-IN',
      ttsLocale: 'or_IN',
      sttLocale: 'or_IN',
      script: 'Odia',
      flag: '🇮🇳',
    ),
    SupportedLanguage(
      code: 'ur',
      name: 'Urdu',
      nativeName: 'اردو',
      locale: 'ur-IN',
      ttsLocale: 'ur_IN',
      sttLocale: 'ur_IN',
      script: 'Nastaliq',
      flag: '🇮🇳',
      isRtl: true,
    ),
  ];

  static const String defaultLanguageCode = 'en';

  static SupportedLanguage getLanguage(String code) {
    return supportedLanguages.firstWhere(
      (l) => l.code == code,
      orElse: () => supportedLanguages.first,
    );
  }
}

/// Immutable language descriptor
class SupportedLanguage {
  final String code;
  final String name;
  final String nativeName;
  final String locale;
  final String ttsLocale;
  final String sttLocale;
  final String script;
  final String flag;
  final bool isRtl;

  const SupportedLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.locale,
    required this.ttsLocale,
    required this.sttLocale,
    required this.script,
    required this.flag,
    this.isRtl = false,
  });
}
