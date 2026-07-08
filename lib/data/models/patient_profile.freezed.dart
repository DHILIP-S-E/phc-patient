// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'patient_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PatientProfile {

@JsonKey(name: 'patient_id') int get patientId; String get name;@JsonKey(name: 'age_years') int? get ageYears; String get category;@JsonKey(name: 'is_high_risk') bool get isHighRisk;@JsonKey(name: 'has_pregnancy_record') bool get hasPregnancyRecord;@JsonKey(name: 'has_child_record') bool get hasChildRecord;@JsonKey(name: 'has_ncd_history') bool get hasNcdHistory;@JsonKey(name: 'has_tb_history') bool get hasTbHistory;
/// Create a copy of PatientProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PatientProfileCopyWith<PatientProfile> get copyWith => _$PatientProfileCopyWithImpl<PatientProfile>(this as PatientProfile, _$identity);

  /// Serializes this PatientProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PatientProfile&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.name, name) || other.name == name)&&(identical(other.ageYears, ageYears) || other.ageYears == ageYears)&&(identical(other.category, category) || other.category == category)&&(identical(other.isHighRisk, isHighRisk) || other.isHighRisk == isHighRisk)&&(identical(other.hasPregnancyRecord, hasPregnancyRecord) || other.hasPregnancyRecord == hasPregnancyRecord)&&(identical(other.hasChildRecord, hasChildRecord) || other.hasChildRecord == hasChildRecord)&&(identical(other.hasNcdHistory, hasNcdHistory) || other.hasNcdHistory == hasNcdHistory)&&(identical(other.hasTbHistory, hasTbHistory) || other.hasTbHistory == hasTbHistory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,patientId,name,ageYears,category,isHighRisk,hasPregnancyRecord,hasChildRecord,hasNcdHistory,hasTbHistory);

@override
String toString() {
  return 'PatientProfile(patientId: $patientId, name: $name, ageYears: $ageYears, category: $category, isHighRisk: $isHighRisk, hasPregnancyRecord: $hasPregnancyRecord, hasChildRecord: $hasChildRecord, hasNcdHistory: $hasNcdHistory, hasTbHistory: $hasTbHistory)';
}


}

/// @nodoc
abstract mixin class $PatientProfileCopyWith<$Res>  {
  factory $PatientProfileCopyWith(PatientProfile value, $Res Function(PatientProfile) _then) = _$PatientProfileCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'patient_id') int patientId, String name,@JsonKey(name: 'age_years') int? ageYears, String category,@JsonKey(name: 'is_high_risk') bool isHighRisk,@JsonKey(name: 'has_pregnancy_record') bool hasPregnancyRecord,@JsonKey(name: 'has_child_record') bool hasChildRecord,@JsonKey(name: 'has_ncd_history') bool hasNcdHistory,@JsonKey(name: 'has_tb_history') bool hasTbHistory
});




}
/// @nodoc
class _$PatientProfileCopyWithImpl<$Res>
    implements $PatientProfileCopyWith<$Res> {
  _$PatientProfileCopyWithImpl(this._self, this._then);

  final PatientProfile _self;
  final $Res Function(PatientProfile) _then;

/// Create a copy of PatientProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? patientId = null,Object? name = null,Object? ageYears = freezed,Object? category = null,Object? isHighRisk = null,Object? hasPregnancyRecord = null,Object? hasChildRecord = null,Object? hasNcdHistory = null,Object? hasTbHistory = null,}) {
  return _then(_self.copyWith(
patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,ageYears: freezed == ageYears ? _self.ageYears : ageYears // ignore: cast_nullable_to_non_nullable
as int?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,isHighRisk: null == isHighRisk ? _self.isHighRisk : isHighRisk // ignore: cast_nullable_to_non_nullable
as bool,hasPregnancyRecord: null == hasPregnancyRecord ? _self.hasPregnancyRecord : hasPregnancyRecord // ignore: cast_nullable_to_non_nullable
as bool,hasChildRecord: null == hasChildRecord ? _self.hasChildRecord : hasChildRecord // ignore: cast_nullable_to_non_nullable
as bool,hasNcdHistory: null == hasNcdHistory ? _self.hasNcdHistory : hasNcdHistory // ignore: cast_nullable_to_non_nullable
as bool,hasTbHistory: null == hasTbHistory ? _self.hasTbHistory : hasTbHistory // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PatientProfile].
extension PatientProfilePatterns on PatientProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PatientProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PatientProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PatientProfile value)  $default,){
final _that = this;
switch (_that) {
case _PatientProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PatientProfile value)?  $default,){
final _that = this;
switch (_that) {
case _PatientProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'patient_id')  int patientId,  String name, @JsonKey(name: 'age_years')  int? ageYears,  String category, @JsonKey(name: 'is_high_risk')  bool isHighRisk, @JsonKey(name: 'has_pregnancy_record')  bool hasPregnancyRecord, @JsonKey(name: 'has_child_record')  bool hasChildRecord, @JsonKey(name: 'has_ncd_history')  bool hasNcdHistory, @JsonKey(name: 'has_tb_history')  bool hasTbHistory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PatientProfile() when $default != null:
return $default(_that.patientId,_that.name,_that.ageYears,_that.category,_that.isHighRisk,_that.hasPregnancyRecord,_that.hasChildRecord,_that.hasNcdHistory,_that.hasTbHistory);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'patient_id')  int patientId,  String name, @JsonKey(name: 'age_years')  int? ageYears,  String category, @JsonKey(name: 'is_high_risk')  bool isHighRisk, @JsonKey(name: 'has_pregnancy_record')  bool hasPregnancyRecord, @JsonKey(name: 'has_child_record')  bool hasChildRecord, @JsonKey(name: 'has_ncd_history')  bool hasNcdHistory, @JsonKey(name: 'has_tb_history')  bool hasTbHistory)  $default,) {final _that = this;
switch (_that) {
case _PatientProfile():
return $default(_that.patientId,_that.name,_that.ageYears,_that.category,_that.isHighRisk,_that.hasPregnancyRecord,_that.hasChildRecord,_that.hasNcdHistory,_that.hasTbHistory);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'patient_id')  int patientId,  String name, @JsonKey(name: 'age_years')  int? ageYears,  String category, @JsonKey(name: 'is_high_risk')  bool isHighRisk, @JsonKey(name: 'has_pregnancy_record')  bool hasPregnancyRecord, @JsonKey(name: 'has_child_record')  bool hasChildRecord, @JsonKey(name: 'has_ncd_history')  bool hasNcdHistory, @JsonKey(name: 'has_tb_history')  bool hasTbHistory)?  $default,) {final _that = this;
switch (_that) {
case _PatientProfile() when $default != null:
return $default(_that.patientId,_that.name,_that.ageYears,_that.category,_that.isHighRisk,_that.hasPregnancyRecord,_that.hasChildRecord,_that.hasNcdHistory,_that.hasTbHistory);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PatientProfile implements PatientProfile {
  const _PatientProfile({@JsonKey(name: 'patient_id') required this.patientId, required this.name, @JsonKey(name: 'age_years') this.ageYears, required this.category, @JsonKey(name: 'is_high_risk') required this.isHighRisk, @JsonKey(name: 'has_pregnancy_record') required this.hasPregnancyRecord, @JsonKey(name: 'has_child_record') required this.hasChildRecord, @JsonKey(name: 'has_ncd_history') required this.hasNcdHistory, @JsonKey(name: 'has_tb_history') required this.hasTbHistory});
  factory _PatientProfile.fromJson(Map<String, dynamic> json) => _$PatientProfileFromJson(json);

@override@JsonKey(name: 'patient_id') final  int patientId;
@override final  String name;
@override@JsonKey(name: 'age_years') final  int? ageYears;
@override final  String category;
@override@JsonKey(name: 'is_high_risk') final  bool isHighRisk;
@override@JsonKey(name: 'has_pregnancy_record') final  bool hasPregnancyRecord;
@override@JsonKey(name: 'has_child_record') final  bool hasChildRecord;
@override@JsonKey(name: 'has_ncd_history') final  bool hasNcdHistory;
@override@JsonKey(name: 'has_tb_history') final  bool hasTbHistory;

/// Create a copy of PatientProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PatientProfileCopyWith<_PatientProfile> get copyWith => __$PatientProfileCopyWithImpl<_PatientProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PatientProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PatientProfile&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.name, name) || other.name == name)&&(identical(other.ageYears, ageYears) || other.ageYears == ageYears)&&(identical(other.category, category) || other.category == category)&&(identical(other.isHighRisk, isHighRisk) || other.isHighRisk == isHighRisk)&&(identical(other.hasPregnancyRecord, hasPregnancyRecord) || other.hasPregnancyRecord == hasPregnancyRecord)&&(identical(other.hasChildRecord, hasChildRecord) || other.hasChildRecord == hasChildRecord)&&(identical(other.hasNcdHistory, hasNcdHistory) || other.hasNcdHistory == hasNcdHistory)&&(identical(other.hasTbHistory, hasTbHistory) || other.hasTbHistory == hasTbHistory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,patientId,name,ageYears,category,isHighRisk,hasPregnancyRecord,hasChildRecord,hasNcdHistory,hasTbHistory);

@override
String toString() {
  return 'PatientProfile(patientId: $patientId, name: $name, ageYears: $ageYears, category: $category, isHighRisk: $isHighRisk, hasPregnancyRecord: $hasPregnancyRecord, hasChildRecord: $hasChildRecord, hasNcdHistory: $hasNcdHistory, hasTbHistory: $hasTbHistory)';
}


}

/// @nodoc
abstract mixin class _$PatientProfileCopyWith<$Res> implements $PatientProfileCopyWith<$Res> {
  factory _$PatientProfileCopyWith(_PatientProfile value, $Res Function(_PatientProfile) _then) = __$PatientProfileCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'patient_id') int patientId, String name,@JsonKey(name: 'age_years') int? ageYears, String category,@JsonKey(name: 'is_high_risk') bool isHighRisk,@JsonKey(name: 'has_pregnancy_record') bool hasPregnancyRecord,@JsonKey(name: 'has_child_record') bool hasChildRecord,@JsonKey(name: 'has_ncd_history') bool hasNcdHistory,@JsonKey(name: 'has_tb_history') bool hasTbHistory
});




}
/// @nodoc
class __$PatientProfileCopyWithImpl<$Res>
    implements _$PatientProfileCopyWith<$Res> {
  __$PatientProfileCopyWithImpl(this._self, this._then);

  final _PatientProfile _self;
  final $Res Function(_PatientProfile) _then;

/// Create a copy of PatientProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? patientId = null,Object? name = null,Object? ageYears = freezed,Object? category = null,Object? isHighRisk = null,Object? hasPregnancyRecord = null,Object? hasChildRecord = null,Object? hasNcdHistory = null,Object? hasTbHistory = null,}) {
  return _then(_PatientProfile(
patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,ageYears: freezed == ageYears ? _self.ageYears : ageYears // ignore: cast_nullable_to_non_nullable
as int?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,isHighRisk: null == isHighRisk ? _self.isHighRisk : isHighRisk // ignore: cast_nullable_to_non_nullable
as bool,hasPregnancyRecord: null == hasPregnancyRecord ? _self.hasPregnancyRecord : hasPregnancyRecord // ignore: cast_nullable_to_non_nullable
as bool,hasChildRecord: null == hasChildRecord ? _self.hasChildRecord : hasChildRecord // ignore: cast_nullable_to_non_nullable
as bool,hasNcdHistory: null == hasNcdHistory ? _self.hasNcdHistory : hasNcdHistory // ignore: cast_nullable_to_non_nullable
as bool,hasTbHistory: null == hasTbHistory ? _self.hasTbHistory : hasTbHistory // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
