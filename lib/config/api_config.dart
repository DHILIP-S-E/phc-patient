/// Backend base URL. Match the CORS_ORIGINS entry in phc_api's .env by
/// always launching this app with `flutter run -d chrome --web-port=3000` —
/// CORS_ORIGINS has no wildcard fallback since allow_credentials=True.
class ApiConfig {
  static const String baseUrl = 'http://localhost:8001/api/v1';

  /// WS upgrade of the same host/port — CORS doesn't apply to the socket
  /// upgrade itself, only [baseUrl]'s regular HTTP calls need CORS_ORIGINS.
  static String get liveAssistantWsUrl =>
      '${baseUrl.replaceFirst('http', 'ws')}/patients/me/live-assistant/ws';
}
