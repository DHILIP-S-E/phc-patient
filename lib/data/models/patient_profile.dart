import 'package:freezed_annotation/freezed_annotation.dart';

part 'patient_profile.freezed.dart';
part 'patient_profile.g.dart';

/// Mirrors `phc_api/schemas/patient_portal.py::PatientProfileResponse`
/// (GET /patients/me/profile) — read-time classification, nothing persisted.
/// `category` is one of "pregnant" | "child" | "ncd" | "tb" | "senior" | "adult".
@freezed
abstract class PatientProfile with _$PatientProfile {
  const factory PatientProfile({
    @JsonKey(name: 'patient_id') required int patientId,
    required String name,
    @JsonKey(name: 'age_years') int? ageYears,
    required String category,
    @JsonKey(name: 'is_high_risk') required bool isHighRisk,
    @JsonKey(name: 'has_pregnancy_record') required bool hasPregnancyRecord,
    @JsonKey(name: 'has_child_record') required bool hasChildRecord,
    @JsonKey(name: 'has_ncd_history') required bool hasNcdHistory,
    @JsonKey(name: 'has_tb_history') required bool hasTbHistory,
  }) = _PatientProfile;

  factory PatientProfile.fromJson(Map<String, dynamic> json) =>
      _$PatientProfileFromJson(json);
}
