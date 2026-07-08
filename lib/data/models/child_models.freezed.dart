// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'child_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChildDetail {

@JsonKey(name: 'patient_id') int get patientId;@JsonKey(name: 'birth_date') String? get birthDate;@JsonKey(name: 'delivery_type') String? get deliveryType;@JsonKey(name: 'is_high_priority') bool get isHighPriority;@JsonKey(name: 'growth_records') List<GrowthRecordItem> get growthRecords;@JsonKey(name: 'vaccination_schedule') List<VaccinationScheduleItem> get vaccinationSchedule;@JsonKey(name: 'vaccination_records') List<VaccinationRecordItem> get vaccinationRecords;
/// Create a copy of ChildDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChildDetailCopyWith<ChildDetail> get copyWith => _$ChildDetailCopyWithImpl<ChildDetail>(this as ChildDetail, _$identity);

  /// Serializes this ChildDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChildDetail&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.deliveryType, deliveryType) || other.deliveryType == deliveryType)&&(identical(other.isHighPriority, isHighPriority) || other.isHighPriority == isHighPriority)&&const DeepCollectionEquality().equals(other.growthRecords, growthRecords)&&const DeepCollectionEquality().equals(other.vaccinationSchedule, vaccinationSchedule)&&const DeepCollectionEquality().equals(other.vaccinationRecords, vaccinationRecords));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,patientId,birthDate,deliveryType,isHighPriority,const DeepCollectionEquality().hash(growthRecords),const DeepCollectionEquality().hash(vaccinationSchedule),const DeepCollectionEquality().hash(vaccinationRecords));

@override
String toString() {
  return 'ChildDetail(patientId: $patientId, birthDate: $birthDate, deliveryType: $deliveryType, isHighPriority: $isHighPriority, growthRecords: $growthRecords, vaccinationSchedule: $vaccinationSchedule, vaccinationRecords: $vaccinationRecords)';
}


}

/// @nodoc
abstract mixin class $ChildDetailCopyWith<$Res>  {
  factory $ChildDetailCopyWith(ChildDetail value, $Res Function(ChildDetail) _then) = _$ChildDetailCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'patient_id') int patientId,@JsonKey(name: 'birth_date') String? birthDate,@JsonKey(name: 'delivery_type') String? deliveryType,@JsonKey(name: 'is_high_priority') bool isHighPriority,@JsonKey(name: 'growth_records') List<GrowthRecordItem> growthRecords,@JsonKey(name: 'vaccination_schedule') List<VaccinationScheduleItem> vaccinationSchedule,@JsonKey(name: 'vaccination_records') List<VaccinationRecordItem> vaccinationRecords
});




}
/// @nodoc
class _$ChildDetailCopyWithImpl<$Res>
    implements $ChildDetailCopyWith<$Res> {
  _$ChildDetailCopyWithImpl(this._self, this._then);

  final ChildDetail _self;
  final $Res Function(ChildDetail) _then;

/// Create a copy of ChildDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? patientId = null,Object? birthDate = freezed,Object? deliveryType = freezed,Object? isHighPriority = null,Object? growthRecords = null,Object? vaccinationSchedule = null,Object? vaccinationRecords = null,}) {
  return _then(_self.copyWith(
patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as int,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String?,deliveryType: freezed == deliveryType ? _self.deliveryType : deliveryType // ignore: cast_nullable_to_non_nullable
as String?,isHighPriority: null == isHighPriority ? _self.isHighPriority : isHighPriority // ignore: cast_nullable_to_non_nullable
as bool,growthRecords: null == growthRecords ? _self.growthRecords : growthRecords // ignore: cast_nullable_to_non_nullable
as List<GrowthRecordItem>,vaccinationSchedule: null == vaccinationSchedule ? _self.vaccinationSchedule : vaccinationSchedule // ignore: cast_nullable_to_non_nullable
as List<VaccinationScheduleItem>,vaccinationRecords: null == vaccinationRecords ? _self.vaccinationRecords : vaccinationRecords // ignore: cast_nullable_to_non_nullable
as List<VaccinationRecordItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [ChildDetail].
extension ChildDetailPatterns on ChildDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChildDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChildDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChildDetail value)  $default,){
final _that = this;
switch (_that) {
case _ChildDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChildDetail value)?  $default,){
final _that = this;
switch (_that) {
case _ChildDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'patient_id')  int patientId, @JsonKey(name: 'birth_date')  String? birthDate, @JsonKey(name: 'delivery_type')  String? deliveryType, @JsonKey(name: 'is_high_priority')  bool isHighPriority, @JsonKey(name: 'growth_records')  List<GrowthRecordItem> growthRecords, @JsonKey(name: 'vaccination_schedule')  List<VaccinationScheduleItem> vaccinationSchedule, @JsonKey(name: 'vaccination_records')  List<VaccinationRecordItem> vaccinationRecords)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChildDetail() when $default != null:
return $default(_that.patientId,_that.birthDate,_that.deliveryType,_that.isHighPriority,_that.growthRecords,_that.vaccinationSchedule,_that.vaccinationRecords);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'patient_id')  int patientId, @JsonKey(name: 'birth_date')  String? birthDate, @JsonKey(name: 'delivery_type')  String? deliveryType, @JsonKey(name: 'is_high_priority')  bool isHighPriority, @JsonKey(name: 'growth_records')  List<GrowthRecordItem> growthRecords, @JsonKey(name: 'vaccination_schedule')  List<VaccinationScheduleItem> vaccinationSchedule, @JsonKey(name: 'vaccination_records')  List<VaccinationRecordItem> vaccinationRecords)  $default,) {final _that = this;
switch (_that) {
case _ChildDetail():
return $default(_that.patientId,_that.birthDate,_that.deliveryType,_that.isHighPriority,_that.growthRecords,_that.vaccinationSchedule,_that.vaccinationRecords);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'patient_id')  int patientId, @JsonKey(name: 'birth_date')  String? birthDate, @JsonKey(name: 'delivery_type')  String? deliveryType, @JsonKey(name: 'is_high_priority')  bool isHighPriority, @JsonKey(name: 'growth_records')  List<GrowthRecordItem> growthRecords, @JsonKey(name: 'vaccination_schedule')  List<VaccinationScheduleItem> vaccinationSchedule, @JsonKey(name: 'vaccination_records')  List<VaccinationRecordItem> vaccinationRecords)?  $default,) {final _that = this;
switch (_that) {
case _ChildDetail() when $default != null:
return $default(_that.patientId,_that.birthDate,_that.deliveryType,_that.isHighPriority,_that.growthRecords,_that.vaccinationSchedule,_that.vaccinationRecords);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChildDetail implements ChildDetail {
  const _ChildDetail({@JsonKey(name: 'patient_id') required this.patientId, @JsonKey(name: 'birth_date') this.birthDate, @JsonKey(name: 'delivery_type') this.deliveryType, @JsonKey(name: 'is_high_priority') required this.isHighPriority, @JsonKey(name: 'growth_records') final  List<GrowthRecordItem> growthRecords = const <GrowthRecordItem>[], @JsonKey(name: 'vaccination_schedule') final  List<VaccinationScheduleItem> vaccinationSchedule = const <VaccinationScheduleItem>[], @JsonKey(name: 'vaccination_records') final  List<VaccinationRecordItem> vaccinationRecords = const <VaccinationRecordItem>[]}): _growthRecords = growthRecords,_vaccinationSchedule = vaccinationSchedule,_vaccinationRecords = vaccinationRecords;
  factory _ChildDetail.fromJson(Map<String, dynamic> json) => _$ChildDetailFromJson(json);

@override@JsonKey(name: 'patient_id') final  int patientId;
@override@JsonKey(name: 'birth_date') final  String? birthDate;
@override@JsonKey(name: 'delivery_type') final  String? deliveryType;
@override@JsonKey(name: 'is_high_priority') final  bool isHighPriority;
 final  List<GrowthRecordItem> _growthRecords;
@override@JsonKey(name: 'growth_records') List<GrowthRecordItem> get growthRecords {
  if (_growthRecords is EqualUnmodifiableListView) return _growthRecords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_growthRecords);
}

 final  List<VaccinationScheduleItem> _vaccinationSchedule;
@override@JsonKey(name: 'vaccination_schedule') List<VaccinationScheduleItem> get vaccinationSchedule {
  if (_vaccinationSchedule is EqualUnmodifiableListView) return _vaccinationSchedule;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_vaccinationSchedule);
}

 final  List<VaccinationRecordItem> _vaccinationRecords;
@override@JsonKey(name: 'vaccination_records') List<VaccinationRecordItem> get vaccinationRecords {
  if (_vaccinationRecords is EqualUnmodifiableListView) return _vaccinationRecords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_vaccinationRecords);
}


/// Create a copy of ChildDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChildDetailCopyWith<_ChildDetail> get copyWith => __$ChildDetailCopyWithImpl<_ChildDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChildDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChildDetail&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.deliveryType, deliveryType) || other.deliveryType == deliveryType)&&(identical(other.isHighPriority, isHighPriority) || other.isHighPriority == isHighPriority)&&const DeepCollectionEquality().equals(other._growthRecords, _growthRecords)&&const DeepCollectionEquality().equals(other._vaccinationSchedule, _vaccinationSchedule)&&const DeepCollectionEquality().equals(other._vaccinationRecords, _vaccinationRecords));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,patientId,birthDate,deliveryType,isHighPriority,const DeepCollectionEquality().hash(_growthRecords),const DeepCollectionEquality().hash(_vaccinationSchedule),const DeepCollectionEquality().hash(_vaccinationRecords));

@override
String toString() {
  return 'ChildDetail(patientId: $patientId, birthDate: $birthDate, deliveryType: $deliveryType, isHighPriority: $isHighPriority, growthRecords: $growthRecords, vaccinationSchedule: $vaccinationSchedule, vaccinationRecords: $vaccinationRecords)';
}


}

/// @nodoc
abstract mixin class _$ChildDetailCopyWith<$Res> implements $ChildDetailCopyWith<$Res> {
  factory _$ChildDetailCopyWith(_ChildDetail value, $Res Function(_ChildDetail) _then) = __$ChildDetailCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'patient_id') int patientId,@JsonKey(name: 'birth_date') String? birthDate,@JsonKey(name: 'delivery_type') String? deliveryType,@JsonKey(name: 'is_high_priority') bool isHighPriority,@JsonKey(name: 'growth_records') List<GrowthRecordItem> growthRecords,@JsonKey(name: 'vaccination_schedule') List<VaccinationScheduleItem> vaccinationSchedule,@JsonKey(name: 'vaccination_records') List<VaccinationRecordItem> vaccinationRecords
});




}
/// @nodoc
class __$ChildDetailCopyWithImpl<$Res>
    implements _$ChildDetailCopyWith<$Res> {
  __$ChildDetailCopyWithImpl(this._self, this._then);

  final _ChildDetail _self;
  final $Res Function(_ChildDetail) _then;

/// Create a copy of ChildDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? patientId = null,Object? birthDate = freezed,Object? deliveryType = freezed,Object? isHighPriority = null,Object? growthRecords = null,Object? vaccinationSchedule = null,Object? vaccinationRecords = null,}) {
  return _then(_ChildDetail(
patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as int,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String?,deliveryType: freezed == deliveryType ? _self.deliveryType : deliveryType // ignore: cast_nullable_to_non_nullable
as String?,isHighPriority: null == isHighPriority ? _self.isHighPriority : isHighPriority // ignore: cast_nullable_to_non_nullable
as bool,growthRecords: null == growthRecords ? _self._growthRecords : growthRecords // ignore: cast_nullable_to_non_nullable
as List<GrowthRecordItem>,vaccinationSchedule: null == vaccinationSchedule ? _self._vaccinationSchedule : vaccinationSchedule // ignore: cast_nullable_to_non_nullable
as List<VaccinationScheduleItem>,vaccinationRecords: null == vaccinationRecords ? _self._vaccinationRecords : vaccinationRecords // ignore: cast_nullable_to_non_nullable
as List<VaccinationRecordItem>,
  ));
}


}


/// @nodoc
mixin _$GrowthRecordItem {

 int get id;@JsonKey(name: 'record_date') String get recordDate;@JsonKey(name: 'weight_kg') double? get weightKg;@JsonKey(name: 'height_cm') double? get heightCm;@JsonKey(name: 'muac_cm') double? get muacCm;@JsonKey(name: 'is_underweight') bool get isUnderweight;@JsonKey(name: 'is_stunted') bool get isStunted;@JsonKey(name: 'is_wasted') bool get isWasted;
/// Create a copy of GrowthRecordItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GrowthRecordItemCopyWith<GrowthRecordItem> get copyWith => _$GrowthRecordItemCopyWithImpl<GrowthRecordItem>(this as GrowthRecordItem, _$identity);

  /// Serializes this GrowthRecordItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GrowthRecordItem&&(identical(other.id, id) || other.id == id)&&(identical(other.recordDate, recordDate) || other.recordDate == recordDate)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.muacCm, muacCm) || other.muacCm == muacCm)&&(identical(other.isUnderweight, isUnderweight) || other.isUnderweight == isUnderweight)&&(identical(other.isStunted, isStunted) || other.isStunted == isStunted)&&(identical(other.isWasted, isWasted) || other.isWasted == isWasted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,recordDate,weightKg,heightCm,muacCm,isUnderweight,isStunted,isWasted);

@override
String toString() {
  return 'GrowthRecordItem(id: $id, recordDate: $recordDate, weightKg: $weightKg, heightCm: $heightCm, muacCm: $muacCm, isUnderweight: $isUnderweight, isStunted: $isStunted, isWasted: $isWasted)';
}


}

/// @nodoc
abstract mixin class $GrowthRecordItemCopyWith<$Res>  {
  factory $GrowthRecordItemCopyWith(GrowthRecordItem value, $Res Function(GrowthRecordItem) _then) = _$GrowthRecordItemCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'record_date') String recordDate,@JsonKey(name: 'weight_kg') double? weightKg,@JsonKey(name: 'height_cm') double? heightCm,@JsonKey(name: 'muac_cm') double? muacCm,@JsonKey(name: 'is_underweight') bool isUnderweight,@JsonKey(name: 'is_stunted') bool isStunted,@JsonKey(name: 'is_wasted') bool isWasted
});




}
/// @nodoc
class _$GrowthRecordItemCopyWithImpl<$Res>
    implements $GrowthRecordItemCopyWith<$Res> {
  _$GrowthRecordItemCopyWithImpl(this._self, this._then);

  final GrowthRecordItem _self;
  final $Res Function(GrowthRecordItem) _then;

/// Create a copy of GrowthRecordItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? recordDate = null,Object? weightKg = freezed,Object? heightCm = freezed,Object? muacCm = freezed,Object? isUnderweight = null,Object? isStunted = null,Object? isWasted = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,recordDate: null == recordDate ? _self.recordDate : recordDate // ignore: cast_nullable_to_non_nullable
as String,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as double?,muacCm: freezed == muacCm ? _self.muacCm : muacCm // ignore: cast_nullable_to_non_nullable
as double?,isUnderweight: null == isUnderweight ? _self.isUnderweight : isUnderweight // ignore: cast_nullable_to_non_nullable
as bool,isStunted: null == isStunted ? _self.isStunted : isStunted // ignore: cast_nullable_to_non_nullable
as bool,isWasted: null == isWasted ? _self.isWasted : isWasted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GrowthRecordItem].
extension GrowthRecordItemPatterns on GrowthRecordItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GrowthRecordItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GrowthRecordItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GrowthRecordItem value)  $default,){
final _that = this;
switch (_that) {
case _GrowthRecordItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GrowthRecordItem value)?  $default,){
final _that = this;
switch (_that) {
case _GrowthRecordItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'record_date')  String recordDate, @JsonKey(name: 'weight_kg')  double? weightKg, @JsonKey(name: 'height_cm')  double? heightCm, @JsonKey(name: 'muac_cm')  double? muacCm, @JsonKey(name: 'is_underweight')  bool isUnderweight, @JsonKey(name: 'is_stunted')  bool isStunted, @JsonKey(name: 'is_wasted')  bool isWasted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GrowthRecordItem() when $default != null:
return $default(_that.id,_that.recordDate,_that.weightKg,_that.heightCm,_that.muacCm,_that.isUnderweight,_that.isStunted,_that.isWasted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'record_date')  String recordDate, @JsonKey(name: 'weight_kg')  double? weightKg, @JsonKey(name: 'height_cm')  double? heightCm, @JsonKey(name: 'muac_cm')  double? muacCm, @JsonKey(name: 'is_underweight')  bool isUnderweight, @JsonKey(name: 'is_stunted')  bool isStunted, @JsonKey(name: 'is_wasted')  bool isWasted)  $default,) {final _that = this;
switch (_that) {
case _GrowthRecordItem():
return $default(_that.id,_that.recordDate,_that.weightKg,_that.heightCm,_that.muacCm,_that.isUnderweight,_that.isStunted,_that.isWasted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'record_date')  String recordDate, @JsonKey(name: 'weight_kg')  double? weightKg, @JsonKey(name: 'height_cm')  double? heightCm, @JsonKey(name: 'muac_cm')  double? muacCm, @JsonKey(name: 'is_underweight')  bool isUnderweight, @JsonKey(name: 'is_stunted')  bool isStunted, @JsonKey(name: 'is_wasted')  bool isWasted)?  $default,) {final _that = this;
switch (_that) {
case _GrowthRecordItem() when $default != null:
return $default(_that.id,_that.recordDate,_that.weightKg,_that.heightCm,_that.muacCm,_that.isUnderweight,_that.isStunted,_that.isWasted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GrowthRecordItem implements GrowthRecordItem {
  const _GrowthRecordItem({required this.id, @JsonKey(name: 'record_date') required this.recordDate, @JsonKey(name: 'weight_kg') this.weightKg, @JsonKey(name: 'height_cm') this.heightCm, @JsonKey(name: 'muac_cm') this.muacCm, @JsonKey(name: 'is_underweight') required this.isUnderweight, @JsonKey(name: 'is_stunted') required this.isStunted, @JsonKey(name: 'is_wasted') required this.isWasted});
  factory _GrowthRecordItem.fromJson(Map<String, dynamic> json) => _$GrowthRecordItemFromJson(json);

@override final  int id;
@override@JsonKey(name: 'record_date') final  String recordDate;
@override@JsonKey(name: 'weight_kg') final  double? weightKg;
@override@JsonKey(name: 'height_cm') final  double? heightCm;
@override@JsonKey(name: 'muac_cm') final  double? muacCm;
@override@JsonKey(name: 'is_underweight') final  bool isUnderweight;
@override@JsonKey(name: 'is_stunted') final  bool isStunted;
@override@JsonKey(name: 'is_wasted') final  bool isWasted;

/// Create a copy of GrowthRecordItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GrowthRecordItemCopyWith<_GrowthRecordItem> get copyWith => __$GrowthRecordItemCopyWithImpl<_GrowthRecordItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GrowthRecordItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GrowthRecordItem&&(identical(other.id, id) || other.id == id)&&(identical(other.recordDate, recordDate) || other.recordDate == recordDate)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.muacCm, muacCm) || other.muacCm == muacCm)&&(identical(other.isUnderweight, isUnderweight) || other.isUnderweight == isUnderweight)&&(identical(other.isStunted, isStunted) || other.isStunted == isStunted)&&(identical(other.isWasted, isWasted) || other.isWasted == isWasted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,recordDate,weightKg,heightCm,muacCm,isUnderweight,isStunted,isWasted);

@override
String toString() {
  return 'GrowthRecordItem(id: $id, recordDate: $recordDate, weightKg: $weightKg, heightCm: $heightCm, muacCm: $muacCm, isUnderweight: $isUnderweight, isStunted: $isStunted, isWasted: $isWasted)';
}


}

/// @nodoc
abstract mixin class _$GrowthRecordItemCopyWith<$Res> implements $GrowthRecordItemCopyWith<$Res> {
  factory _$GrowthRecordItemCopyWith(_GrowthRecordItem value, $Res Function(_GrowthRecordItem) _then) = __$GrowthRecordItemCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'record_date') String recordDate,@JsonKey(name: 'weight_kg') double? weightKg,@JsonKey(name: 'height_cm') double? heightCm,@JsonKey(name: 'muac_cm') double? muacCm,@JsonKey(name: 'is_underweight') bool isUnderweight,@JsonKey(name: 'is_stunted') bool isStunted,@JsonKey(name: 'is_wasted') bool isWasted
});




}
/// @nodoc
class __$GrowthRecordItemCopyWithImpl<$Res>
    implements _$GrowthRecordItemCopyWith<$Res> {
  __$GrowthRecordItemCopyWithImpl(this._self, this._then);

  final _GrowthRecordItem _self;
  final $Res Function(_GrowthRecordItem) _then;

/// Create a copy of GrowthRecordItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? recordDate = null,Object? weightKg = freezed,Object? heightCm = freezed,Object? muacCm = freezed,Object? isUnderweight = null,Object? isStunted = null,Object? isWasted = null,}) {
  return _then(_GrowthRecordItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,recordDate: null == recordDate ? _self.recordDate : recordDate // ignore: cast_nullable_to_non_nullable
as String,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as double?,muacCm: freezed == muacCm ? _self.muacCm : muacCm // ignore: cast_nullable_to_non_nullable
as double?,isUnderweight: null == isUnderweight ? _self.isUnderweight : isUnderweight // ignore: cast_nullable_to_non_nullable
as bool,isStunted: null == isStunted ? _self.isStunted : isStunted // ignore: cast_nullable_to_non_nullable
as bool,isWasted: null == isWasted ? _self.isWasted : isWasted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$VaccinationScheduleItem {

 int get id;@JsonKey(name: 'vaccine_name') String get vaccineName;@JsonKey(name: 'dose_number') int? get doseNumber;@JsonKey(name: 'scheduled_date') String get scheduledDate; String get status;
/// Create a copy of VaccinationScheduleItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VaccinationScheduleItemCopyWith<VaccinationScheduleItem> get copyWith => _$VaccinationScheduleItemCopyWithImpl<VaccinationScheduleItem>(this as VaccinationScheduleItem, _$identity);

  /// Serializes this VaccinationScheduleItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VaccinationScheduleItem&&(identical(other.id, id) || other.id == id)&&(identical(other.vaccineName, vaccineName) || other.vaccineName == vaccineName)&&(identical(other.doseNumber, doseNumber) || other.doseNumber == doseNumber)&&(identical(other.scheduledDate, scheduledDate) || other.scheduledDate == scheduledDate)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vaccineName,doseNumber,scheduledDate,status);

@override
String toString() {
  return 'VaccinationScheduleItem(id: $id, vaccineName: $vaccineName, doseNumber: $doseNumber, scheduledDate: $scheduledDate, status: $status)';
}


}

/// @nodoc
abstract mixin class $VaccinationScheduleItemCopyWith<$Res>  {
  factory $VaccinationScheduleItemCopyWith(VaccinationScheduleItem value, $Res Function(VaccinationScheduleItem) _then) = _$VaccinationScheduleItemCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'vaccine_name') String vaccineName,@JsonKey(name: 'dose_number') int? doseNumber,@JsonKey(name: 'scheduled_date') String scheduledDate, String status
});




}
/// @nodoc
class _$VaccinationScheduleItemCopyWithImpl<$Res>
    implements $VaccinationScheduleItemCopyWith<$Res> {
  _$VaccinationScheduleItemCopyWithImpl(this._self, this._then);

  final VaccinationScheduleItem _self;
  final $Res Function(VaccinationScheduleItem) _then;

/// Create a copy of VaccinationScheduleItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? vaccineName = null,Object? doseNumber = freezed,Object? scheduledDate = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,vaccineName: null == vaccineName ? _self.vaccineName : vaccineName // ignore: cast_nullable_to_non_nullable
as String,doseNumber: freezed == doseNumber ? _self.doseNumber : doseNumber // ignore: cast_nullable_to_non_nullable
as int?,scheduledDate: null == scheduledDate ? _self.scheduledDate : scheduledDate // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VaccinationScheduleItem].
extension VaccinationScheduleItemPatterns on VaccinationScheduleItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VaccinationScheduleItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VaccinationScheduleItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VaccinationScheduleItem value)  $default,){
final _that = this;
switch (_that) {
case _VaccinationScheduleItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VaccinationScheduleItem value)?  $default,){
final _that = this;
switch (_that) {
case _VaccinationScheduleItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'vaccine_name')  String vaccineName, @JsonKey(name: 'dose_number')  int? doseNumber, @JsonKey(name: 'scheduled_date')  String scheduledDate,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VaccinationScheduleItem() when $default != null:
return $default(_that.id,_that.vaccineName,_that.doseNumber,_that.scheduledDate,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'vaccine_name')  String vaccineName, @JsonKey(name: 'dose_number')  int? doseNumber, @JsonKey(name: 'scheduled_date')  String scheduledDate,  String status)  $default,) {final _that = this;
switch (_that) {
case _VaccinationScheduleItem():
return $default(_that.id,_that.vaccineName,_that.doseNumber,_that.scheduledDate,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'vaccine_name')  String vaccineName, @JsonKey(name: 'dose_number')  int? doseNumber, @JsonKey(name: 'scheduled_date')  String scheduledDate,  String status)?  $default,) {final _that = this;
switch (_that) {
case _VaccinationScheduleItem() when $default != null:
return $default(_that.id,_that.vaccineName,_that.doseNumber,_that.scheduledDate,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VaccinationScheduleItem implements VaccinationScheduleItem {
  const _VaccinationScheduleItem({required this.id, @JsonKey(name: 'vaccine_name') required this.vaccineName, @JsonKey(name: 'dose_number') this.doseNumber, @JsonKey(name: 'scheduled_date') required this.scheduledDate, required this.status});
  factory _VaccinationScheduleItem.fromJson(Map<String, dynamic> json) => _$VaccinationScheduleItemFromJson(json);

@override final  int id;
@override@JsonKey(name: 'vaccine_name') final  String vaccineName;
@override@JsonKey(name: 'dose_number') final  int? doseNumber;
@override@JsonKey(name: 'scheduled_date') final  String scheduledDate;
@override final  String status;

/// Create a copy of VaccinationScheduleItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VaccinationScheduleItemCopyWith<_VaccinationScheduleItem> get copyWith => __$VaccinationScheduleItemCopyWithImpl<_VaccinationScheduleItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VaccinationScheduleItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VaccinationScheduleItem&&(identical(other.id, id) || other.id == id)&&(identical(other.vaccineName, vaccineName) || other.vaccineName == vaccineName)&&(identical(other.doseNumber, doseNumber) || other.doseNumber == doseNumber)&&(identical(other.scheduledDate, scheduledDate) || other.scheduledDate == scheduledDate)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vaccineName,doseNumber,scheduledDate,status);

@override
String toString() {
  return 'VaccinationScheduleItem(id: $id, vaccineName: $vaccineName, doseNumber: $doseNumber, scheduledDate: $scheduledDate, status: $status)';
}


}

/// @nodoc
abstract mixin class _$VaccinationScheduleItemCopyWith<$Res> implements $VaccinationScheduleItemCopyWith<$Res> {
  factory _$VaccinationScheduleItemCopyWith(_VaccinationScheduleItem value, $Res Function(_VaccinationScheduleItem) _then) = __$VaccinationScheduleItemCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'vaccine_name') String vaccineName,@JsonKey(name: 'dose_number') int? doseNumber,@JsonKey(name: 'scheduled_date') String scheduledDate, String status
});




}
/// @nodoc
class __$VaccinationScheduleItemCopyWithImpl<$Res>
    implements _$VaccinationScheduleItemCopyWith<$Res> {
  __$VaccinationScheduleItemCopyWithImpl(this._self, this._then);

  final _VaccinationScheduleItem _self;
  final $Res Function(_VaccinationScheduleItem) _then;

/// Create a copy of VaccinationScheduleItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? vaccineName = null,Object? doseNumber = freezed,Object? scheduledDate = null,Object? status = null,}) {
  return _then(_VaccinationScheduleItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,vaccineName: null == vaccineName ? _self.vaccineName : vaccineName // ignore: cast_nullable_to_non_nullable
as String,doseNumber: freezed == doseNumber ? _self.doseNumber : doseNumber // ignore: cast_nullable_to_non_nullable
as int?,scheduledDate: null == scheduledDate ? _self.scheduledDate : scheduledDate // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$VaccinationRecordItem {

 int get id;@JsonKey(name: 'vaccine_name') String get vaccineName;@JsonKey(name: 'dose_number') int? get doseNumber;@JsonKey(name: 'administered_date') String get administeredDate;
/// Create a copy of VaccinationRecordItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VaccinationRecordItemCopyWith<VaccinationRecordItem> get copyWith => _$VaccinationRecordItemCopyWithImpl<VaccinationRecordItem>(this as VaccinationRecordItem, _$identity);

  /// Serializes this VaccinationRecordItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VaccinationRecordItem&&(identical(other.id, id) || other.id == id)&&(identical(other.vaccineName, vaccineName) || other.vaccineName == vaccineName)&&(identical(other.doseNumber, doseNumber) || other.doseNumber == doseNumber)&&(identical(other.administeredDate, administeredDate) || other.administeredDate == administeredDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vaccineName,doseNumber,administeredDate);

@override
String toString() {
  return 'VaccinationRecordItem(id: $id, vaccineName: $vaccineName, doseNumber: $doseNumber, administeredDate: $administeredDate)';
}


}

/// @nodoc
abstract mixin class $VaccinationRecordItemCopyWith<$Res>  {
  factory $VaccinationRecordItemCopyWith(VaccinationRecordItem value, $Res Function(VaccinationRecordItem) _then) = _$VaccinationRecordItemCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'vaccine_name') String vaccineName,@JsonKey(name: 'dose_number') int? doseNumber,@JsonKey(name: 'administered_date') String administeredDate
});




}
/// @nodoc
class _$VaccinationRecordItemCopyWithImpl<$Res>
    implements $VaccinationRecordItemCopyWith<$Res> {
  _$VaccinationRecordItemCopyWithImpl(this._self, this._then);

  final VaccinationRecordItem _self;
  final $Res Function(VaccinationRecordItem) _then;

/// Create a copy of VaccinationRecordItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? vaccineName = null,Object? doseNumber = freezed,Object? administeredDate = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,vaccineName: null == vaccineName ? _self.vaccineName : vaccineName // ignore: cast_nullable_to_non_nullable
as String,doseNumber: freezed == doseNumber ? _self.doseNumber : doseNumber // ignore: cast_nullable_to_non_nullable
as int?,administeredDate: null == administeredDate ? _self.administeredDate : administeredDate // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VaccinationRecordItem].
extension VaccinationRecordItemPatterns on VaccinationRecordItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VaccinationRecordItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VaccinationRecordItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VaccinationRecordItem value)  $default,){
final _that = this;
switch (_that) {
case _VaccinationRecordItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VaccinationRecordItem value)?  $default,){
final _that = this;
switch (_that) {
case _VaccinationRecordItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'vaccine_name')  String vaccineName, @JsonKey(name: 'dose_number')  int? doseNumber, @JsonKey(name: 'administered_date')  String administeredDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VaccinationRecordItem() when $default != null:
return $default(_that.id,_that.vaccineName,_that.doseNumber,_that.administeredDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'vaccine_name')  String vaccineName, @JsonKey(name: 'dose_number')  int? doseNumber, @JsonKey(name: 'administered_date')  String administeredDate)  $default,) {final _that = this;
switch (_that) {
case _VaccinationRecordItem():
return $default(_that.id,_that.vaccineName,_that.doseNumber,_that.administeredDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'vaccine_name')  String vaccineName, @JsonKey(name: 'dose_number')  int? doseNumber, @JsonKey(name: 'administered_date')  String administeredDate)?  $default,) {final _that = this;
switch (_that) {
case _VaccinationRecordItem() when $default != null:
return $default(_that.id,_that.vaccineName,_that.doseNumber,_that.administeredDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VaccinationRecordItem implements VaccinationRecordItem {
  const _VaccinationRecordItem({required this.id, @JsonKey(name: 'vaccine_name') required this.vaccineName, @JsonKey(name: 'dose_number') this.doseNumber, @JsonKey(name: 'administered_date') required this.administeredDate});
  factory _VaccinationRecordItem.fromJson(Map<String, dynamic> json) => _$VaccinationRecordItemFromJson(json);

@override final  int id;
@override@JsonKey(name: 'vaccine_name') final  String vaccineName;
@override@JsonKey(name: 'dose_number') final  int? doseNumber;
@override@JsonKey(name: 'administered_date') final  String administeredDate;

/// Create a copy of VaccinationRecordItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VaccinationRecordItemCopyWith<_VaccinationRecordItem> get copyWith => __$VaccinationRecordItemCopyWithImpl<_VaccinationRecordItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VaccinationRecordItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VaccinationRecordItem&&(identical(other.id, id) || other.id == id)&&(identical(other.vaccineName, vaccineName) || other.vaccineName == vaccineName)&&(identical(other.doseNumber, doseNumber) || other.doseNumber == doseNumber)&&(identical(other.administeredDate, administeredDate) || other.administeredDate == administeredDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vaccineName,doseNumber,administeredDate);

@override
String toString() {
  return 'VaccinationRecordItem(id: $id, vaccineName: $vaccineName, doseNumber: $doseNumber, administeredDate: $administeredDate)';
}


}

/// @nodoc
abstract mixin class _$VaccinationRecordItemCopyWith<$Res> implements $VaccinationRecordItemCopyWith<$Res> {
  factory _$VaccinationRecordItemCopyWith(_VaccinationRecordItem value, $Res Function(_VaccinationRecordItem) _then) = __$VaccinationRecordItemCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'vaccine_name') String vaccineName,@JsonKey(name: 'dose_number') int? doseNumber,@JsonKey(name: 'administered_date') String administeredDate
});




}
/// @nodoc
class __$VaccinationRecordItemCopyWithImpl<$Res>
    implements _$VaccinationRecordItemCopyWith<$Res> {
  __$VaccinationRecordItemCopyWithImpl(this._self, this._then);

  final _VaccinationRecordItem _self;
  final $Res Function(_VaccinationRecordItem) _then;

/// Create a copy of VaccinationRecordItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? vaccineName = null,Object? doseNumber = freezed,Object? administeredDate = null,}) {
  return _then(_VaccinationRecordItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,vaccineName: null == vaccineName ? _self.vaccineName : vaccineName // ignore: cast_nullable_to_non_nullable
as String,doseNumber: freezed == doseNumber ? _self.doseNumber : doseNumber // ignore: cast_nullable_to_non_nullable
as int?,administeredDate: null == administeredDate ? _self.administeredDate : administeredDate // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
