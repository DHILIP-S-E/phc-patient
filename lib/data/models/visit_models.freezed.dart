// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'visit_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VisitItem {

 int get id;@JsonKey(name: 'facility_id') int get facilityId;@JsonKey(name: 'op_number') String get opNumber;@JsonKey(name: 'visit_date') String get visitDate;@JsonKey(name: 'visit_type') String get visitType; String get status;@JsonKey(name: 'queue_token') int? get queueToken; String get priority;@JsonKey(name: 'called_at') String? get calledAt;
/// Create a copy of VisitItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisitItemCopyWith<VisitItem> get copyWith => _$VisitItemCopyWithImpl<VisitItem>(this as VisitItem, _$identity);

  /// Serializes this VisitItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisitItem&&(identical(other.id, id) || other.id == id)&&(identical(other.facilityId, facilityId) || other.facilityId == facilityId)&&(identical(other.opNumber, opNumber) || other.opNumber == opNumber)&&(identical(other.visitDate, visitDate) || other.visitDate == visitDate)&&(identical(other.visitType, visitType) || other.visitType == visitType)&&(identical(other.status, status) || other.status == status)&&(identical(other.queueToken, queueToken) || other.queueToken == queueToken)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.calledAt, calledAt) || other.calledAt == calledAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,facilityId,opNumber,visitDate,visitType,status,queueToken,priority,calledAt);

@override
String toString() {
  return 'VisitItem(id: $id, facilityId: $facilityId, opNumber: $opNumber, visitDate: $visitDate, visitType: $visitType, status: $status, queueToken: $queueToken, priority: $priority, calledAt: $calledAt)';
}


}

/// @nodoc
abstract mixin class $VisitItemCopyWith<$Res>  {
  factory $VisitItemCopyWith(VisitItem value, $Res Function(VisitItem) _then) = _$VisitItemCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'facility_id') int facilityId,@JsonKey(name: 'op_number') String opNumber,@JsonKey(name: 'visit_date') String visitDate,@JsonKey(name: 'visit_type') String visitType, String status,@JsonKey(name: 'queue_token') int? queueToken, String priority,@JsonKey(name: 'called_at') String? calledAt
});




}
/// @nodoc
class _$VisitItemCopyWithImpl<$Res>
    implements $VisitItemCopyWith<$Res> {
  _$VisitItemCopyWithImpl(this._self, this._then);

  final VisitItem _self;
  final $Res Function(VisitItem) _then;

/// Create a copy of VisitItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? facilityId = null,Object? opNumber = null,Object? visitDate = null,Object? visitType = null,Object? status = null,Object? queueToken = freezed,Object? priority = null,Object? calledAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,facilityId: null == facilityId ? _self.facilityId : facilityId // ignore: cast_nullable_to_non_nullable
as int,opNumber: null == opNumber ? _self.opNumber : opNumber // ignore: cast_nullable_to_non_nullable
as String,visitDate: null == visitDate ? _self.visitDate : visitDate // ignore: cast_nullable_to_non_nullable
as String,visitType: null == visitType ? _self.visitType : visitType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,queueToken: freezed == queueToken ? _self.queueToken : queueToken // ignore: cast_nullable_to_non_nullable
as int?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,calledAt: freezed == calledAt ? _self.calledAt : calledAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VisitItem].
extension VisitItemPatterns on VisitItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VisitItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VisitItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VisitItem value)  $default,){
final _that = this;
switch (_that) {
case _VisitItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VisitItem value)?  $default,){
final _that = this;
switch (_that) {
case _VisitItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'facility_id')  int facilityId, @JsonKey(name: 'op_number')  String opNumber, @JsonKey(name: 'visit_date')  String visitDate, @JsonKey(name: 'visit_type')  String visitType,  String status, @JsonKey(name: 'queue_token')  int? queueToken,  String priority, @JsonKey(name: 'called_at')  String? calledAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VisitItem() when $default != null:
return $default(_that.id,_that.facilityId,_that.opNumber,_that.visitDate,_that.visitType,_that.status,_that.queueToken,_that.priority,_that.calledAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'facility_id')  int facilityId, @JsonKey(name: 'op_number')  String opNumber, @JsonKey(name: 'visit_date')  String visitDate, @JsonKey(name: 'visit_type')  String visitType,  String status, @JsonKey(name: 'queue_token')  int? queueToken,  String priority, @JsonKey(name: 'called_at')  String? calledAt)  $default,) {final _that = this;
switch (_that) {
case _VisitItem():
return $default(_that.id,_that.facilityId,_that.opNumber,_that.visitDate,_that.visitType,_that.status,_that.queueToken,_that.priority,_that.calledAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'facility_id')  int facilityId, @JsonKey(name: 'op_number')  String opNumber, @JsonKey(name: 'visit_date')  String visitDate, @JsonKey(name: 'visit_type')  String visitType,  String status, @JsonKey(name: 'queue_token')  int? queueToken,  String priority, @JsonKey(name: 'called_at')  String? calledAt)?  $default,) {final _that = this;
switch (_that) {
case _VisitItem() when $default != null:
return $default(_that.id,_that.facilityId,_that.opNumber,_that.visitDate,_that.visitType,_that.status,_that.queueToken,_that.priority,_that.calledAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VisitItem implements VisitItem {
  const _VisitItem({required this.id, @JsonKey(name: 'facility_id') required this.facilityId, @JsonKey(name: 'op_number') required this.opNumber, @JsonKey(name: 'visit_date') required this.visitDate, @JsonKey(name: 'visit_type') required this.visitType, required this.status, @JsonKey(name: 'queue_token') this.queueToken, required this.priority, @JsonKey(name: 'called_at') this.calledAt});
  factory _VisitItem.fromJson(Map<String, dynamic> json) => _$VisitItemFromJson(json);

@override final  int id;
@override@JsonKey(name: 'facility_id') final  int facilityId;
@override@JsonKey(name: 'op_number') final  String opNumber;
@override@JsonKey(name: 'visit_date') final  String visitDate;
@override@JsonKey(name: 'visit_type') final  String visitType;
@override final  String status;
@override@JsonKey(name: 'queue_token') final  int? queueToken;
@override final  String priority;
@override@JsonKey(name: 'called_at') final  String? calledAt;

/// Create a copy of VisitItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VisitItemCopyWith<_VisitItem> get copyWith => __$VisitItemCopyWithImpl<_VisitItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VisitItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VisitItem&&(identical(other.id, id) || other.id == id)&&(identical(other.facilityId, facilityId) || other.facilityId == facilityId)&&(identical(other.opNumber, opNumber) || other.opNumber == opNumber)&&(identical(other.visitDate, visitDate) || other.visitDate == visitDate)&&(identical(other.visitType, visitType) || other.visitType == visitType)&&(identical(other.status, status) || other.status == status)&&(identical(other.queueToken, queueToken) || other.queueToken == queueToken)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.calledAt, calledAt) || other.calledAt == calledAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,facilityId,opNumber,visitDate,visitType,status,queueToken,priority,calledAt);

@override
String toString() {
  return 'VisitItem(id: $id, facilityId: $facilityId, opNumber: $opNumber, visitDate: $visitDate, visitType: $visitType, status: $status, queueToken: $queueToken, priority: $priority, calledAt: $calledAt)';
}


}

/// @nodoc
abstract mixin class _$VisitItemCopyWith<$Res> implements $VisitItemCopyWith<$Res> {
  factory _$VisitItemCopyWith(_VisitItem value, $Res Function(_VisitItem) _then) = __$VisitItemCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'facility_id') int facilityId,@JsonKey(name: 'op_number') String opNumber,@JsonKey(name: 'visit_date') String visitDate,@JsonKey(name: 'visit_type') String visitType, String status,@JsonKey(name: 'queue_token') int? queueToken, String priority,@JsonKey(name: 'called_at') String? calledAt
});




}
/// @nodoc
class __$VisitItemCopyWithImpl<$Res>
    implements _$VisitItemCopyWith<$Res> {
  __$VisitItemCopyWithImpl(this._self, this._then);

  final _VisitItem _self;
  final $Res Function(_VisitItem) _then;

/// Create a copy of VisitItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? facilityId = null,Object? opNumber = null,Object? visitDate = null,Object? visitType = null,Object? status = null,Object? queueToken = freezed,Object? priority = null,Object? calledAt = freezed,}) {
  return _then(_VisitItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,facilityId: null == facilityId ? _self.facilityId : facilityId // ignore: cast_nullable_to_non_nullable
as int,opNumber: null == opNumber ? _self.opNumber : opNumber // ignore: cast_nullable_to_non_nullable
as String,visitDate: null == visitDate ? _self.visitDate : visitDate // ignore: cast_nullable_to_non_nullable
as String,visitType: null == visitType ? _self.visitType : visitType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,queueToken: freezed == queueToken ? _self.queueToken : queueToken // ignore: cast_nullable_to_non_nullable
as int?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,calledAt: freezed == calledAt ? _self.calledAt : calledAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$QueueStatus {

@JsonKey(name: 'has_active_visit') bool get hasActiveVisit; VisitItem? get visit;
/// Create a copy of QueueStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QueueStatusCopyWith<QueueStatus> get copyWith => _$QueueStatusCopyWithImpl<QueueStatus>(this as QueueStatus, _$identity);

  /// Serializes this QueueStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QueueStatus&&(identical(other.hasActiveVisit, hasActiveVisit) || other.hasActiveVisit == hasActiveVisit)&&(identical(other.visit, visit) || other.visit == visit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hasActiveVisit,visit);

@override
String toString() {
  return 'QueueStatus(hasActiveVisit: $hasActiveVisit, visit: $visit)';
}


}

/// @nodoc
abstract mixin class $QueueStatusCopyWith<$Res>  {
  factory $QueueStatusCopyWith(QueueStatus value, $Res Function(QueueStatus) _then) = _$QueueStatusCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'has_active_visit') bool hasActiveVisit, VisitItem? visit
});


$VisitItemCopyWith<$Res>? get visit;

}
/// @nodoc
class _$QueueStatusCopyWithImpl<$Res>
    implements $QueueStatusCopyWith<$Res> {
  _$QueueStatusCopyWithImpl(this._self, this._then);

  final QueueStatus _self;
  final $Res Function(QueueStatus) _then;

/// Create a copy of QueueStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hasActiveVisit = null,Object? visit = freezed,}) {
  return _then(_self.copyWith(
hasActiveVisit: null == hasActiveVisit ? _self.hasActiveVisit : hasActiveVisit // ignore: cast_nullable_to_non_nullable
as bool,visit: freezed == visit ? _self.visit : visit // ignore: cast_nullable_to_non_nullable
as VisitItem?,
  ));
}
/// Create a copy of QueueStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VisitItemCopyWith<$Res>? get visit {
    if (_self.visit == null) {
    return null;
  }

  return $VisitItemCopyWith<$Res>(_self.visit!, (value) {
    return _then(_self.copyWith(visit: value));
  });
}
}


/// Adds pattern-matching-related methods to [QueueStatus].
extension QueueStatusPatterns on QueueStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QueueStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QueueStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QueueStatus value)  $default,){
final _that = this;
switch (_that) {
case _QueueStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QueueStatus value)?  $default,){
final _that = this;
switch (_that) {
case _QueueStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'has_active_visit')  bool hasActiveVisit,  VisitItem? visit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QueueStatus() when $default != null:
return $default(_that.hasActiveVisit,_that.visit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'has_active_visit')  bool hasActiveVisit,  VisitItem? visit)  $default,) {final _that = this;
switch (_that) {
case _QueueStatus():
return $default(_that.hasActiveVisit,_that.visit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'has_active_visit')  bool hasActiveVisit,  VisitItem? visit)?  $default,) {final _that = this;
switch (_that) {
case _QueueStatus() when $default != null:
return $default(_that.hasActiveVisit,_that.visit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QueueStatus implements QueueStatus {
  const _QueueStatus({@JsonKey(name: 'has_active_visit') required this.hasActiveVisit, this.visit});
  factory _QueueStatus.fromJson(Map<String, dynamic> json) => _$QueueStatusFromJson(json);

@override@JsonKey(name: 'has_active_visit') final  bool hasActiveVisit;
@override final  VisitItem? visit;

/// Create a copy of QueueStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QueueStatusCopyWith<_QueueStatus> get copyWith => __$QueueStatusCopyWithImpl<_QueueStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QueueStatusToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QueueStatus&&(identical(other.hasActiveVisit, hasActiveVisit) || other.hasActiveVisit == hasActiveVisit)&&(identical(other.visit, visit) || other.visit == visit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hasActiveVisit,visit);

@override
String toString() {
  return 'QueueStatus(hasActiveVisit: $hasActiveVisit, visit: $visit)';
}


}

/// @nodoc
abstract mixin class _$QueueStatusCopyWith<$Res> implements $QueueStatusCopyWith<$Res> {
  factory _$QueueStatusCopyWith(_QueueStatus value, $Res Function(_QueueStatus) _then) = __$QueueStatusCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'has_active_visit') bool hasActiveVisit, VisitItem? visit
});


@override $VisitItemCopyWith<$Res>? get visit;

}
/// @nodoc
class __$QueueStatusCopyWithImpl<$Res>
    implements _$QueueStatusCopyWith<$Res> {
  __$QueueStatusCopyWithImpl(this._self, this._then);

  final _QueueStatus _self;
  final $Res Function(_QueueStatus) _then;

/// Create a copy of QueueStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hasActiveVisit = null,Object? visit = freezed,}) {
  return _then(_QueueStatus(
hasActiveVisit: null == hasActiveVisit ? _self.hasActiveVisit : hasActiveVisit // ignore: cast_nullable_to_non_nullable
as bool,visit: freezed == visit ? _self.visit : visit // ignore: cast_nullable_to_non_nullable
as VisitItem?,
  ));
}

/// Create a copy of QueueStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VisitItemCopyWith<$Res>? get visit {
    if (_self.visit == null) {
    return null;
  }

  return $VisitItemCopyWith<$Res>(_self.visit!, (value) {
    return _then(_self.copyWith(visit: value));
  });
}
}

// dart format on
