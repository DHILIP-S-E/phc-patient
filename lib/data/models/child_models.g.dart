// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChildDetail _$ChildDetailFromJson(Map<String, dynamic> json) => _ChildDetail(
  patientId: (json['patient_id'] as num).toInt(),
  birthDate: json['birth_date'] as String?,
  deliveryType: json['delivery_type'] as String?,
  isHighPriority: json['is_high_priority'] as bool,
  growthRecords:
      (json['growth_records'] as List<dynamic>?)
          ?.map((e) => GrowthRecordItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <GrowthRecordItem>[],
  vaccinationSchedule:
      (json['vaccination_schedule'] as List<dynamic>?)
          ?.map(
            (e) => VaccinationScheduleItem.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <VaccinationScheduleItem>[],
  vaccinationRecords:
      (json['vaccination_records'] as List<dynamic>?)
          ?.map(
            (e) => VaccinationRecordItem.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <VaccinationRecordItem>[],
);

Map<String, dynamic> _$ChildDetailToJson(_ChildDetail instance) =>
    <String, dynamic>{
      'patient_id': instance.patientId,
      'birth_date': instance.birthDate,
      'delivery_type': instance.deliveryType,
      'is_high_priority': instance.isHighPriority,
      'growth_records': instance.growthRecords,
      'vaccination_schedule': instance.vaccinationSchedule,
      'vaccination_records': instance.vaccinationRecords,
    };

_GrowthRecordItem _$GrowthRecordItemFromJson(Map<String, dynamic> json) =>
    _GrowthRecordItem(
      id: (json['id'] as num).toInt(),
      recordDate: json['record_date'] as String,
      weightKg: (json['weight_kg'] as num?)?.toDouble(),
      heightCm: (json['height_cm'] as num?)?.toDouble(),
      muacCm: (json['muac_cm'] as num?)?.toDouble(),
      isUnderweight: json['is_underweight'] as bool,
      isStunted: json['is_stunted'] as bool,
      isWasted: json['is_wasted'] as bool,
    );

Map<String, dynamic> _$GrowthRecordItemToJson(_GrowthRecordItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'record_date': instance.recordDate,
      'weight_kg': instance.weightKg,
      'height_cm': instance.heightCm,
      'muac_cm': instance.muacCm,
      'is_underweight': instance.isUnderweight,
      'is_stunted': instance.isStunted,
      'is_wasted': instance.isWasted,
    };

_VaccinationScheduleItem _$VaccinationScheduleItemFromJson(
  Map<String, dynamic> json,
) => _VaccinationScheduleItem(
  id: (json['id'] as num).toInt(),
  vaccineName: json['vaccine_name'] as String,
  doseNumber: (json['dose_number'] as num?)?.toInt(),
  scheduledDate: json['scheduled_date'] as String,
  status: json['status'] as String,
);

Map<String, dynamic> _$VaccinationScheduleItemToJson(
  _VaccinationScheduleItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'vaccine_name': instance.vaccineName,
  'dose_number': instance.doseNumber,
  'scheduled_date': instance.scheduledDate,
  'status': instance.status,
};

_VaccinationRecordItem _$VaccinationRecordItemFromJson(
  Map<String, dynamic> json,
) => _VaccinationRecordItem(
  id: (json['id'] as num).toInt(),
  vaccineName: json['vaccine_name'] as String,
  doseNumber: (json['dose_number'] as num?)?.toInt(),
  administeredDate: json['administered_date'] as String,
);

Map<String, dynamic> _$VaccinationRecordItemToJson(
  _VaccinationRecordItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'vaccine_name': instance.vaccineName,
  'dose_number': instance.doseNumber,
  'administered_date': instance.administeredDate,
};
