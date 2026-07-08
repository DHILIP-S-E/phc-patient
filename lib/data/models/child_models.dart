import 'package:freezed_annotation/freezed_annotation.dart';

part 'child_models.freezed.dart';
part 'child_models.g.dart';

/// Mirrors `phc_api/schemas/patient_portal.py::ChildDetailResponse`
/// (GET /patients/me/child) — a child's own patient row plus growth/
/// vaccination history.
@freezed
abstract class ChildDetail with _$ChildDetail {
  const factory ChildDetail({
    @JsonKey(name: 'patient_id') required int patientId,
    @JsonKey(name: 'birth_date') String? birthDate,
    @JsonKey(name: 'delivery_type') String? deliveryType,
    @JsonKey(name: 'is_high_priority') required bool isHighPriority,
    @JsonKey(name: 'growth_records')
    @Default(<GrowthRecordItem>[])
    List<GrowthRecordItem> growthRecords,
    @JsonKey(name: 'vaccination_schedule')
    @Default(<VaccinationScheduleItem>[])
    List<VaccinationScheduleItem> vaccinationSchedule,
    @JsonKey(name: 'vaccination_records')
    @Default(<VaccinationRecordItem>[])
    List<VaccinationRecordItem> vaccinationRecords,
  }) = _ChildDetail;

  factory ChildDetail.fromJson(Map<String, dynamic> json) => _$ChildDetailFromJson(json);
}

/// Mirrors `phc_api/schemas/patient_portal.py::GrowthRecordItem`.
@freezed
abstract class GrowthRecordItem with _$GrowthRecordItem {
  const factory GrowthRecordItem({
    required int id,
    @JsonKey(name: 'record_date') required String recordDate,
    @JsonKey(name: 'weight_kg') double? weightKg,
    @JsonKey(name: 'height_cm') double? heightCm,
    @JsonKey(name: 'muac_cm') double? muacCm,
    @JsonKey(name: 'is_underweight') required bool isUnderweight,
    @JsonKey(name: 'is_stunted') required bool isStunted,
    @JsonKey(name: 'is_wasted') required bool isWasted,
  }) = _GrowthRecordItem;

  factory GrowthRecordItem.fromJson(Map<String, dynamic> json) =>
      _$GrowthRecordItemFromJson(json);
}

/// Mirrors `phc_api/schemas/patient_portal.py::VaccinationScheduleItem`.
@freezed
abstract class VaccinationScheduleItem with _$VaccinationScheduleItem {
  const factory VaccinationScheduleItem({
    required int id,
    @JsonKey(name: 'vaccine_name') required String vaccineName,
    @JsonKey(name: 'dose_number') int? doseNumber,
    @JsonKey(name: 'scheduled_date') required String scheduledDate,
    required String status,
  }) = _VaccinationScheduleItem;

  factory VaccinationScheduleItem.fromJson(Map<String, dynamic> json) =>
      _$VaccinationScheduleItemFromJson(json);
}

/// Mirrors `phc_api/schemas/patient_portal.py::VaccinationRecordItem`.
@freezed
abstract class VaccinationRecordItem with _$VaccinationRecordItem {
  const factory VaccinationRecordItem({
    required int id,
    @JsonKey(name: 'vaccine_name') required String vaccineName,
    @JsonKey(name: 'dose_number') int? doseNumber,
    @JsonKey(name: 'administered_date') required String administeredDate,
  }) = _VaccinationRecordItem;

  factory VaccinationRecordItem.fromJson(Map<String, dynamic> json) =>
      _$VaccinationRecordItemFromJson(json);
}
