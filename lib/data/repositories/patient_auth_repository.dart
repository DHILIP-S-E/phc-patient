import '../api_client.dart';
import '../models/patient_auth_models.dart';

/// Wraps the public, unauthenticated OTP-login surface —
/// `phc_api/routers/patient_auth.py` (`/patients/auth/*`). Every call goes
/// through [ApiClient.unwrap], which throws [ApiException] on failure.
class PatientAuthRepository {
  final ApiClient _client;

  PatientAuthRepository(this._client);

  /// POST /patients/auth/request-otp — always returns `data: null` on
  /// success (see `schemas/patient_auth.py` — no response schema).
  Future<void> requestOtp(String mobile) {
    return _client.unwrap(
      () => _client.dio.post('/patients/auth/request-otp', data: {'mobile': mobile}),
      (_) {},
    );
  }

  /// POST /patients/auth/verify-otp.
  Future<VerifyOtpResult> verifyOtp(String mobile, String otp) {
    return _client.unwrap(
      () => _client.dio.post('/patients/auth/verify-otp', data: {'mobile': mobile, 'otp': otp}),
      (json) => VerifyOtpResult.fromJson(json as Map<String, dynamic>),
    );
  }

  /// POST /patients/auth/register — completes the "register" branch of
  /// verify-otp (no matching patient found for the verified phone number).
  /// [dob] is an ISO `yyyy-MM-dd` string, matching the backend's `date` field.
  Future<AuthTokenResult> register(
    String verifiedPhoneToken,
    String name,
    String? dob,
    String? gender,
  ) {
    return _client.unwrap(
      () => _client.dio.post(
        '/patients/auth/register',
        data: {
          'verified_phone_token': verifiedPhoneToken,
          'name': name,
          'dob': dob,
          'gender': gender,
        },
      ),
      (json) => AuthTokenResult.fromJson(json as Map<String, dynamic>),
    );
  }

  /// POST /patients/auth/select-patient — completes the "select_patient"
  /// branch of verify-otp (multiple patients share the verified phone number).
  Future<AuthTokenResult> selectPatient(String verifiedPhoneToken, int patientId) {
    return _client.unwrap(
      () => _client.dio.post(
        '/patients/auth/select-patient',
        data: {'verified_phone_token': verifiedPhoneToken, 'patient_id': patientId},
      ),
      (json) => AuthTokenResult.fromJson(json as Map<String, dynamic>),
    );
  }
}
