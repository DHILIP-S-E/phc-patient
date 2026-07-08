// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VisitItem _$VisitItemFromJson(Map<String, dynamic> json) => _VisitItem(
  id: (json['id'] as num).toInt(),
  facilityId: (json['facility_id'] as num).toInt(),
  opNumber: json['op_number'] as String,
  visitDate: json['visit_date'] as String,
  visitType: json['visit_type'] as String,
  status: json['status'] as String,
  queueToken: (json['queue_token'] as num?)?.toInt(),
  priority: json['priority'] as String,
  calledAt: json['called_at'] as String?,
);

Map<String, dynamic> _$VisitItemToJson(_VisitItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'facility_id': instance.facilityId,
      'op_number': instance.opNumber,
      'visit_date': instance.visitDate,
      'visit_type': instance.visitType,
      'status': instance.status,
      'queue_token': instance.queueToken,
      'priority': instance.priority,
      'called_at': instance.calledAt,
    };

_QueueStatus _$QueueStatusFromJson(Map<String, dynamic> json) => _QueueStatus(
  hasActiveVisit: json['has_active_visit'] as bool,
  visit: json['visit'] == null
      ? null
      : VisitItem.fromJson(json['visit'] as Map<String, dynamic>),
);

Map<String, dynamic> _$QueueStatusToJson(_QueueStatus instance) =>
    <String, dynamic>{
      'has_active_visit': instance.hasActiveVisit,
      'visit': instance.visit,
    };
