// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'facility_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NearbyFacilityItem {

 int get id; String get name; String get type; double? get lat; double? get lng;@JsonKey(name: 'distance_km') double get distanceKm;
/// Create a copy of NearbyFacilityItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NearbyFacilityItemCopyWith<NearbyFacilityItem> get copyWith => _$NearbyFacilityItemCopyWithImpl<NearbyFacilityItem>(this as NearbyFacilityItem, _$identity);

  /// Serializes this NearbyFacilityItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NearbyFacilityItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,lat,lng,distanceKm);

@override
String toString() {
  return 'NearbyFacilityItem(id: $id, name: $name, type: $type, lat: $lat, lng: $lng, distanceKm: $distanceKm)';
}


}

/// @nodoc
abstract mixin class $NearbyFacilityItemCopyWith<$Res>  {
  factory $NearbyFacilityItemCopyWith(NearbyFacilityItem value, $Res Function(NearbyFacilityItem) _then) = _$NearbyFacilityItemCopyWithImpl;
@useResult
$Res call({
 int id, String name, String type, double? lat, double? lng,@JsonKey(name: 'distance_km') double distanceKm
});




}
/// @nodoc
class _$NearbyFacilityItemCopyWithImpl<$Res>
    implements $NearbyFacilityItemCopyWith<$Res> {
  _$NearbyFacilityItemCopyWithImpl(this._self, this._then);

  final NearbyFacilityItem _self;
  final $Res Function(NearbyFacilityItem) _then;

/// Create a copy of NearbyFacilityItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? lat = freezed,Object? lng = freezed,Object? distanceKm = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [NearbyFacilityItem].
extension NearbyFacilityItemPatterns on NearbyFacilityItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NearbyFacilityItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NearbyFacilityItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NearbyFacilityItem value)  $default,){
final _that = this;
switch (_that) {
case _NearbyFacilityItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NearbyFacilityItem value)?  $default,){
final _that = this;
switch (_that) {
case _NearbyFacilityItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String type,  double? lat,  double? lng, @JsonKey(name: 'distance_km')  double distanceKm)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NearbyFacilityItem() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.lat,_that.lng,_that.distanceKm);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String type,  double? lat,  double? lng, @JsonKey(name: 'distance_km')  double distanceKm)  $default,) {final _that = this;
switch (_that) {
case _NearbyFacilityItem():
return $default(_that.id,_that.name,_that.type,_that.lat,_that.lng,_that.distanceKm);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String type,  double? lat,  double? lng, @JsonKey(name: 'distance_km')  double distanceKm)?  $default,) {final _that = this;
switch (_that) {
case _NearbyFacilityItem() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.lat,_that.lng,_that.distanceKm);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NearbyFacilityItem implements NearbyFacilityItem {
  const _NearbyFacilityItem({required this.id, required this.name, required this.type, this.lat, this.lng, @JsonKey(name: 'distance_km') required this.distanceKm});
  factory _NearbyFacilityItem.fromJson(Map<String, dynamic> json) => _$NearbyFacilityItemFromJson(json);

@override final  int id;
@override final  String name;
@override final  String type;
@override final  double? lat;
@override final  double? lng;
@override@JsonKey(name: 'distance_km') final  double distanceKm;

/// Create a copy of NearbyFacilityItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NearbyFacilityItemCopyWith<_NearbyFacilityItem> get copyWith => __$NearbyFacilityItemCopyWithImpl<_NearbyFacilityItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NearbyFacilityItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NearbyFacilityItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,lat,lng,distanceKm);

@override
String toString() {
  return 'NearbyFacilityItem(id: $id, name: $name, type: $type, lat: $lat, lng: $lng, distanceKm: $distanceKm)';
}


}

/// @nodoc
abstract mixin class _$NearbyFacilityItemCopyWith<$Res> implements $NearbyFacilityItemCopyWith<$Res> {
  factory _$NearbyFacilityItemCopyWith(_NearbyFacilityItem value, $Res Function(_NearbyFacilityItem) _then) = __$NearbyFacilityItemCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String type, double? lat, double? lng,@JsonKey(name: 'distance_km') double distanceKm
});




}
/// @nodoc
class __$NearbyFacilityItemCopyWithImpl<$Res>
    implements _$NearbyFacilityItemCopyWith<$Res> {
  __$NearbyFacilityItemCopyWithImpl(this._self, this._then);

  final _NearbyFacilityItem _self;
  final $Res Function(_NearbyFacilityItem) _then;

/// Create a copy of NearbyFacilityItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? lat = freezed,Object? lng = freezed,Object? distanceKm = null,}) {
  return _then(_NearbyFacilityItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
