import 'package:freezed_annotation/freezed_annotation.dart';

part 'pregnancy_models.freezed.dart';
part 'pregnancy_models.g.dart';

/// Mirrors `phc_api/schemas/patient_portal.py::PregnancyDetailResponse`
/// (GET /patients/me/pregnancy) — a pregnancy plus its ANC visit history.
@freezed
abstract class PregnancyDetail with _$PregnancyDetail {
  const factory PregnancyDetail({
    @JsonKey(name: 'pregnancy_id') required int pregnancyId,
    @JsonKey(name: 'lmp_date') String? lmpDate,
    @JsonKey(name: 'edd_date') String? eddDate,
    int? gravida,
    int? para,
    required String status,
    @JsonKey(name: 'is_high_priority') required bool isHighPriority,
    @JsonKey(name: 'has_high_bp') bool? hasHighBp,
    @JsonKey(name: 'has_diabetes') bool? hasDiabetes,
    @JsonKey(name: 'has_severe_anaemia') bool? hasSevereAnaemia,
    @JsonKey(name: 'anc_visits') @Default(<AncVisitItem>[]) List<AncVisitItem> ancVisits,
  }) = _PregnancyDetail;

  factory PregnancyDetail.fromJson(Map<String, dynamic> json) =>
      _$PregnancyDetailFromJson(json);
}

/// Mirrors `phc_api/schemas/patient_portal.py::AncVisitItem`.
@freezed
abstract class AncVisitItem with _$AncVisitItem {
  const factory AncVisitItem({
    required int id,
    @JsonKey(name: 'visit_number') required int visitNumber,
    @JsonKey(name: 'visit_date') required String visitDate,
    @JsonKey(name: 'bp_systolic') int? bpSystolic,
    @JsonKey(name: 'bp_diastolic') int? bpDiastolic,
    @JsonKey(name: 'weight_kg') double? weightKg,
    @JsonKey(name: 'hemoglobin_g_dl') double? hemoglobinGDl,
    @JsonKey(name: 'next_visit_due_date') String? nextVisitDueDate,
  }) = _AncVisitItem;

  factory AncVisitItem.fromJson(Map<String, dynamic> json) => _$AncVisitItemFromJson(json);
}
