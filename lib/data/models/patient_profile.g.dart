// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PatientProfile _$PatientProfileFromJson(Map<String, dynamic> json) =>
    _PatientProfile(
      patientId: (json['patient_id'] as num).toInt(),
      name: json['name'] as String,
      ageYears: (json['age_years'] as num?)?.toInt(),
      category: json['category'] as String,
      isHighRisk: json['is_high_risk'] as bool,
      hasPregnancyRecord: json['has_pregnancy_record'] as bool,
      hasChildRecord: json['has_child_record'] as bool,
      hasNcdHistory: json['has_ncd_history'] as bool,
      hasTbHistory: json['has_tb_history'] as bool,
    );

Map<String, dynamic> _$PatientProfileToJson(_PatientProfile instance) =>
    <String, dynamic>{
      'patient_id': instance.patientId,
      'name': instance.name,
      'age_years': instance.ageYears,
      'category': instance.category,
      'is_high_risk': instance.isHighRisk,
      'has_pregnancy_record': instance.hasPregnancyRecord,
      'has_child_record': instance.hasChildRecord,
      'has_ncd_history': instance.hasNcdHistory,
      'has_tb_history': instance.hasTbHistory,
    };
