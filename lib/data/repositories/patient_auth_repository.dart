import '../api_client.dart';
import '../models/patient_auth_models.dart';

/// Wraps the public, unauthenticated OTP-login surface —
/// `phc_api/routers/patient_auth.py` (`/patients/auth/*`). Every call goes
/// through [ApiClient.unwrap], which throws [ApiException] on failure.
class PatientAuthRepository {
  final ApiClient _client;

  PatientAuthRepository(this._client);

  /// POST /patients/auth/request-otp — always returns `data: null` on
  /// success (see `schemas/patient_auth.py` — no response schema). [email]
  /// is optional dual-channel delivery — if set, the OTP is also emailed in
  /// parallel with the WhatsApp/SMS send.
  Future<void> requestOtp(String mobile, {String? email}) {
    return _client.unwrap(
      () => _client.dio.post(
        '/patients/auth/request-otp',
        data: {'mobile': mobile, if (email != null && email.isNotEmpty) 'email': email},
      ),
      (_) {},
    );
  }

  /// POST /patients/auth/verify-otp. Exactly one of [mobile]/[email] should
  /// be non-null — mirrors the backend's "exactly one identifier" contract.
  /// This app always verifies via [mobile] today (the identifier collected
  /// on [MobileEntryScreen]); [email] exists for forward-compatibility.
  Future<VerifyOtpResult> verifyOtp(String otp, {String? mobile, String? email}) {
    return _client.unwrap(
      () => _client.dio.post(
        '/patients/auth/verify-otp',
        data: {'otp': otp, if (mobile != null) 'mobile': mobile, if (email != null) 'email': email},
      ),
      (json) => VerifyOtpResult.fromJson(json as Map<String, dynamic>),
    );
  }

  /// POST /patients/auth/register — completes the "register" branch of
  /// verify-otp (no matching patient found for the verified phone number).
  /// [dob] is an ISO `yyyy-MM-dd` string, matching the backend's `date` field.
  /// [email] is optional, persisted onto the new `Patient.email` column.
  Future<AuthTokenResult> register(
    String verifiedPhoneToken,
    String name,
    String? dob,
    String? gender, {
    String? email,
  }) {
    return _client.unwrap(
      () => _client.dio.post(
        '/patients/auth/register',
        data: {
          'verified_phone_token': verifiedPhoneToken,
          'name': name,
          'dob': dob,
          'gender': gender,
          'email': email,
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
