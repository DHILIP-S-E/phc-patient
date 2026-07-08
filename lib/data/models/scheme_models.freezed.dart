// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scheme_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SchemeItem {

 String get key; String get name; String get description; List<String> get benefits;@JsonKey(name: 'required_documents') List<String> get requiredDocuments; String get category;
/// Create a copy of SchemeItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SchemeItemCopyWith<SchemeItem> get copyWith => _$SchemeItemCopyWithImpl<SchemeItem>(this as SchemeItem, _$identity);

  /// Serializes this SchemeItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SchemeItem&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.benefits, benefits)&&const DeepCollectionEquality().equals(other.requiredDocuments, requiredDocuments)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,name,description,const DeepCollectionEquality().hash(benefits),const DeepCollectionEquality().hash(requiredDocuments),category);

@override
String toString() {
  return 'SchemeItem(key: $key, name: $name, description: $description, benefits: $benefits, requiredDocuments: $requiredDocuments, category: $category)';
}


}

/// @nodoc
abstract mixin class $SchemeItemCopyWith<$Res>  {
  factory $SchemeItemCopyWith(SchemeItem value, $Res Function(SchemeItem) _then) = _$SchemeItemCopyWithImpl;
@useResult
$Res call({
 String key, String name, String description, List<String> benefits,@JsonKey(name: 'required_documents') List<String> requiredDocuments, String category
});




}
/// @nodoc
class _$SchemeItemCopyWithImpl<$Res>
    implements $SchemeItemCopyWith<$Res> {
  _$SchemeItemCopyWithImpl(this._self, this._then);

  final SchemeItem _self;
  final $Res Function(SchemeItem) _then;

/// Create a copy of SchemeItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? name = null,Object? description = null,Object? benefits = null,Object? requiredDocuments = null,Object? category = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,benefits: null == benefits ? _self.benefits : benefits // ignore: cast_nullable_to_non_nullable
as List<String>,requiredDocuments: null == requiredDocuments ? _self.requiredDocuments : requiredDocuments // ignore: cast_nullable_to_non_nullable
as List<String>,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SchemeItem].
extension SchemeItemPatterns on SchemeItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SchemeItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SchemeItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SchemeItem value)  $default,){
final _that = this;
switch (_that) {
case _SchemeItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SchemeItem value)?  $default,){
final _that = this;
switch (_that) {
case _SchemeItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String name,  String description,  List<String> benefits, @JsonKey(name: 'required_documents')  List<String> requiredDocuments,  String category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SchemeItem() when $default != null:
return $default(_that.key,_that.name,_that.description,_that.benefits,_that.requiredDocuments,_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String name,  String description,  List<String> benefits, @JsonKey(name: 'required_documents')  List<String> requiredDocuments,  String category)  $default,) {final _that = this;
switch (_that) {
case _SchemeItem():
return $default(_that.key,_that.name,_that.description,_that.benefits,_that.requiredDocuments,_that.category);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String name,  String description,  List<String> benefits, @JsonKey(name: 'required_documents')  List<String> requiredDocuments,  String category)?  $default,) {final _that = this;
switch (_that) {
case _SchemeItem() when $default != null:
return $default(_that.key,_that.name,_that.description,_that.benefits,_that.requiredDocuments,_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SchemeItem implements SchemeItem {
  const _SchemeItem({required this.key, required this.name, required this.description, required final  List<String> benefits, @JsonKey(name: 'required_documents') required final  List<String> requiredDocuments, required this.category}): _benefits = benefits,_requiredDocuments = requiredDocuments;
  factory _SchemeItem.fromJson(Map<String, dynamic> json) => _$SchemeItemFromJson(json);

@override final  String key;
@override final  String name;
@override final  String description;
 final  List<String> _benefits;
@override List<String> get benefits {
  if (_benefits is EqualUnmodifiableListView) return _benefits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_benefits);
}

 final  List<String> _requiredDocuments;
@override@JsonKey(name: 'required_documents') List<String> get requiredDocuments {
  if (_requiredDocuments is EqualUnmodifiableListView) return _requiredDocuments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_requiredDocuments);
}

@override final  String category;

/// Create a copy of SchemeItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SchemeItemCopyWith<_SchemeItem> get copyWith => __$SchemeItemCopyWithImpl<_SchemeItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SchemeItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SchemeItem&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._benefits, _benefits)&&const DeepCollectionEquality().equals(other._requiredDocuments, _requiredDocuments)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,name,description,const DeepCollectionEquality().hash(_benefits),const DeepCollectionEquality().hash(_requiredDocuments),category);

@override
String toString() {
  return 'SchemeItem(key: $key, name: $name, description: $description, benefits: $benefits, requiredDocuments: $requiredDocuments, category: $category)';
}


}

/// @nodoc
abstract mixin class _$SchemeItemCopyWith<$Res> implements $SchemeItemCopyWith<$Res> {
  factory _$SchemeItemCopyWith(_SchemeItem value, $Res Function(_SchemeItem) _then) = __$SchemeItemCopyWithImpl;
@override @useResult
$Res call({
 String key, String name, String description, List<String> benefits,@JsonKey(name: 'required_documents') List<String> requiredDocuments, String category
});




}
/// @nodoc
class __$SchemeItemCopyWithImpl<$Res>
    implements _$SchemeItemCopyWith<$Res> {
  __$SchemeItemCopyWithImpl(this._self, this._then);

  final _SchemeItem _self;
  final $Res Function(_SchemeItem) _then;

/// Create a copy of SchemeItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? name = null,Object? description = null,Object? benefits = null,Object? requiredDocuments = null,Object? category = null,}) {
  return _then(_SchemeItem(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,benefits: null == benefits ? _self._benefits : benefits // ignore: cast_nullable_to_non_nullable
as List<String>,requiredDocuments: null == requiredDocuments ? _self._requiredDocuments : requiredDocuments // ignore: cast_nullable_to_non_nullable
as List<String>,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
