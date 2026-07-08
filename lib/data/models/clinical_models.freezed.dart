// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clinical_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LabTestItem {

 int get id;@JsonKey(name: 'visit_id') int get visitId;@JsonKey(name: 'test_id') int get testId; String get status;@JsonKey(name: 'result_value') String? get resultValue;@JsonKey(name: 'result_notes') String? get resultNotes; String? get unit;@JsonKey(name: 'reference_range') String? get referenceRange;@JsonKey(name: 'completed_at') String? get completedAt;
/// Create a copy of LabTestItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LabTestItemCopyWith<LabTestItem> get copyWith => _$LabTestItemCopyWithImpl<LabTestItem>(this as LabTestItem, _$identity);

  /// Serializes this LabTestItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LabTestItem&&(identical(other.id, id) || other.id == id)&&(identical(other.visitId, visitId) || other.visitId == visitId)&&(identical(other.testId, testId) || other.testId == testId)&&(identical(other.status, status) || other.status == status)&&(identical(other.resultValue, resultValue) || other.resultValue == resultValue)&&(identical(other.resultNotes, resultNotes) || other.resultNotes == resultNotes)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.referenceRange, referenceRange) || other.referenceRange == referenceRange)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,visitId,testId,status,resultValue,resultNotes,unit,referenceRange,completedAt);

@override
String toString() {
  return 'LabTestItem(id: $id, visitId: $visitId, testId: $testId, status: $status, resultValue: $resultValue, resultNotes: $resultNotes, unit: $unit, referenceRange: $referenceRange, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $LabTestItemCopyWith<$Res>  {
  factory $LabTestItemCopyWith(LabTestItem value, $Res Function(LabTestItem) _then) = _$LabTestItemCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'visit_id') int visitId,@JsonKey(name: 'test_id') int testId, String status,@JsonKey(name: 'result_value') String? resultValue,@JsonKey(name: 'result_notes') String? resultNotes, String? unit,@JsonKey(name: 'reference_range') String? referenceRange,@JsonKey(name: 'completed_at') String? completedAt
});




}
/// @nodoc
class _$LabTestItemCopyWithImpl<$Res>
    implements $LabTestItemCopyWith<$Res> {
  _$LabTestItemCopyWithImpl(this._self, this._then);

  final LabTestItem _self;
  final $Res Function(LabTestItem) _then;

/// Create a copy of LabTestItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? visitId = null,Object? testId = null,Object? status = null,Object? resultValue = freezed,Object? resultNotes = freezed,Object? unit = freezed,Object? referenceRange = freezed,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,visitId: null == visitId ? _self.visitId : visitId // ignore: cast_nullable_to_non_nullable
as int,testId: null == testId ? _self.testId : testId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,resultValue: freezed == resultValue ? _self.resultValue : resultValue // ignore: cast_nullable_to_non_nullable
as String?,resultNotes: freezed == resultNotes ? _self.resultNotes : resultNotes // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,referenceRange: freezed == referenceRange ? _self.referenceRange : referenceRange // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LabTestItem].
extension LabTestItemPatterns on LabTestItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LabTestItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LabTestItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LabTestItem value)  $default,){
final _that = this;
switch (_that) {
case _LabTestItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LabTestItem value)?  $default,){
final _that = this;
switch (_that) {
case _LabTestItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'visit_id')  int visitId, @JsonKey(name: 'test_id')  int testId,  String status, @JsonKey(name: 'result_value')  String? resultValue, @JsonKey(name: 'result_notes')  String? resultNotes,  String? unit, @JsonKey(name: 'reference_range')  String? referenceRange, @JsonKey(name: 'completed_at')  String? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LabTestItem() when $default != null:
return $default(_that.id,_that.visitId,_that.testId,_that.status,_that.resultValue,_that.resultNotes,_that.unit,_that.referenceRange,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'visit_id')  int visitId, @JsonKey(name: 'test_id')  int testId,  String status, @JsonKey(name: 'result_value')  String? resultValue, @JsonKey(name: 'result_notes')  String? resultNotes,  String? unit, @JsonKey(name: 'reference_range')  String? referenceRange, @JsonKey(name: 'completed_at')  String? completedAt)  $default,) {final _that = this;
switch (_that) {
case _LabTestItem():
return $default(_that.id,_that.visitId,_that.testId,_that.status,_that.resultValue,_that.resultNotes,_that.unit,_that.referenceRange,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'visit_id')  int visitId, @JsonKey(name: 'test_id')  int testId,  String status, @JsonKey(name: 'result_value')  String? resultValue, @JsonKey(name: 'result_notes')  String? resultNotes,  String? unit, @JsonKey(name: 'reference_range')  String? referenceRange, @JsonKey(name: 'completed_at')  String? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _LabTestItem() when $default != null:
return $default(_that.id,_that.visitId,_that.testId,_that.status,_that.resultValue,_that.resultNotes,_that.unit,_that.referenceRange,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LabTestItem implements LabTestItem {
  const _LabTestItem({required this.id, @JsonKey(name: 'visit_id') required this.visitId, @JsonKey(name: 'test_id') required this.testId, required this.status, @JsonKey(name: 'result_value') this.resultValue, @JsonKey(name: 'result_notes') this.resultNotes, this.unit, @JsonKey(name: 'reference_range') this.referenceRange, @JsonKey(name: 'completed_at') this.completedAt});
  factory _LabTestItem.fromJson(Map<String, dynamic> json) => _$LabTestItemFromJson(json);

@override final  int id;
@override@JsonKey(name: 'visit_id') final  int visitId;
@override@JsonKey(name: 'test_id') final  int testId;
@override final  String status;
@override@JsonKey(name: 'result_value') final  String? resultValue;
@override@JsonKey(name: 'result_notes') final  String? resultNotes;
@override final  String? unit;
@override@JsonKey(name: 'reference_range') final  String? referenceRange;
@override@JsonKey(name: 'completed_at') final  String? completedAt;

/// Create a copy of LabTestItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LabTestItemCopyWith<_LabTestItem> get copyWith => __$LabTestItemCopyWithImpl<_LabTestItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LabTestItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LabTestItem&&(identical(other.id, id) || other.id == id)&&(identical(other.visitId, visitId) || other.visitId == visitId)&&(identical(other.testId, testId) || other.testId == testId)&&(identical(other.status, status) || other.status == status)&&(identical(other.resultValue, resultValue) || other.resultValue == resultValue)&&(identical(other.resultNotes, resultNotes) || other.resultNotes == resultNotes)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.referenceRange, referenceRange) || other.referenceRange == referenceRange)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,visitId,testId,status,resultValue,resultNotes,unit,referenceRange,completedAt);

@override
String toString() {
  return 'LabTestItem(id: $id, visitId: $visitId, testId: $testId, status: $status, resultValue: $resultValue, resultNotes: $resultNotes, unit: $unit, referenceRange: $referenceRange, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$LabTestItemCopyWith<$Res> implements $LabTestItemCopyWith<$Res> {
  factory _$LabTestItemCopyWith(_LabTestItem value, $Res Function(_LabTestItem) _then) = __$LabTestItemCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'visit_id') int visitId,@JsonKey(name: 'test_id') int testId, String status,@JsonKey(name: 'result_value') String? resultValue,@JsonKey(name: 'result_notes') String? resultNotes, String? unit,@JsonKey(name: 'reference_range') String? referenceRange,@JsonKey(name: 'completed_at') String? completedAt
});




}
/// @nodoc
class __$LabTestItemCopyWithImpl<$Res>
    implements _$LabTestItemCopyWith<$Res> {
  __$LabTestItemCopyWithImpl(this._self, this._then);

  final _LabTestItem _self;
  final $Res Function(_LabTestItem) _then;

/// Create a copy of LabTestItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? visitId = null,Object? testId = null,Object? status = null,Object? resultValue = freezed,Object? resultNotes = freezed,Object? unit = freezed,Object? referenceRange = freezed,Object? completedAt = freezed,}) {
  return _then(_LabTestItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,visitId: null == visitId ? _self.visitId : visitId // ignore: cast_nullable_to_non_nullable
as int,testId: null == testId ? _self.testId : testId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,resultValue: freezed == resultValue ? _self.resultValue : resultValue // ignore: cast_nullable_to_non_nullable
as String?,resultNotes: freezed == resultNotes ? _self.resultNotes : resultNotes // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,referenceRange: freezed == referenceRange ? _self.referenceRange : referenceRange // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ReferralItem {

 int get id;@JsonKey(name: 'from_facility_id') int get fromFacilityId;@JsonKey(name: 'to_facility_id') int get toFacilityId; String? get reason;@JsonKey(name: 'referred_at') String get referredAt; String get status;
/// Create a copy of ReferralItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReferralItemCopyWith<ReferralItem> get copyWith => _$ReferralItemCopyWithImpl<ReferralItem>(this as ReferralItem, _$identity);

  /// Serializes this ReferralItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferralItem&&(identical(other.id, id) || other.id == id)&&(identical(other.fromFacilityId, fromFacilityId) || other.fromFacilityId == fromFacilityId)&&(identical(other.toFacilityId, toFacilityId) || other.toFacilityId == toFacilityId)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.referredAt, referredAt) || other.referredAt == referredAt)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fromFacilityId,toFacilityId,reason,referredAt,status);

@override
String toString() {
  return 'ReferralItem(id: $id, fromFacilityId: $fromFacilityId, toFacilityId: $toFacilityId, reason: $reason, referredAt: $referredAt, status: $status)';
}


}

/// @nodoc
abstract mixin class $ReferralItemCopyWith<$Res>  {
  factory $ReferralItemCopyWith(ReferralItem value, $Res Function(ReferralItem) _then) = _$ReferralItemCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'from_facility_id') int fromFacilityId,@JsonKey(name: 'to_facility_id') int toFacilityId, String? reason,@JsonKey(name: 'referred_at') String referredAt, String status
});




}
/// @nodoc
class _$ReferralItemCopyWithImpl<$Res>
    implements $ReferralItemCopyWith<$Res> {
  _$ReferralItemCopyWithImpl(this._self, this._then);

  final ReferralItem _self;
  final $Res Function(ReferralItem) _then;

/// Create a copy of ReferralItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fromFacilityId = null,Object? toFacilityId = null,Object? reason = freezed,Object? referredAt = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,fromFacilityId: null == fromFacilityId ? _self.fromFacilityId : fromFacilityId // ignore: cast_nullable_to_non_nullable
as int,toFacilityId: null == toFacilityId ? _self.toFacilityId : toFacilityId // ignore: cast_nullable_to_non_nullable
as int,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,referredAt: null == referredAt ? _self.referredAt : referredAt // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReferralItem].
extension ReferralItemPatterns on ReferralItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReferralItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReferralItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReferralItem value)  $default,){
final _that = this;
switch (_that) {
case _ReferralItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReferralItem value)?  $default,){
final _that = this;
switch (_that) {
case _ReferralItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'from_facility_id')  int fromFacilityId, @JsonKey(name: 'to_facility_id')  int toFacilityId,  String? reason, @JsonKey(name: 'referred_at')  String referredAt,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReferralItem() when $default != null:
return $default(_that.id,_that.fromFacilityId,_that.toFacilityId,_that.reason,_that.referredAt,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'from_facility_id')  int fromFacilityId, @JsonKey(name: 'to_facility_id')  int toFacilityId,  String? reason, @JsonKey(name: 'referred_at')  String referredAt,  String status)  $default,) {final _that = this;
switch (_that) {
case _ReferralItem():
return $default(_that.id,_that.fromFacilityId,_that.toFacilityId,_that.reason,_that.referredAt,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'from_facility_id')  int fromFacilityId, @JsonKey(name: 'to_facility_id')  int toFacilityId,  String? reason, @JsonKey(name: 'referred_at')  String referredAt,  String status)?  $default,) {final _that = this;
switch (_that) {
case _ReferralItem() when $default != null:
return $default(_that.id,_that.fromFacilityId,_that.toFacilityId,_that.reason,_that.referredAt,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReferralItem implements ReferralItem {
  const _ReferralItem({required this.id, @JsonKey(name: 'from_facility_id') required this.fromFacilityId, @JsonKey(name: 'to_facility_id') required this.toFacilityId, this.reason, @JsonKey(name: 'referred_at') required this.referredAt, required this.status});
  factory _ReferralItem.fromJson(Map<String, dynamic> json) => _$ReferralItemFromJson(json);

@override final  int id;
@override@JsonKey(name: 'from_facility_id') final  int fromFacilityId;
@override@JsonKey(name: 'to_facility_id') final  int toFacilityId;
@override final  String? reason;
@override@JsonKey(name: 'referred_at') final  String referredAt;
@override final  String status;

/// Create a copy of ReferralItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReferralItemCopyWith<_ReferralItem> get copyWith => __$ReferralItemCopyWithImpl<_ReferralItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReferralItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReferralItem&&(identical(other.id, id) || other.id == id)&&(identical(other.fromFacilityId, fromFacilityId) || other.fromFacilityId == fromFacilityId)&&(identical(other.toFacilityId, toFacilityId) || other.toFacilityId == toFacilityId)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.referredAt, referredAt) || other.referredAt == referredAt)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fromFacilityId,toFacilityId,reason,referredAt,status);

@override
String toString() {
  return 'ReferralItem(id: $id, fromFacilityId: $fromFacilityId, toFacilityId: $toFacilityId, reason: $reason, referredAt: $referredAt, status: $status)';
}


}

/// @nodoc
abstract mixin class _$ReferralItemCopyWith<$Res> implements $ReferralItemCopyWith<$Res> {
  factory _$ReferralItemCopyWith(_ReferralItem value, $Res Function(_ReferralItem) _then) = __$ReferralItemCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'from_facility_id') int fromFacilityId,@JsonKey(name: 'to_facility_id') int toFacilityId, String? reason,@JsonKey(name: 'referred_at') String referredAt, String status
});




}
/// @nodoc
class __$ReferralItemCopyWithImpl<$Res>
    implements _$ReferralItemCopyWith<$Res> {
  __$ReferralItemCopyWithImpl(this._self, this._then);

  final _ReferralItem _self;
  final $Res Function(_ReferralItem) _then;

/// Create a copy of ReferralItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fromFacilityId = null,Object? toFacilityId = null,Object? reason = freezed,Object? referredAt = null,Object? status = null,}) {
  return _then(_ReferralItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,fromFacilityId: null == fromFacilityId ? _self.fromFacilityId : fromFacilityId // ignore: cast_nullable_to_non_nullable
as int,toFacilityId: null == toFacilityId ? _self.toFacilityId : toFacilityId // ignore: cast_nullable_to_non_nullable
as int,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,referredAt: null == referredAt ? _self.referredAt : referredAt // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$NotificationItem {

 int get id; String get module;@JsonKey(name: 'notification_type') String get notificationType; String get channel;@JsonKey(name: 'message_text') String get messageText; String get status;@JsonKey(name: 'created_at') String get createdAt;
/// Create a copy of NotificationItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationItemCopyWith<NotificationItem> get copyWith => _$NotificationItemCopyWithImpl<NotificationItem>(this as NotificationItem, _$identity);

  /// Serializes this NotificationItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationItem&&(identical(other.id, id) || other.id == id)&&(identical(other.module, module) || other.module == module)&&(identical(other.notificationType, notificationType) || other.notificationType == notificationType)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.messageText, messageText) || other.messageText == messageText)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,module,notificationType,channel,messageText,status,createdAt);

@override
String toString() {
  return 'NotificationItem(id: $id, module: $module, notificationType: $notificationType, channel: $channel, messageText: $messageText, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $NotificationItemCopyWith<$Res>  {
  factory $NotificationItemCopyWith(NotificationItem value, $Res Function(NotificationItem) _then) = _$NotificationItemCopyWithImpl;
@useResult
$Res call({
 int id, String module,@JsonKey(name: 'notification_type') String notificationType, String channel,@JsonKey(name: 'message_text') String messageText, String status,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class _$NotificationItemCopyWithImpl<$Res>
    implements $NotificationItemCopyWith<$Res> {
  _$NotificationItemCopyWithImpl(this._self, this._then);

  final NotificationItem _self;
  final $Res Function(NotificationItem) _then;

/// Create a copy of NotificationItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? module = null,Object? notificationType = null,Object? channel = null,Object? messageText = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,module: null == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as String,notificationType: null == notificationType ? _self.notificationType : notificationType // ignore: cast_nullable_to_non_nullable
as String,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as String,messageText: null == messageText ? _self.messageText : messageText // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationItem].
extension NotificationItemPatterns on NotificationItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationItem value)  $default,){
final _that = this;
switch (_that) {
case _NotificationItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationItem value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String module, @JsonKey(name: 'notification_type')  String notificationType,  String channel, @JsonKey(name: 'message_text')  String messageText,  String status, @JsonKey(name: 'created_at')  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationItem() when $default != null:
return $default(_that.id,_that.module,_that.notificationType,_that.channel,_that.messageText,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String module, @JsonKey(name: 'notification_type')  String notificationType,  String channel, @JsonKey(name: 'message_text')  String messageText,  String status, @JsonKey(name: 'created_at')  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _NotificationItem():
return $default(_that.id,_that.module,_that.notificationType,_that.channel,_that.messageText,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String module, @JsonKey(name: 'notification_type')  String notificationType,  String channel, @JsonKey(name: 'message_text')  String messageText,  String status, @JsonKey(name: 'created_at')  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _NotificationItem() when $default != null:
return $default(_that.id,_that.module,_that.notificationType,_that.channel,_that.messageText,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationItem implements NotificationItem {
  const _NotificationItem({required this.id, required this.module, @JsonKey(name: 'notification_type') required this.notificationType, required this.channel, @JsonKey(name: 'message_text') required this.messageText, required this.status, @JsonKey(name: 'created_at') required this.createdAt});
  factory _NotificationItem.fromJson(Map<String, dynamic> json) => _$NotificationItemFromJson(json);

@override final  int id;
@override final  String module;
@override@JsonKey(name: 'notification_type') final  String notificationType;
@override final  String channel;
@override@JsonKey(name: 'message_text') final  String messageText;
@override final  String status;
@override@JsonKey(name: 'created_at') final  String createdAt;

/// Create a copy of NotificationItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationItemCopyWith<_NotificationItem> get copyWith => __$NotificationItemCopyWithImpl<_NotificationItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationItem&&(identical(other.id, id) || other.id == id)&&(identical(other.module, module) || other.module == module)&&(identical(other.notificationType, notificationType) || other.notificationType == notificationType)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.messageText, messageText) || other.messageText == messageText)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,module,notificationType,channel,messageText,status,createdAt);

@override
String toString() {
  return 'NotificationItem(id: $id, module: $module, notificationType: $notificationType, channel: $channel, messageText: $messageText, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$NotificationItemCopyWith<$Res> implements $NotificationItemCopyWith<$Res> {
  factory _$NotificationItemCopyWith(_NotificationItem value, $Res Function(_NotificationItem) _then) = __$NotificationItemCopyWithImpl;
@override @useResult
$Res call({
 int id, String module,@JsonKey(name: 'notification_type') String notificationType, String channel,@JsonKey(name: 'message_text') String messageText, String status,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class __$NotificationItemCopyWithImpl<$Res>
    implements _$NotificationItemCopyWith<$Res> {
  __$NotificationItemCopyWithImpl(this._self, this._then);

  final _NotificationItem _self;
  final $Res Function(_NotificationItem) _then;

/// Create a copy of NotificationItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? module = null,Object? notificationType = null,Object? channel = null,Object? messageText = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_NotificationItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,module: null == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as String,notificationType: null == notificationType ? _self.notificationType : notificationType // ignore: cast_nullable_to_non_nullable
as String,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as String,messageText: null == messageText ? _self.messageText : messageText // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
