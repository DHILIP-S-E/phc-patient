// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clinical_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LabTestItem _$LabTestItemFromJson(Map<String, dynamic> json) => _LabTestItem(
  id: (json['id'] as num).toInt(),
  visitId: (json['visit_id'] as num).toInt(),
  testId: (json['test_id'] as num).toInt(),
  status: json['status'] as String,
  resultValue: json['result_value'] as String?,
  resultNotes: json['result_notes'] as String?,
  unit: json['unit'] as String?,
  referenceRange: json['reference_range'] as String?,
  completedAt: json['completed_at'] as String?,
);

Map<String, dynamic> _$LabTestItemToJson(_LabTestItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'visit_id': instance.visitId,
      'test_id': instance.testId,
      'status': instance.status,
      'result_value': instance.resultValue,
      'result_notes': instance.resultNotes,
      'unit': instance.unit,
      'reference_range': instance.referenceRange,
      'completed_at': instance.completedAt,
    };

_ReferralItem _$ReferralItemFromJson(Map<String, dynamic> json) =>
    _ReferralItem(
      id: (json['id'] as num).toInt(),
      fromFacilityId: (json['from_facility_id'] as num).toInt(),
      toFacilityId: (json['to_facility_id'] as num).toInt(),
      reason: json['reason'] as String?,
      referredAt: json['referred_at'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$ReferralItemToJson(_ReferralItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'from_facility_id': instance.fromFacilityId,
      'to_facility_id': instance.toFacilityId,
      'reason': instance.reason,
      'referred_at': instance.referredAt,
      'status': instance.status,
    };

_NotificationItem _$NotificationItemFromJson(Map<String, dynamic> json) =>
    _NotificationItem(
      id: (json['id'] as num).toInt(),
      module: json['module'] as String,
      notificationType: json['notification_type'] as String,
      channel: json['channel'] as String,
      messageText: json['message_text'] as String,
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$NotificationItemToJson(_NotificationItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'module': instance.module,
      'notification_type': instance.notificationType,
      'channel': instance.channel,
      'message_text': instance.messageText,
      'status': instance.status,
      'created_at': instance.createdAt,
    };
