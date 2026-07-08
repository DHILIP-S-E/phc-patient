// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pregnancy_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PregnancyDetail {

@JsonKey(name: 'pregnancy_id') int get pregnancyId;@JsonKey(name: 'lmp_date') String? get lmpDate;@JsonKey(name: 'edd_date') String? get eddDate; int? get gravida; int? get para; String get status;@JsonKey(name: 'is_high_priority') bool get isHighPriority;@JsonKey(name: 'has_high_bp') bool? get hasHighBp;@JsonKey(name: 'has_diabetes') bool? get hasDiabetes;@JsonKey(name: 'has_severe_anaemia') bool? get hasSevereAnaemia;@JsonKey(name: 'anc_visits') List<AncVisitItem> get ancVisits;
/// Create a copy of PregnancyDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PregnancyDetailCopyWith<PregnancyDetail> get copyWith => _$PregnancyDetailCopyWithImpl<PregnancyDetail>(this as PregnancyDetail, _$identity);

  /// Serializes this PregnancyDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PregnancyDetail&&(identical(other.pregnancyId, pregnancyId) || other.pregnancyId == pregnancyId)&&(identical(other.lmpDate, lmpDate) || other.lmpDate == lmpDate)&&(identical(other.eddDate, eddDate) || other.eddDate == eddDate)&&(identical(other.gravida, gravida) || other.gravida == gravida)&&(identical(other.para, para) || other.para == para)&&(identical(other.status, status) || other.status == status)&&(identical(other.isHighPriority, isHighPriority) || other.isHighPriority == isHighPriority)&&(identical(other.hasHighBp, hasHighBp) || other.hasHighBp == hasHighBp)&&(identical(other.hasDiabetes, hasDiabetes) || other.hasDiabetes == hasDiabetes)&&(identical(other.hasSevereAnaemia, hasSevereAnaemia) || other.hasSevereAnaemia == hasSevereAnaemia)&&const DeepCollectionEquality().equals(other.ancVisits, ancVisits));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pregnancyId,lmpDate,eddDate,gravida,para,status,isHighPriority,hasHighBp,hasDiabetes,hasSevereAnaemia,const DeepCollectionEquality().hash(ancVisits));

@override
String toString() {
  return 'PregnancyDetail(pregnancyId: $pregnancyId, lmpDate: $lmpDate, eddDate: $eddDate, gravida: $gravida, para: $para, status: $status, isHighPriority: $isHighPriority, hasHighBp: $hasHighBp, hasDiabetes: $hasDiabetes, hasSevereAnaemia: $hasSevereAnaemia, ancVisits: $ancVisits)';
}


}

/// @nodoc
abstract mixin class $PregnancyDetailCopyWith<$Res>  {
  factory $PregnancyDetailCopyWith(PregnancyDetail value, $Res Function(PregnancyDetail) _then) = _$PregnancyDetailCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'pregnancy_id') int pregnancyId,@JsonKey(name: 'lmp_date') String? lmpDate,@JsonKey(name: 'edd_date') String? eddDate, int? gravida, int? para, String status,@JsonKey(name: 'is_high_priority') bool isHighPriority,@JsonKey(name: 'has_high_bp') bool? hasHighBp,@JsonKey(name: 'has_diabetes') bool? hasDiabetes,@JsonKey(name: 'has_severe_anaemia') bool? hasSevereAnaemia,@JsonKey(name: 'anc_visits') List<AncVisitItem> ancVisits
});




}
/// @nodoc
class _$PregnancyDetailCopyWithImpl<$Res>
    implements $PregnancyDetailCopyWith<$Res> {
  _$PregnancyDetailCopyWithImpl(this._self, this._then);

  final PregnancyDetail _self;
  final $Res Function(PregnancyDetail) _then;

/// Create a copy of PregnancyDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pregnancyId = null,Object? lmpDate = freezed,Object? eddDate = freezed,Object? gravida = freezed,Object? para = freezed,Object? status = null,Object? isHighPriority = null,Object? hasHighBp = freezed,Object? hasDiabetes = freezed,Object? hasSevereAnaemia = freezed,Object? ancVisits = null,}) {
  return _then(_self.copyWith(
pregnancyId: null == pregnancyId ? _self.pregnancyId : pregnancyId // ignore: cast_nullable_to_non_nullable
as int,lmpDate: freezed == lmpDate ? _self.lmpDate : lmpDate // ignore: cast_nullable_to_non_nullable
as String?,eddDate: freezed == eddDate ? _self.eddDate : eddDate // ignore: cast_nullable_to_non_nullable
as String?,gravida: freezed == gravida ? _self.gravida : gravida // ignore: cast_nullable_to_non_nullable
as int?,para: freezed == para ? _self.para : para // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isHighPriority: null == isHighPriority ? _self.isHighPriority : isHighPriority // ignore: cast_nullable_to_non_nullable
as bool,hasHighBp: freezed == hasHighBp ? _self.hasHighBp : hasHighBp // ignore: cast_nullable_to_non_nullable
as bool?,hasDiabetes: freezed == hasDiabetes ? _self.hasDiabetes : hasDiabetes // ignore: cast_nullable_to_non_nullable
as bool?,hasSevereAnaemia: freezed == hasSevereAnaemia ? _self.hasSevereAnaemia : hasSevereAnaemia // ignore: cast_nullable_to_non_nullable
as bool?,ancVisits: null == ancVisits ? _self.ancVisits : ancVisits // ignore: cast_nullable_to_non_nullable
as List<AncVisitItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [PregnancyDetail].
extension PregnancyDetailPatterns on PregnancyDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PregnancyDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PregnancyDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PregnancyDetail value)  $default,){
final _that = this;
switch (_that) {
case _PregnancyDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PregnancyDetail value)?  $default,){
final _that = this;
switch (_that) {
case _PregnancyDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'pregnancy_id')  int pregnancyId, @JsonKey(name: 'lmp_date')  String? lmpDate, @JsonKey(name: 'edd_date')  String? eddDate,  int? gravida,  int? para,  String status, @JsonKey(name: 'is_high_priority')  bool isHighPriority, @JsonKey(name: 'has_high_bp')  bool? hasHighBp, @JsonKey(name: 'has_diabetes')  bool? hasDiabetes, @JsonKey(name: 'has_severe_anaemia')  bool? hasSevereAnaemia, @JsonKey(name: 'anc_visits')  List<AncVisitItem> ancVisits)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PregnancyDetail() when $default != null:
return $default(_that.pregnancyId,_that.lmpDate,_that.eddDate,_that.gravida,_that.para,_that.status,_that.isHighPriority,_that.hasHighBp,_that.hasDiabetes,_that.hasSevereAnaemia,_that.ancVisits);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'pregnancy_id')  int pregnancyId, @JsonKey(name: 'lmp_date')  String? lmpDate, @JsonKey(name: 'edd_date')  String? eddDate,  int? gravida,  int? para,  String status, @JsonKey(name: 'is_high_priority')  bool isHighPriority, @JsonKey(name: 'has_high_bp')  bool? hasHighBp, @JsonKey(name: 'has_diabetes')  bool? hasDiabetes, @JsonKey(name: 'has_severe_anaemia')  bool? hasSevereAnaemia, @JsonKey(name: 'anc_visits')  List<AncVisitItem> ancVisits)  $default,) {final _that = this;
switch (_that) {
case _PregnancyDetail():
return $default(_that.pregnancyId,_that.lmpDate,_that.eddDate,_that.gravida,_that.para,_that.status,_that.isHighPriority,_that.hasHighBp,_that.hasDiabetes,_that.hasSevereAnaemia,_that.ancVisits);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'pregnancy_id')  int pregnancyId, @JsonKey(name: 'lmp_date')  String? lmpDate, @JsonKey(name: 'edd_date')  String? eddDate,  int? gravida,  int? para,  String status, @JsonKey(name: 'is_high_priority')  bool isHighPriority, @JsonKey(name: 'has_high_bp')  bool? hasHighBp, @JsonKey(name: 'has_diabetes')  bool? hasDiabetes, @JsonKey(name: 'has_severe_anaemia')  bool? hasSevereAnaemia, @JsonKey(name: 'anc_visits')  List<AncVisitItem> ancVisits)?  $default,) {final _that = this;
switch (_that) {
case _PregnancyDetail() when $default != null:
return $default(_that.pregnancyId,_that.lmpDate,_that.eddDate,_that.gravida,_that.para,_that.status,_that.isHighPriority,_that.hasHighBp,_that.hasDiabetes,_that.hasSevereAnaemia,_that.ancVisits);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PregnancyDetail implements PregnancyDetail {
  const _PregnancyDetail({@JsonKey(name: 'pregnancy_id') required this.pregnancyId, @JsonKey(name: 'lmp_date') this.lmpDate, @JsonKey(name: 'edd_date') this.eddDate, this.gravida, this.para, required this.status, @JsonKey(name: 'is_high_priority') required this.isHighPriority, @JsonKey(name: 'has_high_bp') this.hasHighBp, @JsonKey(name: 'has_diabetes') this.hasDiabetes, @JsonKey(name: 'has_severe_anaemia') this.hasSevereAnaemia, @JsonKey(name: 'anc_visits') final  List<AncVisitItem> ancVisits = const <AncVisitItem>[]}): _ancVisits = ancVisits;
  factory _PregnancyDetail.fromJson(Map<String, dynamic> json) => _$PregnancyDetailFromJson(json);

@override@JsonKey(name: 'pregnancy_id') final  int pregnancyId;
@override@JsonKey(name: 'lmp_date') final  String? lmpDate;
@override@JsonKey(name: 'edd_date') final  String? eddDate;
@override final  int? gravida;
@override final  int? para;
@override final  String status;
@override@JsonKey(name: 'is_high_priority') final  bool isHighPriority;
@override@JsonKey(name: 'has_high_bp') final  bool? hasHighBp;
@override@JsonKey(name: 'has_diabetes') final  bool? hasDiabetes;
@override@JsonKey(name: 'has_severe_anaemia') final  bool? hasSevereAnaemia;
 final  List<AncVisitItem> _ancVisits;
@override@JsonKey(name: 'anc_visits') List<AncVisitItem> get ancVisits {
  if (_ancVisits is EqualUnmodifiableListView) return _ancVisits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ancVisits);
}


/// Create a copy of PregnancyDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PregnancyDetailCopyWith<_PregnancyDetail> get copyWith => __$PregnancyDetailCopyWithImpl<_PregnancyDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PregnancyDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PregnancyDetail&&(identical(other.pregnancyId, pregnancyId) || other.pregnancyId == pregnancyId)&&(identical(other.lmpDate, lmpDate) || other.lmpDate == lmpDate)&&(identical(other.eddDate, eddDate) || other.eddDate == eddDate)&&(identical(other.gravida, gravida) || other.gravida == gravida)&&(identical(other.para, para) || other.para == para)&&(identical(other.status, status) || other.status == status)&&(identical(other.isHighPriority, isHighPriority) || other.isHighPriority == isHighPriority)&&(identical(other.hasHighBp, hasHighBp) || other.hasHighBp == hasHighBp)&&(identical(other.hasDiabetes, hasDiabetes) || other.hasDiabetes == hasDiabetes)&&(identical(other.hasSevereAnaemia, hasSevereAnaemia) || other.hasSevereAnaemia == hasSevereAnaemia)&&const DeepCollectionEquality().equals(other._ancVisits, _ancVisits));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pregnancyId,lmpDate,eddDate,gravida,para,status,isHighPriority,hasHighBp,hasDiabetes,hasSevereAnaemia,const DeepCollectionEquality().hash(_ancVisits));

@override
String toString() {
  return 'PregnancyDetail(pregnancyId: $pregnancyId, lmpDate: $lmpDate, eddDate: $eddDate, gravida: $gravida, para: $para, status: $status, isHighPriority: $isHighPriority, hasHighBp: $hasHighBp, hasDiabetes: $hasDiabetes, hasSevereAnaemia: $hasSevereAnaemia, ancVisits: $ancVisits)';
}


}

/// @nodoc
abstract mixin class _$PregnancyDetailCopyWith<$Res> implements $PregnancyDetailCopyWith<$Res> {
  factory _$PregnancyDetailCopyWith(_PregnancyDetail value, $Res Function(_PregnancyDetail) _then) = __$PregnancyDetailCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'pregnancy_id') int pregnancyId,@JsonKey(name: 'lmp_date') String? lmpDate,@JsonKey(name: 'edd_date') String? eddDate, int? gravida, int? para, String status,@JsonKey(name: 'is_high_priority') bool isHighPriority,@JsonKey(name: 'has_high_bp') bool? hasHighBp,@JsonKey(name: 'has_diabetes') bool? hasDiabetes,@JsonKey(name: 'has_severe_anaemia') bool? hasSevereAnaemia,@JsonKey(name: 'anc_visits') List<AncVisitItem> ancVisits
});




}
/// @nodoc
class __$PregnancyDetailCopyWithImpl<$Res>
    implements _$PregnancyDetailCopyWith<$Res> {
  __$PregnancyDetailCopyWithImpl(this._self, this._then);

  final _PregnancyDetail _self;
  final $Res Function(_PregnancyDetail) _then;

/// Create a copy of PregnancyDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pregnancyId = null,Object? lmpDate = freezed,Object? eddDate = freezed,Object? gravida = freezed,Object? para = freezed,Object? status = null,Object? isHighPriority = null,Object? hasHighBp = freezed,Object? hasDiabetes = freezed,Object? hasSevereAnaemia = freezed,Object? ancVisits = null,}) {
  return _then(_PregnancyDetail(
pregnancyId: null == pregnancyId ? _self.pregnancyId : pregnancyId // ignore: cast_nullable_to_non_nullable
as int,lmpDate: freezed == lmpDate ? _self.lmpDate : lmpDate // ignore: cast_nullable_to_non_nullable
as String?,eddDate: freezed == eddDate ? _self.eddDate : eddDate // ignore: cast_nullable_to_non_nullable
as String?,gravida: freezed == gravida ? _self.gravida : gravida // ignore: cast_nullable_to_non_nullable
as int?,para: freezed == para ? _self.para : para // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isHighPriority: null == isHighPriority ? _self.isHighPriority : isHighPriority // ignore: cast_nullable_to_non_nullable
as bool,hasHighBp: freezed == hasHighBp ? _self.hasHighBp : hasHighBp // ignore: cast_nullable_to_non_nullable
as bool?,hasDiabetes: freezed == hasDiabetes ? _self.hasDiabetes : hasDiabetes // ignore: cast_nullable_to_non_nullable
as bool?,hasSevereAnaemia: freezed == hasSevereAnaemia ? _self.hasSevereAnaemia : hasSevereAnaemia // ignore: cast_nullable_to_non_nullable
as bool?,ancVisits: null == ancVisits ? _self._ancVisits : ancVisits // ignore: cast_nullable_to_non_nullable
as List<AncVisitItem>,
  ));
}


}


/// @nodoc
mixin _$AncVisitItem {

 int get id;@JsonKey(name: 'visit_number') int get visitNumber;@JsonKey(name: 'visit_date') String get visitDate;@JsonKey(name: 'bp_systolic') int? get bpSystolic;@JsonKey(name: 'bp_diastolic') int? get bpDiastolic;@JsonKey(name: 'weight_kg') double? get weightKg;@JsonKey(name: 'hemoglobin_g_dl') double? get hemoglobinGDl;@JsonKey(name: 'next_visit_due_date') String? get nextVisitDueDate;
/// Create a copy of AncVisitItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AncVisitItemCopyWith<AncVisitItem> get copyWith => _$AncVisitItemCopyWithImpl<AncVisitItem>(this as AncVisitItem, _$identity);

  /// Serializes this AncVisitItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AncVisitItem&&(identical(other.id, id) || other.id == id)&&(identical(other.visitNumber, visitNumber) || other.visitNumber == visitNumber)&&(identical(other.visitDate, visitDate) || other.visitDate == visitDate)&&(identical(other.bpSystolic, bpSystolic) || other.bpSystolic == bpSystolic)&&(identical(other.bpDiastolic, bpDiastolic) || other.bpDiastolic == bpDiastolic)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.hemoglobinGDl, hemoglobinGDl) || other.hemoglobinGDl == hemoglobinGDl)&&(identical(other.nextVisitDueDate, nextVisitDueDate) || other.nextVisitDueDate == nextVisitDueDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,visitNumber,visitDate,bpSystolic,bpDiastolic,weightKg,hemoglobinGDl,nextVisitDueDate);

@override
String toString() {
  return 'AncVisitItem(id: $id, visitNumber: $visitNumber, visitDate: $visitDate, bpSystolic: $bpSystolic, bpDiastolic: $bpDiastolic, weightKg: $weightKg, hemoglobinGDl: $hemoglobinGDl, nextVisitDueDate: $nextVisitDueDate)';
}


}

/// @nodoc
abstract mixin class $AncVisitItemCopyWith<$Res>  {
  factory $AncVisitItemCopyWith(AncVisitItem value, $Res Function(AncVisitItem) _then) = _$AncVisitItemCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'visit_number') int visitNumber,@JsonKey(name: 'visit_date') String visitDate,@JsonKey(name: 'bp_systolic') int? bpSystolic,@JsonKey(name: 'bp_diastolic') int? bpDiastolic,@JsonKey(name: 'weight_kg') double? weightKg,@JsonKey(name: 'hemoglobin_g_dl') double? hemoglobinGDl,@JsonKey(name: 'next_visit_due_date') String? nextVisitDueDate
});




}
/// @nodoc
class _$AncVisitItemCopyWithImpl<$Res>
    implements $AncVisitItemCopyWith<$Res> {
  _$AncVisitItemCopyWithImpl(this._self, this._then);

  final AncVisitItem _self;
  final $Res Function(AncVisitItem) _then;

/// Create a copy of AncVisitItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? visitNumber = null,Object? visitDate = null,Object? bpSystolic = freezed,Object? bpDiastolic = freezed,Object? weightKg = freezed,Object? hemoglobinGDl = freezed,Object? nextVisitDueDate = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,visitNumber: null == visitNumber ? _self.visitNumber : visitNumber // ignore: cast_nullable_to_non_nullable
as int,visitDate: null == visitDate ? _self.visitDate : visitDate // ignore: cast_nullable_to_non_nullable
as String,bpSystolic: freezed == bpSystolic ? _self.bpSystolic : bpSystolic // ignore: cast_nullable_to_non_nullable
as int?,bpDiastolic: freezed == bpDiastolic ? _self.bpDiastolic : bpDiastolic // ignore: cast_nullable_to_non_nullable
as int?,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,hemoglobinGDl: freezed == hemoglobinGDl ? _self.hemoglobinGDl : hemoglobinGDl // ignore: cast_nullable_to_non_nullable
as double?,nextVisitDueDate: freezed == nextVisitDueDate ? _self.nextVisitDueDate : nextVisitDueDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AncVisitItem].
extension AncVisitItemPatterns on AncVisitItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AncVisitItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AncVisitItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AncVisitItem value)  $default,){
final _that = this;
switch (_that) {
case _AncVisitItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AncVisitItem value)?  $default,){
final _that = this;
switch (_that) {
case _AncVisitItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'visit_number')  int visitNumber, @JsonKey(name: 'visit_date')  String visitDate, @JsonKey(name: 'bp_systolic')  int? bpSystolic, @JsonKey(name: 'bp_diastolic')  int? bpDiastolic, @JsonKey(name: 'weight_kg')  double? weightKg, @JsonKey(name: 'hemoglobin_g_dl')  double? hemoglobinGDl, @JsonKey(name: 'next_visit_due_date')  String? nextVisitDueDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AncVisitItem() when $default != null:
return $default(_that.id,_that.visitNumber,_that.visitDate,_that.bpSystolic,_that.bpDiastolic,_that.weightKg,_that.hemoglobinGDl,_that.nextVisitDueDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'visit_number')  int visitNumber, @JsonKey(name: 'visit_date')  String visitDate, @JsonKey(name: 'bp_systolic')  int? bpSystolic, @JsonKey(name: 'bp_diastolic')  int? bpDiastolic, @JsonKey(name: 'weight_kg')  double? weightKg, @JsonKey(name: 'hemoglobin_g_dl')  double? hemoglobinGDl, @JsonKey(name: 'next_visit_due_date')  String? nextVisitDueDate)  $default,) {final _that = this;
switch (_that) {
case _AncVisitItem():
return $default(_that.id,_that.visitNumber,_that.visitDate,_that.bpSystolic,_that.bpDiastolic,_that.weightKg,_that.hemoglobinGDl,_that.nextVisitDueDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'visit_number')  int visitNumber, @JsonKey(name: 'visit_date')  String visitDate, @JsonKey(name: 'bp_systolic')  int? bpSystolic, @JsonKey(name: 'bp_diastolic')  int? bpDiastolic, @JsonKey(name: 'weight_kg')  double? weightKg, @JsonKey(name: 'hemoglobin_g_dl')  double? hemoglobinGDl, @JsonKey(name: 'next_visit_due_date')  String? nextVisitDueDate)?  $default,) {final _that = this;
switch (_that) {
case _AncVisitItem() when $default != null:
return $default(_that.id,_that.visitNumber,_that.visitDate,_that.bpSystolic,_that.bpDiastolic,_that.weightKg,_that.hemoglobinGDl,_that.nextVisitDueDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AncVisitItem implements AncVisitItem {
  const _AncVisitItem({required this.id, @JsonKey(name: 'visit_number') required this.visitNumber, @JsonKey(name: 'visit_date') required this.visitDate, @JsonKey(name: 'bp_systolic') this.bpSystolic, @JsonKey(name: 'bp_diastolic') this.bpDiastolic, @JsonKey(name: 'weight_kg') this.weightKg, @JsonKey(name: 'hemoglobin_g_dl') this.hemoglobinGDl, @JsonKey(name: 'next_visit_due_date') this.nextVisitDueDate});
  factory _AncVisitItem.fromJson(Map<String, dynamic> json) => _$AncVisitItemFromJson(json);

@override final  int id;
@override@JsonKey(name: 'visit_number') final  int visitNumber;
@override@JsonKey(name: 'visit_date') final  String visitDate;
@override@JsonKey(name: 'bp_systolic') final  int? bpSystolic;
@override@JsonKey(name: 'bp_diastolic') final  int? bpDiastolic;
@override@JsonKey(name: 'weight_kg') final  double? weightKg;
@override@JsonKey(name: 'hemoglobin_g_dl') final  double? hemoglobinGDl;
@override@JsonKey(name: 'next_visit_due_date') final  String? nextVisitDueDate;

/// Create a copy of AncVisitItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AncVisitItemCopyWith<_AncVisitItem> get copyWith => __$AncVisitItemCopyWithImpl<_AncVisitItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AncVisitItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AncVisitItem&&(identical(other.id, id) || other.id == id)&&(identical(other.visitNumber, visitNumber) || other.visitNumber == visitNumber)&&(identical(other.visitDate, visitDate) || other.visitDate == visitDate)&&(identical(other.bpSystolic, bpSystolic) || other.bpSystolic == bpSystolic)&&(identical(other.bpDiastolic, bpDiastolic) || other.bpDiastolic == bpDiastolic)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.hemoglobinGDl, hemoglobinGDl) || other.hemoglobinGDl == hemoglobinGDl)&&(identical(other.nextVisitDueDate, nextVisitDueDate) || other.nextVisitDueDate == nextVisitDueDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,visitNumber,visitDate,bpSystolic,bpDiastolic,weightKg,hemoglobinGDl,nextVisitDueDate);

@override
String toString() {
  return 'AncVisitItem(id: $id, visitNumber: $visitNumber, visitDate: $visitDate, bpSystolic: $bpSystolic, bpDiastolic: $bpDiastolic, weightKg: $weightKg, hemoglobinGDl: $hemoglobinGDl, nextVisitDueDate: $nextVisitDueDate)';
}


}

/// @nodoc
abstract mixin class _$AncVisitItemCopyWith<$Res> implements $AncVisitItemCopyWith<$Res> {
  factory _$AncVisitItemCopyWith(_AncVisitItem value, $Res Function(_AncVisitItem) _then) = __$AncVisitItemCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'visit_number') int visitNumber,@JsonKey(name: 'visit_date') String visitDate,@JsonKey(name: 'bp_systolic') int? bpSystolic,@JsonKey(name: 'bp_diastolic') int? bpDiastolic,@JsonKey(name: 'weight_kg') double? weightKg,@JsonKey(name: 'hemoglobin_g_dl') double? hemoglobinGDl,@JsonKey(name: 'next_visit_due_date') String? nextVisitDueDate
});




}
/// @nodoc
class __$AncVisitItemCopyWithImpl<$Res>
    implements _$AncVisitItemCopyWith<$Res> {
  __$AncVisitItemCopyWithImpl(this._self, this._then);

  final _AncVisitItem _self;
  final $Res Function(_AncVisitItem) _then;

/// Create a copy of AncVisitItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? visitNumber = null,Object? visitDate = null,Object? bpSystolic = freezed,Object? bpDiastolic = freezed,Object? weightKg = freezed,Object? hemoglobinGDl = freezed,Object? nextVisitDueDate = freezed,}) {
  return _then(_AncVisitItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,visitNumber: null == visitNumber ? _self.visitNumber : visitNumber // ignore: cast_nullable_to_non_nullable
as int,visitDate: null == visitDate ? _self.visitDate : visitDate // ignore: cast_nullable_to_non_nullable
as String,bpSystolic: freezed == bpSystolic ? _self.bpSystolic : bpSystolic // ignore: cast_nullable_to_non_nullable
as int?,bpDiastolic: freezed == bpDiastolic ? _self.bpDiastolic : bpDiastolic // ignore: cast_nullable_to_non_nullable
as int?,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,hemoglobinGDl: freezed == hemoglobinGDl ? _self.hemoglobinGDl : hemoglobinGDl // ignore: cast_nullable_to_non_nullable
as double?,nextVisitDueDate: freezed == nextVisitDueDate ? _self.nextVisitDueDate : nextVisitDueDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
