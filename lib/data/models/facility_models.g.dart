// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NearbyFacilityItem _$NearbyFacilityItemFromJson(Map<String, dynamic> json) =>
    _NearbyFacilityItem(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      type: json['type'] as String,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      distanceKm: (json['distance_km'] as num).toDouble(),
    );

Map<String, dynamic> _$NearbyFacilityItemToJson(_NearbyFacilityItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'lat': instance.lat,
      'lng': instance.lng,
      'distance_km': instance.distanceKm,
    };
