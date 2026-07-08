import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists the patient's access token (issued by /patients/auth/*) across
/// app restarts. Deliberately holds only the access token — Phase 1 has no
/// refresh-token rotation (see phc_api CLAUDE.md's "Citizen Patient Portal"
/// section), the 30-day token lifetime stands in for it.
class TokenStorage {
  static const _tokenKey = 'patient_access_token';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> readToken() => _storage.read(key: _tokenKey);

  Future<void> saveToken(String token) => _storage.write(key: _tokenKey, value: token);

  Future<void> clearToken() => _storage.delete(key: _tokenKey);
}
