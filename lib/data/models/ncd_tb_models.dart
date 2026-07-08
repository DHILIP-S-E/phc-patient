import 'package:freezed_annotation/freezed_annotation.dart';

part 'ncd_tb_models.freezed.dart';
part 'ncd_tb_models.g.dart';

/// Mirrors `phc_api/schemas/patient_portal.py::NcdScreeningItem`
/// (GET /patients/me/ncd).
@freezed
abstract class NcdScreeningItem with _$NcdScreeningItem {
  const factory NcdScreeningItem({
    required int id,
    @JsonKey(name: 'screening_date') required String screeningDate,
    @JsonKey(name: 'bp_systolic') int? bpSystolic,
    @JsonKey(name: 'bp_diastolic') int? bpDiastolic,
    @JsonKey(name: 'blood_sugar_mgdl') double? bloodSugarMgdl,
    double? bmi,
    @JsonKey(name: 'risk_level') String? riskLevel,
    @JsonKey(name: 'referral_flag') required bool referralFlag,
  }) = _NcdScreeningItem;

  factory NcdScreeningItem.fromJson(Map<String, dynamic> json) =>
      _$NcdScreeningItemFromJson(json);
}

/// Mirrors `phc_api/schemas/patient_portal.py::TbScreeningItem`
/// (GET /patients/me/tb).
@freezed
abstract class TbScreeningItem with _$TbScreeningItem {
  const factory TbScreeningItem({
    required int id,
    @JsonKey(name: 'screening_date') required String screeningDate,
    @JsonKey(name: 'is_suspected') required bool isSuspected,
    @JsonKey(name: 'referral_flag') required bool referralFlag,
  }) = _TbScreeningItem;

  factory TbScreeningItem.fromJson(Map<String, dynamic> json) =>
      _$TbScreeningItemFromJson(json);
}
