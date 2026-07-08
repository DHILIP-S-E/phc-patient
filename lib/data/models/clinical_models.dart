import 'package:freezed_annotation/freezed_annotation.dart';

part 'clinical_models.freezed.dart';
part 'clinical_models.g.dart';

/// Mirrors `phc_api/schemas/patient_portal.py::LabTestItem`
/// (GET /patients/me/lab-tests). `status` is a `LabTestStatus` enum on the
/// backend — modeled as raw String here (wire value equals the member name).
@freezed
abstract class LabTestItem with _$LabTestItem {
  const factory LabTestItem({
    required int id,
    @JsonKey(name: 'visit_id') required int visitId,
    @JsonKey(name: 'test_id') required int testId,
    required String status,
    @JsonKey(name: 'result_value') String? resultValue,
    @JsonKey(name: 'result_notes') String? resultNotes,
    String? unit,
    @JsonKey(name: 'reference_range') String? referenceRange,
    @JsonKey(name: 'completed_at') String? completedAt,
  }) = _LabTestItem;

  factory LabTestItem.fromJson(Map<String, dynamic> json) => _$LabTestItemFromJson(json);
}

/// Mirrors `phc_api/schemas/patient_portal.py::ReferralItem`
/// (GET /patients/me/referrals).
@freezed
abstract class ReferralItem with _$ReferralItem {
  const factory ReferralItem({
    required int id,
    @JsonKey(name: 'from_facility_id') required int fromFacilityId,
    @JsonKey(name: 'to_facility_id') required int toFacilityId,
    String? reason,
    @JsonKey(name: 'referred_at') required String referredAt,
    required String status,
  }) = _ReferralItem;

  factory ReferralItem.fromJson(Map<String, dynamic> json) => _$ReferralItemFromJson(json);
}

/// Mirrors `phc_api/schemas/patient_portal.py::NotificationItem`
/// (GET /patients/me/notifications).
@freezed
abstract class NotificationItem with _$NotificationItem {
  const factory NotificationItem({
    required int id,
    required String module,
    @JsonKey(name: 'notification_type') required String notificationType,
    required String channel,
    @JsonKey(name: 'message_text') required String messageText,
    required String status,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _NotificationItem;

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemFromJson(json);
}
