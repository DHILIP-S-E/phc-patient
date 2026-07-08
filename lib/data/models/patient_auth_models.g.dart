// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PatientCandidate _$PatientCandidateFromJson(Map<String, dynamic> json) =>
    _PatientCandidate(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      dob: json['dob'] as String?,
    );

Map<String, dynamic> _$PatientCandidateToJson(_PatientCandidate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'dob': instance.dob,
    };

_VerifyOtpResult _$VerifyOtpResultFromJson(Map<String, dynamic> json) =>
    _VerifyOtpResult(
      status: json['status'] as String,
      accessToken: json['access_token'] as String?,
      verifiedPhoneToken: json['verified_phone_token'] as String?,
      candidates:
          (json['candidates'] as List<dynamic>?)
              ?.map((e) => PatientCandidate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <PatientCandidate>[],
    );

Map<String, dynamic> _$VerifyOtpResultToJson(_VerifyOtpResult instance) =>
    <String, dynamic>{
      'status': instance.status,
      'access_token': instance.accessToken,
      'verified_phone_token': instance.verifiedPhoneToken,
      'candidates': instance.candidates,
    };

_AuthTokenResult _$AuthTokenResultFromJson(Map<String, dynamic> json) =>
    _AuthTokenResult(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String? ?? 'bearer',
      patientId: (json['patient_id'] as num).toInt(),
    );

Map<String, dynamic> _$AuthTokenResultToJson(_AuthTokenResult instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'patient_id': instance.patientId,
    };
