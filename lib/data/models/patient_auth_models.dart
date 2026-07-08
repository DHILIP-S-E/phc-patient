import 'package:freezed_annotation/freezed_annotation.dart';

part 'patient_auth_models.freezed.dart';
part 'patient_auth_models.g.dart';

/// Mirrors `phc_api/schemas/patient_auth.py::PatientCandidate`. Deliberately
/// minimal — phone ownership is verified at this point but patient identity
/// is not, so no UHID/aadhaar/abha/address here.
@freezed
abstract class PatientCandidate with _$PatientCandidate {
  const factory PatientCandidate({required int id, required String name, String? dob}) =
      _PatientCandidate;

  factory PatientCandidate.fromJson(Map<String, dynamic> json) =>
      _$PatientCandidateFromJson(json);
}

/// Mirrors `phc_api/schemas/patient_auth.py::VerifyOtpResponse`.
/// `status` is one of "logged_in" | "select_patient" | "register".
@freezed
abstract class VerifyOtpResult with _$VerifyOtpResult {
  const factory VerifyOtpResult({
    required String status,
    @JsonKey(name: 'access_token') String? accessToken,
    @JsonKey(name: 'verified_phone_token') String? verifiedPhoneToken,
    @Default(<PatientCandidate>[]) List<PatientCandidate> candidates,
  }) = _VerifyOtpResult;

  factory VerifyOtpResult.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpResultFromJson(json);
}

/// Mirrors `phc_api/schemas/patient_auth.py::PatientAuthTokenResponse`,
/// returned by both `/register` and `/select-patient`.
@freezed
abstract class AuthTokenResult with _$AuthTokenResult {
  const factory AuthTokenResult({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'token_type') @Default('bearer') String tokenType,
    @JsonKey(name: 'patient_id') required int patientId,
  }) = _AuthTokenResult;

  factory AuthTokenResult.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenResultFromJson(json);
}
