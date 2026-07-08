// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'patient_auth_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PatientCandidate {

 int get id; String get name; String? get dob;
/// Create a copy of PatientCandidate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PatientCandidateCopyWith<PatientCandidate> get copyWith => _$PatientCandidateCopyWithImpl<PatientCandidate>(this as PatientCandidate, _$identity);

  /// Serializes this PatientCandidate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PatientCandidate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.dob, dob) || other.dob == dob));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,dob);

@override
String toString() {
  return 'PatientCandidate(id: $id, name: $name, dob: $dob)';
}


}

/// @nodoc
abstract mixin class $PatientCandidateCopyWith<$Res>  {
  factory $PatientCandidateCopyWith(PatientCandidate value, $Res Function(PatientCandidate) _then) = _$PatientCandidateCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? dob
});




}
/// @nodoc
class _$PatientCandidateCopyWithImpl<$Res>
    implements $PatientCandidateCopyWith<$Res> {
  _$PatientCandidateCopyWithImpl(this._self, this._then);

  final PatientCandidate _self;
  final $Res Function(PatientCandidate) _then;

/// Create a copy of PatientCandidate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? dob = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dob: freezed == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PatientCandidate].
extension PatientCandidatePatterns on PatientCandidate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PatientCandidate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PatientCandidate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PatientCandidate value)  $default,){
final _that = this;
switch (_that) {
case _PatientCandidate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PatientCandidate value)?  $default,){
final _that = this;
switch (_that) {
case _PatientCandidate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? dob)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PatientCandidate() when $default != null:
return $default(_that.id,_that.name,_that.dob);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? dob)  $default,) {final _that = this;
switch (_that) {
case _PatientCandidate():
return $default(_that.id,_that.name,_that.dob);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? dob)?  $default,) {final _that = this;
switch (_that) {
case _PatientCandidate() when $default != null:
return $default(_that.id,_that.name,_that.dob);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PatientCandidate implements PatientCandidate {
  const _PatientCandidate({required this.id, required this.name, this.dob});
  factory _PatientCandidate.fromJson(Map<String, dynamic> json) => _$PatientCandidateFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? dob;

/// Create a copy of PatientCandidate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PatientCandidateCopyWith<_PatientCandidate> get copyWith => __$PatientCandidateCopyWithImpl<_PatientCandidate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PatientCandidateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PatientCandidate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.dob, dob) || other.dob == dob));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,dob);

@override
String toString() {
  return 'PatientCandidate(id: $id, name: $name, dob: $dob)';
}


}

/// @nodoc
abstract mixin class _$PatientCandidateCopyWith<$Res> implements $PatientCandidateCopyWith<$Res> {
  factory _$PatientCandidateCopyWith(_PatientCandidate value, $Res Function(_PatientCandidate) _then) = __$PatientCandidateCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? dob
});




}
/// @nodoc
class __$PatientCandidateCopyWithImpl<$Res>
    implements _$PatientCandidateCopyWith<$Res> {
  __$PatientCandidateCopyWithImpl(this._self, this._then);

  final _PatientCandidate _self;
  final $Res Function(_PatientCandidate) _then;

/// Create a copy of PatientCandidate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? dob = freezed,}) {
  return _then(_PatientCandidate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dob: freezed == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$VerifyOtpResult {

 String get status;@JsonKey(name: 'access_token') String? get accessToken;@JsonKey(name: 'verified_phone_token') String? get verifiedPhoneToken; List<PatientCandidate> get candidates;
/// Create a copy of VerifyOtpResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerifyOtpResultCopyWith<VerifyOtpResult> get copyWith => _$VerifyOtpResultCopyWithImpl<VerifyOtpResult>(this as VerifyOtpResult, _$identity);

  /// Serializes this VerifyOtpResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerifyOtpResult&&(identical(other.status, status) || other.status == status)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.verifiedPhoneToken, verifiedPhoneToken) || other.verifiedPhoneToken == verifiedPhoneToken)&&const DeepCollectionEquality().equals(other.candidates, candidates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,accessToken,verifiedPhoneToken,const DeepCollectionEquality().hash(candidates));

@override
String toString() {
  return 'VerifyOtpResult(status: $status, accessToken: $accessToken, verifiedPhoneToken: $verifiedPhoneToken, candidates: $candidates)';
}


}

/// @nodoc
abstract mixin class $VerifyOtpResultCopyWith<$Res>  {
  factory $VerifyOtpResultCopyWith(VerifyOtpResult value, $Res Function(VerifyOtpResult) _then) = _$VerifyOtpResultCopyWithImpl;
@useResult
$Res call({
 String status,@JsonKey(name: 'access_token') String? accessToken,@JsonKey(name: 'verified_phone_token') String? verifiedPhoneToken, List<PatientCandidate> candidates
});




}
/// @nodoc
class _$VerifyOtpResultCopyWithImpl<$Res>
    implements $VerifyOtpResultCopyWith<$Res> {
  _$VerifyOtpResultCopyWithImpl(this._self, this._then);

  final VerifyOtpResult _self;
  final $Res Function(VerifyOtpResult) _then;

/// Create a copy of VerifyOtpResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? accessToken = freezed,Object? verifiedPhoneToken = freezed,Object? candidates = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,accessToken: freezed == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String?,verifiedPhoneToken: freezed == verifiedPhoneToken ? _self.verifiedPhoneToken : verifiedPhoneToken // ignore: cast_nullable_to_non_nullable
as String?,candidates: null == candidates ? _self.candidates : candidates // ignore: cast_nullable_to_non_nullable
as List<PatientCandidate>,
  ));
}

}


/// Adds pattern-matching-related methods to [VerifyOtpResult].
extension VerifyOtpResultPatterns on VerifyOtpResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VerifyOtpResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VerifyOtpResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VerifyOtpResult value)  $default,){
final _that = this;
switch (_that) {
case _VerifyOtpResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VerifyOtpResult value)?  $default,){
final _that = this;
switch (_that) {
case _VerifyOtpResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status, @JsonKey(name: 'access_token')  String? accessToken, @JsonKey(name: 'verified_phone_token')  String? verifiedPhoneToken,  List<PatientCandidate> candidates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VerifyOtpResult() when $default != null:
return $default(_that.status,_that.accessToken,_that.verifiedPhoneToken,_that.candidates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status, @JsonKey(name: 'access_token')  String? accessToken, @JsonKey(name: 'verified_phone_token')  String? verifiedPhoneToken,  List<PatientCandidate> candidates)  $default,) {final _that = this;
switch (_that) {
case _VerifyOtpResult():
return $default(_that.status,_that.accessToken,_that.verifiedPhoneToken,_that.candidates);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status, @JsonKey(name: 'access_token')  String? accessToken, @JsonKey(name: 'verified_phone_token')  String? verifiedPhoneToken,  List<PatientCandidate> candidates)?  $default,) {final _that = this;
switch (_that) {
case _VerifyOtpResult() when $default != null:
return $default(_that.status,_that.accessToken,_that.verifiedPhoneToken,_that.candidates);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VerifyOtpResult implements VerifyOtpResult {
  const _VerifyOtpResult({required this.status, @JsonKey(name: 'access_token') this.accessToken, @JsonKey(name: 'verified_phone_token') this.verifiedPhoneToken, final  List<PatientCandidate> candidates = const <PatientCandidate>[]}): _candidates = candidates;
  factory _VerifyOtpResult.fromJson(Map<String, dynamic> json) => _$VerifyOtpResultFromJson(json);

@override final  String status;
@override@JsonKey(name: 'access_token') final  String? accessToken;
@override@JsonKey(name: 'verified_phone_token') final  String? verifiedPhoneToken;
 final  List<PatientCandidate> _candidates;
@override@JsonKey() List<PatientCandidate> get candidates {
  if (_candidates is EqualUnmodifiableListView) return _candidates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_candidates);
}


/// Create a copy of VerifyOtpResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerifyOtpResultCopyWith<_VerifyOtpResult> get copyWith => __$VerifyOtpResultCopyWithImpl<_VerifyOtpResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VerifyOtpResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerifyOtpResult&&(identical(other.status, status) || other.status == status)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.verifiedPhoneToken, verifiedPhoneToken) || other.verifiedPhoneToken == verifiedPhoneToken)&&const DeepCollectionEquality().equals(other._candidates, _candidates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,accessToken,verifiedPhoneToken,const DeepCollectionEquality().hash(_candidates));

@override
String toString() {
  return 'VerifyOtpResult(status: $status, accessToken: $accessToken, verifiedPhoneToken: $verifiedPhoneToken, candidates: $candidates)';
}


}

/// @nodoc
abstract mixin class _$VerifyOtpResultCopyWith<$Res> implements $VerifyOtpResultCopyWith<$Res> {
  factory _$VerifyOtpResultCopyWith(_VerifyOtpResult value, $Res Function(_VerifyOtpResult) _then) = __$VerifyOtpResultCopyWithImpl;
@override @useResult
$Res call({
 String status,@JsonKey(name: 'access_token') String? accessToken,@JsonKey(name: 'verified_phone_token') String? verifiedPhoneToken, List<PatientCandidate> candidates
});




}
/// @nodoc
class __$VerifyOtpResultCopyWithImpl<$Res>
    implements _$VerifyOtpResultCopyWith<$Res> {
  __$VerifyOtpResultCopyWithImpl(this._self, this._then);

  final _VerifyOtpResult _self;
  final $Res Function(_VerifyOtpResult) _then;

/// Create a copy of VerifyOtpResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? accessToken = freezed,Object? verifiedPhoneToken = freezed,Object? candidates = null,}) {
  return _then(_VerifyOtpResult(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,accessToken: freezed == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String?,verifiedPhoneToken: freezed == verifiedPhoneToken ? _self.verifiedPhoneToken : verifiedPhoneToken // ignore: cast_nullable_to_non_nullable
as String?,candidates: null == candidates ? _self._candidates : candidates // ignore: cast_nullable_to_non_nullable
as List<PatientCandidate>,
  ));
}


}


/// @nodoc
mixin _$AuthTokenResult {

@JsonKey(name: 'access_token') String get accessToken;@JsonKey(name: 'token_type') String get tokenType;@JsonKey(name: 'patient_id') int get patientId;
/// Create a copy of AuthTokenResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthTokenResultCopyWith<AuthTokenResult> get copyWith => _$AuthTokenResultCopyWithImpl<AuthTokenResult>(this as AuthTokenResult, _$identity);

  /// Serializes this AuthTokenResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthTokenResult&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.tokenType, tokenType) || other.tokenType == tokenType)&&(identical(other.patientId, patientId) || other.patientId == patientId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,tokenType,patientId);

@override
String toString() {
  return 'AuthTokenResult(accessToken: $accessToken, tokenType: $tokenType, patientId: $patientId)';
}


}

/// @nodoc
abstract mixin class $AuthTokenResultCopyWith<$Res>  {
  factory $AuthTokenResultCopyWith(AuthTokenResult value, $Res Function(AuthTokenResult) _then) = _$AuthTokenResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'access_token') String accessToken,@JsonKey(name: 'token_type') String tokenType,@JsonKey(name: 'patient_id') int patientId
});




}
/// @nodoc
class _$AuthTokenResultCopyWithImpl<$Res>
    implements $AuthTokenResultCopyWith<$Res> {
  _$AuthTokenResultCopyWithImpl(this._self, this._then);

  final AuthTokenResult _self;
  final $Res Function(AuthTokenResult) _then;

/// Create a copy of AuthTokenResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = null,Object? tokenType = null,Object? patientId = null,}) {
  return _then(_self.copyWith(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,tokenType: null == tokenType ? _self.tokenType : tokenType // ignore: cast_nullable_to_non_nullable
as String,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthTokenResult].
extension AuthTokenResultPatterns on AuthTokenResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthTokenResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthTokenResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthTokenResult value)  $default,){
final _that = this;
switch (_that) {
case _AuthTokenResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthTokenResult value)?  $default,){
final _that = this;
switch (_that) {
case _AuthTokenResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'access_token')  String accessToken, @JsonKey(name: 'token_type')  String tokenType, @JsonKey(name: 'patient_id')  int patientId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthTokenResult() when $default != null:
return $default(_that.accessToken,_that.tokenType,_that.patientId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'access_token')  String accessToken, @JsonKey(name: 'token_type')  String tokenType, @JsonKey(name: 'patient_id')  int patientId)  $default,) {final _that = this;
switch (_that) {
case _AuthTokenResult():
return $default(_that.accessToken,_that.tokenType,_that.patientId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'access_token')  String accessToken, @JsonKey(name: 'token_type')  String tokenType, @JsonKey(name: 'patient_id')  int patientId)?  $default,) {final _that = this;
switch (_that) {
case _AuthTokenResult() when $default != null:
return $default(_that.accessToken,_that.tokenType,_that.patientId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthTokenResult implements AuthTokenResult {
  const _AuthTokenResult({@JsonKey(name: 'access_token') required this.accessToken, @JsonKey(name: 'token_type') this.tokenType = 'bearer', @JsonKey(name: 'patient_id') required this.patientId});
  factory _AuthTokenResult.fromJson(Map<String, dynamic> json) => _$AuthTokenResultFromJson(json);

@override@JsonKey(name: 'access_token') final  String accessToken;
@override@JsonKey(name: 'token_type') final  String tokenType;
@override@JsonKey(name: 'patient_id') final  int patientId;

/// Create a copy of AuthTokenResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthTokenResultCopyWith<_AuthTokenResult> get copyWith => __$AuthTokenResultCopyWithImpl<_AuthTokenResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthTokenResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthTokenResult&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.tokenType, tokenType) || other.tokenType == tokenType)&&(identical(other.patientId, patientId) || other.patientId == patientId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,tokenType,patientId);

@override
String toString() {
  return 'AuthTokenResult(accessToken: $accessToken, tokenType: $tokenType, patientId: $patientId)';
}


}

/// @nodoc
abstract mixin class _$AuthTokenResultCopyWith<$Res> implements $AuthTokenResultCopyWith<$Res> {
  factory _$AuthTokenResultCopyWith(_AuthTokenResult value, $Res Function(_AuthTokenResult) _then) = __$AuthTokenResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'access_token') String accessToken,@JsonKey(name: 'token_type') String tokenType,@JsonKey(name: 'patient_id') int patientId
});




}
/// @nodoc
class __$AuthTokenResultCopyWithImpl<$Res>
    implements _$AuthTokenResultCopyWith<$Res> {
  __$AuthTokenResultCopyWithImpl(this._self, this._then);

  final _AuthTokenResult _self;
  final $Res Function(_AuthTokenResult) _then;

/// Create a copy of AuthTokenResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? tokenType = null,Object? patientId = null,}) {
  return _then(_AuthTokenResult(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,tokenType: null == tokenType ? _self.tokenType : tokenType // ignore: cast_nullable_to_non_nullable
as String,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
