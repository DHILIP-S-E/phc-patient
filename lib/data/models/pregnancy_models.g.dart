// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pregnancy_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PregnancyDetail _$PregnancyDetailFromJson(Map<String, dynamic> json) =>
    _PregnancyDetail(
      pregnancyId: (json['pregnancy_id'] as num).toInt(),
      lmpDate: json['lmp_date'] as String?,
      eddDate: json['edd_date'] as String?,
      gravida: (json['gravida'] as num?)?.toInt(),
      para: (json['para'] as num?)?.toInt(),
      status: json['status'] as String,
      isHighPriority: json['is_high_priority'] as bool,
      hasHighBp: json['has_high_bp'] as bool?,
      hasDiabetes: json['has_diabetes'] as bool?,
      hasSevereAnaemia: json['has_severe_anaemia'] as bool?,
      ancVisits:
          (json['anc_visits'] as List<dynamic>?)
              ?.map((e) => AncVisitItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <AncVisitItem>[],
    );

Map<String, dynamic> _$PregnancyDetailToJson(_PregnancyDetail instance) =>
    <String, dynamic>{
      'pregnancy_id': instance.pregnancyId,
      'lmp_date': instance.lmpDate,
      'edd_date': instance.eddDate,
      'gravida': instance.gravida,
      'para': instance.para,
      'status': instance.status,
      'is_high_priority': instance.isHighPriority,
      'has_high_bp': instance.hasHighBp,
      'has_diabetes': instance.hasDiabetes,
      'has_severe_anaemia': instance.hasSevereAnaemia,
      'anc_visits': instance.ancVisits,
    };

_AncVisitItem _$AncVisitItemFromJson(Map<String, dynamic> json) =>
    _AncVisitItem(
      id: (json['id'] as num).toInt(),
      visitNumber: (json['visit_number'] as num).toInt(),
      visitDate: json['visit_date'] as String,
      bpSystolic: (json['bp_systolic'] as num?)?.toInt(),
      bpDiastolic: (json['bp_diastolic'] as num?)?.toInt(),
      weightKg: (json['weight_kg'] as num?)?.toDouble(),
      hemoglobinGDl: (json['hemoglobin_g_dl'] as num?)?.toDouble(),
      nextVisitDueDate: json['next_visit_due_date'] as String?,
    );

Map<String, dynamic> _$AncVisitItemToJson(_AncVisitItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'visit_number': instance.visitNumber,
      'visit_date': instance.visitDate,
      'bp_systolic': instance.bpSystolic,
      'bp_diastolic': instance.bpDiastolic,
      'weight_kg': instance.weightKg,
      'hemoglobin_g_dl': instance.hemoglobinGDl,
      'next_visit_due_date': instance.nextVisitDueDate,
    };
