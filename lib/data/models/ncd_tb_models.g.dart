// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ncd_tb_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NcdScreeningItem _$NcdScreeningItemFromJson(Map<String, dynamic> json) =>
    _NcdScreeningItem(
      id: (json['id'] as num).toInt(),
      screeningDate: json['screening_date'] as String,
      bpSystolic: (json['bp_systolic'] as num?)?.toInt(),
      bpDiastolic: (json['bp_diastolic'] as num?)?.toInt(),
      bloodSugarMgdl: (json['blood_sugar_mgdl'] as num?)?.toDouble(),
      bmi: (json['bmi'] as num?)?.toDouble(),
      riskLevel: json['risk_level'] as String?,
      referralFlag: json['referral_flag'] as bool,
    );

Map<String, dynamic> _$NcdScreeningItemToJson(_NcdScreeningItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'screening_date': instance.screeningDate,
      'bp_systolic': instance.bpSystolic,
      'bp_diastolic': instance.bpDiastolic,
      'blood_sugar_mgdl': instance.bloodSugarMgdl,
      'bmi': instance.bmi,
      'risk_level': instance.riskLevel,
      'referral_flag': instance.referralFlag,
    };

_TbScreeningItem _$TbScreeningItemFromJson(Map<String, dynamic> json) =>
    _TbScreeningItem(
      id: (json['id'] as num).toInt(),
      screeningDate: json['screening_date'] as String,
      isSuspected: json['is_suspected'] as bool,
      referralFlag: json['referral_flag'] as bool,
    );

Map<String, dynamic> _$TbScreeningItemToJson(_TbScreeningItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'screening_date': instance.screeningDate,
      'is_suspected': instance.isSuspected,
      'referral_flag': instance.referralFlag,
    };
