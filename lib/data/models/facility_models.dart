import 'package:freezed_annotation/freezed_annotation.dart';

part 'facility_models.freezed.dart';
part 'facility_models.g.dart';

/// Mirrors `phc_api/schemas/patient_portal.py::NearbyFacilityItem`
/// (GET /patients/me/facilities/nearby).
@freezed
abstract class NearbyFacilityItem with _$NearbyFacilityItem {
  const factory NearbyFacilityItem({
    required int id,
    required String name,
    required String type,
    double? lat,
    double? lng,
    @JsonKey(name: 'distance_km') required double distanceKm,
  }) = _NearbyFacilityItem;

  factory NearbyFacilityItem.fromJson(Map<String, dynamic> json) =>
      _$NearbyFacilityItemFromJson(json);
}
