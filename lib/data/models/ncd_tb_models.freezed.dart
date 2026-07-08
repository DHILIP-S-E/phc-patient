// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ncd_tb_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NcdScreeningItem {

 int get id;@JsonKey(name: 'screening_date') String get screeningDate;@JsonKey(name: 'bp_systolic') int? get bpSystolic;@JsonKey(name: 'bp_diastolic') int? get bpDiastolic;@JsonKey(name: 'blood_sugar_mgdl') double? get bloodSugarMgdl; double? get bmi;@JsonKey(name: 'risk_level') String? get riskLevel;@JsonKey(name: 'referral_flag') bool get referralFlag;
/// Create a copy of NcdScreeningItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NcdScreeningItemCopyWith<NcdScreeningItem> get copyWith => _$NcdScreeningItemCopyWithImpl<NcdScreeningItem>(this as NcdScreeningItem, _$identity);

  /// Serializes this NcdScreeningItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NcdScreeningItem&&(identical(other.id, id) || other.id == id)&&(identical(other.screeningDate, screeningDate) || other.screeningDate == screeningDate)&&(identical(other.bpSystolic, bpSystolic) || other.bpSystolic == bpSystolic)&&(identical(other.bpDiastolic, bpDiastolic) || other.bpDiastolic == bpDiastolic)&&(identical(other.bloodSugarMgdl, bloodSugarMgdl) || other.bloodSugarMgdl == bloodSugarMgdl)&&(identical(other.bmi, bmi) || other.bmi == bmi)&&(identical(other.riskLevel, riskLevel) || other.riskLevel == riskLevel)&&(identical(other.referralFlag, referralFlag) || other.referralFlag == referralFlag));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,screeningDate,bpSystolic,bpDiastolic,bloodSugarMgdl,bmi,riskLevel,referralFlag);

@override
String toString() {
  return 'NcdScreeningItem(id: $id, screeningDate: $screeningDate, bpSystolic: $bpSystolic, bpDiastolic: $bpDiastolic, bloodSugarMgdl: $bloodSugarMgdl, bmi: $bmi, riskLevel: $riskLevel, referralFlag: $referralFlag)';
}


}

/// @nodoc
abstract mixin class $NcdScreeningItemCopyWith<$Res>  {
  factory $NcdScreeningItemCopyWith(NcdScreeningItem value, $Res Function(NcdScreeningItem) _then) = _$NcdScreeningItemCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'screening_date') String screeningDate,@JsonKey(name: 'bp_systolic') int? bpSystolic,@JsonKey(name: 'bp_diastolic') int? bpDiastolic,@JsonKey(name: 'blood_sugar_mgdl') double? bloodSugarMgdl, double? bmi,@JsonKey(name: 'risk_level') String? riskLevel,@JsonKey(name: 'referral_flag') bool referralFlag
});




}
/// @nodoc
class _$NcdScreeningItemCopyWithImpl<$Res>
    implements $NcdScreeningItemCopyWith<$Res> {
  _$NcdScreeningItemCopyWithImpl(this._self, this._then);

  final NcdScreeningItem _self;
  final $Res Function(NcdScreeningItem) _then;

/// Create a copy of NcdScreeningItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? screeningDate = null,Object? bpSystolic = freezed,Object? bpDiastolic = freezed,Object? bloodSugarMgdl = freezed,Object? bmi = freezed,Object? riskLevel = freezed,Object? referralFlag = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,screeningDate: null == screeningDate ? _self.screeningDate : screeningDate // ignore: cast_nullable_to_non_nullable
as String,bpSystolic: freezed == bpSystolic ? _self.bpSystolic : bpSystolic // ignore: cast_nullable_to_non_nullable
as int?,bpDiastolic: freezed == bpDiastolic ? _self.bpDiastolic : bpDiastolic // ignore: cast_nullable_to_non_nullable
as int?,bloodSugarMgdl: freezed == bloodSugarMgdl ? _self.bloodSugarMgdl : bloodSugarMgdl // ignore: cast_nullable_to_non_nullable
as double?,bmi: freezed == bmi ? _self.bmi : bmi // ignore: cast_nullable_to_non_nullable
as double?,riskLevel: freezed == riskLevel ? _self.riskLevel : riskLevel // ignore: cast_nullable_to_non_nullable
as String?,referralFlag: null == referralFlag ? _self.referralFlag : referralFlag // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NcdScreeningItem].
extension NcdScreeningItemPatterns on NcdScreeningItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NcdScreeningItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NcdScreeningItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NcdScreeningItem value)  $default,){
final _that = this;
switch (_that) {
case _NcdScreeningItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NcdScreeningItem value)?  $default,){
final _that = this;
switch (_that) {
case _NcdScreeningItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'screening_date')  String screeningDate, @JsonKey(name: 'bp_systolic')  int? bpSystolic, @JsonKey(name: 'bp_diastolic')  int? bpDiastolic, @JsonKey(name: 'blood_sugar_mgdl')  double? bloodSugarMgdl,  double? bmi, @JsonKey(name: 'risk_level')  String? riskLevel, @JsonKey(name: 'referral_flag')  bool referralFlag)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NcdScreeningItem() when $default != null:
return $default(_that.id,_that.screeningDate,_that.bpSystolic,_that.bpDiastolic,_that.bloodSugarMgdl,_that.bmi,_that.riskLevel,_that.referralFlag);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'screening_date')  String screeningDate, @JsonKey(name: 'bp_systolic')  int? bpSystolic, @JsonKey(name: 'bp_diastolic')  int? bpDiastolic, @JsonKey(name: 'blood_sugar_mgdl')  double? bloodSugarMgdl,  double? bmi, @JsonKey(name: 'risk_level')  String? riskLevel, @JsonKey(name: 'referral_flag')  bool referralFlag)  $default,) {final _that = this;
switch (_that) {
case _NcdScreeningItem():
return $default(_that.id,_that.screeningDate,_that.bpSystolic,_that.bpDiastolic,_that.bloodSugarMgdl,_that.bmi,_that.riskLevel,_that.referralFlag);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'screening_date')  String screeningDate, @JsonKey(name: 'bp_systolic')  int? bpSystolic, @JsonKey(name: 'bp_diastolic')  int? bpDiastolic, @JsonKey(name: 'blood_sugar_mgdl')  double? bloodSugarMgdl,  double? bmi, @JsonKey(name: 'risk_level')  String? riskLevel, @JsonKey(name: 'referral_flag')  bool referralFlag)?  $default,) {final _that = this;
switch (_that) {
case _NcdScreeningItem() when $default != null:
return $default(_that.id,_that.screeningDate,_that.bpSystolic,_that.bpDiastolic,_that.bloodSugarMgdl,_that.bmi,_that.riskLevel,_that.referralFlag);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NcdScreeningItem implements NcdScreeningItem {
  const _NcdScreeningItem({required this.id, @JsonKey(name: 'screening_date') required this.screeningDate, @JsonKey(name: 'bp_systolic') this.bpSystolic, @JsonKey(name: 'bp_diastolic') this.bpDiastolic, @JsonKey(name: 'blood_sugar_mgdl') this.bloodSugarMgdl, this.bmi, @JsonKey(name: 'risk_level') this.riskLevel, @JsonKey(name: 'referral_flag') required this.referralFlag});
  factory _NcdScreeningItem.fromJson(Map<String, dynamic> json) => _$NcdScreeningItemFromJson(json);

@override final  int id;
@override@JsonKey(name: 'screening_date') final  String screeningDate;
@override@JsonKey(name: 'bp_systolic') final  int? bpSystolic;
@override@JsonKey(name: 'bp_diastolic') final  int? bpDiastolic;
@override@JsonKey(name: 'blood_sugar_mgdl') final  double? bloodSugarMgdl;
@override final  double? bmi;
@override@JsonKey(name: 'risk_level') final  String? riskLevel;
@override@JsonKey(name: 'referral_flag') final  bool referralFlag;

/// Create a copy of NcdScreeningItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NcdScreeningItemCopyWith<_NcdScreeningItem> get copyWith => __$NcdScreeningItemCopyWithImpl<_NcdScreeningItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NcdScreeningItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NcdScreeningItem&&(identical(other.id, id) || other.id == id)&&(identical(other.screeningDate, screeningDate) || other.screeningDate == screeningDate)&&(identical(other.bpSystolic, bpSystolic) || other.bpSystolic == bpSystolic)&&(identical(other.bpDiastolic, bpDiastolic) || other.bpDiastolic == bpDiastolic)&&(identical(other.bloodSugarMgdl, bloodSugarMgdl) || other.bloodSugarMgdl == bloodSugarMgdl)&&(identical(other.bmi, bmi) || other.bmi == bmi)&&(identical(other.riskLevel, riskLevel) || other.riskLevel == riskLevel)&&(identical(other.referralFlag, referralFlag) || other.referralFlag == referralFlag));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,screeningDate,bpSystolic,bpDiastolic,bloodSugarMgdl,bmi,riskLevel,referralFlag);

@override
String toString() {
  return 'NcdScreeningItem(id: $id, screeningDate: $screeningDate, bpSystolic: $bpSystolic, bpDiastolic: $bpDiastolic, bloodSugarMgdl: $bloodSugarMgdl, bmi: $bmi, riskLevel: $riskLevel, referralFlag: $referralFlag)';
}


}

/// @nodoc
abstract mixin class _$NcdScreeningItemCopyWith<$Res> implements $NcdScreeningItemCopyWith<$Res> {
  factory _$NcdScreeningItemCopyWith(_NcdScreeningItem value, $Res Function(_NcdScreeningItem) _then) = __$NcdScreeningItemCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'screening_date') String screeningDate,@JsonKey(name: 'bp_systolic') int? bpSystolic,@JsonKey(name: 'bp_diastolic') int? bpDiastolic,@JsonKey(name: 'blood_sugar_mgdl') double? bloodSugarMgdl, double? bmi,@JsonKey(name: 'risk_level') String? riskLevel,@JsonKey(name: 'referral_flag') bool referralFlag
});




}
/// @nodoc
class __$NcdScreeningItemCopyWithImpl<$Res>
    implements _$NcdScreeningItemCopyWith<$Res> {
  __$NcdScreeningItemCopyWithImpl(this._self, this._then);

  final _NcdScreeningItem _self;
  final $Res Function(_NcdScreeningItem) _then;

/// Create a copy of NcdScreeningItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? screeningDate = null,Object? bpSystolic = freezed,Object? bpDiastolic = freezed,Object? bloodSugarMgdl = freezed,Object? bmi = freezed,Object? riskLevel = freezed,Object? referralFlag = null,}) {
  return _then(_NcdScreeningItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,screeningDate: null == screeningDate ? _self.screeningDate : screeningDate // ignore: cast_nullable_to_non_nullable
as String,bpSystolic: freezed == bpSystolic ? _self.bpSystolic : bpSystolic // ignore: cast_nullable_to_non_nullable
as int?,bpDiastolic: freezed == bpDiastolic ? _self.bpDiastolic : bpDiastolic // ignore: cast_nullable_to_non_nullable
as int?,bloodSugarMgdl: freezed == bloodSugarMgdl ? _self.bloodSugarMgdl : bloodSugarMgdl // ignore: cast_nullable_to_non_nullable
as double?,bmi: freezed == bmi ? _self.bmi : bmi // ignore: cast_nullable_to_non_nullable
as double?,riskLevel: freezed == riskLevel ? _self.riskLevel : riskLevel // ignore: cast_nullable_to_non_nullable
as String?,referralFlag: null == referralFlag ? _self.referralFlag : referralFlag // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$TbScreeningItem {

 int get id;@JsonKey(name: 'screening_date') String get screeningDate;@JsonKey(name: 'is_suspected') bool get isSuspected;@JsonKey(name: 'referral_flag') bool get referralFlag;
/// Create a copy of TbScreeningItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TbScreeningItemCopyWith<TbScreeningItem> get copyWith => _$TbScreeningItemCopyWithImpl<TbScreeningItem>(this as TbScreeningItem, _$identity);

  /// Serializes this TbScreeningItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TbScreeningItem&&(identical(other.id, id) || other.id == id)&&(identical(other.screeningDate, screeningDate) || other.screeningDate == screeningDate)&&(identical(other.isSuspected, isSuspected) || other.isSuspected == isSuspected)&&(identical(other.referralFlag, referralFlag) || other.referralFlag == referralFlag));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,screeningDate,isSuspected,referralFlag);

@override
String toString() {
  return 'TbScreeningItem(id: $id, screeningDate: $screeningDate, isSuspected: $isSuspected, referralFlag: $referralFlag)';
}


}

/// @nodoc
abstract mixin class $TbScreeningItemCopyWith<$Res>  {
  factory $TbScreeningItemCopyWith(TbScreeningItem value, $Res Function(TbScreeningItem) _then) = _$TbScreeningItemCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'screening_date') String screeningDate,@JsonKey(name: 'is_suspected') bool isSuspected,@JsonKey(name: 'referral_flag') bool referralFlag
});




}
/// @nodoc
class _$TbScreeningItemCopyWithImpl<$Res>
    implements $TbScreeningItemCopyWith<$Res> {
  _$TbScreeningItemCopyWithImpl(this._self, this._then);

  final TbScreeningItem _self;
  final $Res Function(TbScreeningItem) _then;

/// Create a copy of TbScreeningItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? screeningDate = null,Object? isSuspected = null,Object? referralFlag = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,screeningDate: null == screeningDate ? _self.screeningDate : screeningDate // ignore: cast_nullable_to_non_nullable
as String,isSuspected: null == isSuspected ? _self.isSuspected : isSuspected // ignore: cast_nullable_to_non_nullable
as bool,referralFlag: null == referralFlag ? _self.referralFlag : referralFlag // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TbScreeningItem].
extension TbScreeningItemPatterns on TbScreeningItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TbScreeningItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TbScreeningItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TbScreeningItem value)  $default,){
final _that = this;
switch (_that) {
case _TbScreeningItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TbScreeningItem value)?  $default,){
final _that = this;
switch (_that) {
case _TbScreeningItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'screening_date')  String screeningDate, @JsonKey(name: 'is_suspected')  bool isSuspected, @JsonKey(name: 'referral_flag')  bool referralFlag)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TbScreeningItem() when $default != null:
return $default(_that.id,_that.screeningDate,_that.isSuspected,_that.referralFlag);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'screening_date')  String screeningDate, @JsonKey(name: 'is_suspected')  bool isSuspected, @JsonKey(name: 'referral_flag')  bool referralFlag)  $default,) {final _that = this;
switch (_that) {
case _TbScreeningItem():
return $default(_that.id,_that.screeningDate,_that.isSuspected,_that.referralFlag);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'screening_date')  String screeningDate, @JsonKey(name: 'is_suspected')  bool isSuspected, @JsonKey(name: 'referral_flag')  bool referralFlag)?  $default,) {final _that = this;
switch (_that) {
case _TbScreeningItem() when $default != null:
return $default(_that.id,_that.screeningDate,_that.isSuspected,_that.referralFlag);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TbScreeningItem implements TbScreeningItem {
  const _TbScreeningItem({required this.id, @JsonKey(name: 'screening_date') required this.screeningDate, @JsonKey(name: 'is_suspected') required this.isSuspected, @JsonKey(name: 'referral_flag') required this.referralFlag});
  factory _TbScreeningItem.fromJson(Map<String, dynamic> json) => _$TbScreeningItemFromJson(json);

@override final  int id;
@override@JsonKey(name: 'screening_date') final  String screeningDate;
@override@JsonKey(name: 'is_suspected') final  bool isSuspected;
@override@JsonKey(name: 'referral_flag') final  bool referralFlag;

/// Create a copy of TbScreeningItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TbScreeningItemCopyWith<_TbScreeningItem> get copyWith => __$TbScreeningItemCopyWithImpl<_TbScreeningItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TbScreeningItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TbScreeningItem&&(identical(other.id, id) || other.id == id)&&(identical(other.screeningDate, screeningDate) || other.screeningDate == screeningDate)&&(identical(other.isSuspected, isSuspected) || other.isSuspected == isSuspected)&&(identical(other.referralFlag, referralFlag) || other.referralFlag == referralFlag));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,screeningDate,isSuspected,referralFlag);

@override
String toString() {
  return 'TbScreeningItem(id: $id, screeningDate: $screeningDate, isSuspected: $isSuspected, referralFlag: $referralFlag)';
}


}

/// @nodoc
abstract mixin class _$TbScreeningItemCopyWith<$Res> implements $TbScreeningItemCopyWith<$Res> {
  factory _$TbScreeningItemCopyWith(_TbScreeningItem value, $Res Function(_TbScreeningItem) _then) = __$TbScreeningItemCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'screening_date') String screeningDate,@JsonKey(name: 'is_suspected') bool isSuspected,@JsonKey(name: 'referral_flag') bool referralFlag
});




}
/// @nodoc
class __$TbScreeningItemCopyWithImpl<$Res>
    implements _$TbScreeningItemCopyWith<$Res> {
  __$TbScreeningItemCopyWithImpl(this._self, this._then);

  final _TbScreeningItem _self;
  final $Res Function(_TbScreeningItem) _then;

/// Create a copy of TbScreeningItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? screeningDate = null,Object? isSuspected = null,Object? referralFlag = null,}) {
  return _then(_TbScreeningItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,screeningDate: null == screeningDate ? _self.screeningDate : screeningDate // ignore: cast_nullable_to_non_nullable
as String,isSuspected: null == isSuspected ? _self.isSuspected : isSuspected // ignore: cast_nullable_to_non_nullable
as bool,referralFlag: null == referralFlag ? _self.referralFlag : referralFlag // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
