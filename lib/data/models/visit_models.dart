import 'package:freezed_annotation/freezed_annotation.dart';

part 'visit_models.freezed.dart';
part 'visit_models.g.dart';

/// Mirrors `phc_api/schemas/patient_portal.py::VisitItem`
/// (GET /patients/me/visits, and nested in QueueStatusResponse).
/// `visit_type` is a `VisitType` enum, `status` a `VisitStatus` enum and
/// `priority` a `QueuePriority` enum on the backend — modeled as raw String
/// here (their wire value equals the enum member name).
@freezed
abstract class VisitItem with _$VisitItem {
  const factory VisitItem({
    required int id,
    @JsonKey(name: 'facility_id') required int facilityId,
    @JsonKey(name: 'op_number') required String opNumber,
    @JsonKey(name: 'visit_date') required String visitDate,
    @JsonKey(name: 'visit_type') required String visitType,
    required String status,
    @JsonKey(name: 'queue_token') int? queueToken,
    required String priority,
    @JsonKey(name: 'called_at') String? calledAt,
  }) = _VisitItem;

  factory VisitItem.fromJson(Map<String, dynamic> json) => _$VisitItemFromJson(json);
}

/// Mirrors `phc_api/schemas/patient_portal.py::QueueStatusResponse`
/// (GET /patients/me/queue-status).
@freezed
abstract class QueueStatus with _$QueueStatus {
  const factory QueueStatus({
    @JsonKey(name: 'has_active_visit') required bool hasActiveVisit,
    VisitItem? visit,
  }) = _QueueStatus;

  factory QueueStatus.fromJson(Map<String, dynamic> json) => _$QueueStatusFromJson(json);
}
