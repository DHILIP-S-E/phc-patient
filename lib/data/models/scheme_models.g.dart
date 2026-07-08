// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheme_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SchemeItem _$SchemeItemFromJson(Map<String, dynamic> json) => _SchemeItem(
  key: json['key'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  benefits: (json['benefits'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  requiredDocuments: (json['required_documents'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  category: json['category'] as String,
);

Map<String, dynamic> _$SchemeItemToJson(_SchemeItem instance) =>
    <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'description': instance.description,
      'benefits': instance.benefits,
      'required_documents': instance.requiredDocuments,
      'category': instance.category,
    };
