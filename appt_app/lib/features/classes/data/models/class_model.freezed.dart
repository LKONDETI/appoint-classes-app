// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'class_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProviderModel {

 String get id; String get name; String? get avatarUrl; String? get specialty;
/// Create a copy of ProviderModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProviderModelCopyWith<ProviderModel> get copyWith => _$ProviderModelCopyWithImpl<ProviderModel>(this as ProviderModel, _$identity);

  /// Serializes this ProviderModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProviderModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.specialty, specialty) || other.specialty == specialty));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,avatarUrl,specialty);

@override
String toString() {
  return 'ProviderModel(id: $id, name: $name, avatarUrl: $avatarUrl, specialty: $specialty)';
}


}

/// @nodoc
abstract mixin class $ProviderModelCopyWith<$Res>  {
  factory $ProviderModelCopyWith(ProviderModel value, $Res Function(ProviderModel) _then) = _$ProviderModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? avatarUrl, String? specialty
});




}
/// @nodoc
class _$ProviderModelCopyWithImpl<$Res>
    implements $ProviderModelCopyWith<$Res> {
  _$ProviderModelCopyWithImpl(this._self, this._then);

  final ProviderModel _self;
  final $Res Function(ProviderModel) _then;

/// Create a copy of ProviderModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? avatarUrl = freezed,Object? specialty = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,specialty: freezed == specialty ? _self.specialty : specialty // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProviderModel].
extension ProviderModelPatterns on ProviderModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProviderModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProviderModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProviderModel value)  $default,){
final _that = this;
switch (_that) {
case _ProviderModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProviderModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProviderModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? avatarUrl,  String? specialty)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProviderModel() when $default != null:
return $default(_that.id,_that.name,_that.avatarUrl,_that.specialty);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? avatarUrl,  String? specialty)  $default,) {final _that = this;
switch (_that) {
case _ProviderModel():
return $default(_that.id,_that.name,_that.avatarUrl,_that.specialty);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? avatarUrl,  String? specialty)?  $default,) {final _that = this;
switch (_that) {
case _ProviderModel() when $default != null:
return $default(_that.id,_that.name,_that.avatarUrl,_that.specialty);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProviderModel implements ProviderModel {
  const _ProviderModel({required this.id, required this.name, this.avatarUrl, this.specialty});
  factory _ProviderModel.fromJson(Map<String, dynamic> json) => _$ProviderModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? avatarUrl;
@override final  String? specialty;

/// Create a copy of ProviderModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProviderModelCopyWith<_ProviderModel> get copyWith => __$ProviderModelCopyWithImpl<_ProviderModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProviderModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProviderModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.specialty, specialty) || other.specialty == specialty));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,avatarUrl,specialty);

@override
String toString() {
  return 'ProviderModel(id: $id, name: $name, avatarUrl: $avatarUrl, specialty: $specialty)';
}


}

/// @nodoc
abstract mixin class _$ProviderModelCopyWith<$Res> implements $ProviderModelCopyWith<$Res> {
  factory _$ProviderModelCopyWith(_ProviderModel value, $Res Function(_ProviderModel) _then) = __$ProviderModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? avatarUrl, String? specialty
});




}
/// @nodoc
class __$ProviderModelCopyWithImpl<$Res>
    implements _$ProviderModelCopyWith<$Res> {
  __$ProviderModelCopyWithImpl(this._self, this._then);

  final _ProviderModel _self;
  final $Res Function(_ProviderModel) _then;

/// Create a copy of ProviderModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? avatarUrl = freezed,Object? specialty = freezed,}) {
  return _then(_ProviderModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,specialty: freezed == specialty ? _self.specialty : specialty // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ClassModel {

 String get id; String get title; ProviderModel get provider; DateTime get scheduledAt; int get durationMinutes; int get maxCapacity; int get bookedCount; String? get description;
/// Create a copy of ClassModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClassModelCopyWith<ClassModel> get copyWith => _$ClassModelCopyWithImpl<ClassModel>(this as ClassModel, _$identity);

  /// Serializes this ClassModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClassModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.maxCapacity, maxCapacity) || other.maxCapacity == maxCapacity)&&(identical(other.bookedCount, bookedCount) || other.bookedCount == bookedCount)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,provider,scheduledAt,durationMinutes,maxCapacity,bookedCount,description);

@override
String toString() {
  return 'ClassModel(id: $id, title: $title, provider: $provider, scheduledAt: $scheduledAt, durationMinutes: $durationMinutes, maxCapacity: $maxCapacity, bookedCount: $bookedCount, description: $description)';
}


}

/// @nodoc
abstract mixin class $ClassModelCopyWith<$Res>  {
  factory $ClassModelCopyWith(ClassModel value, $Res Function(ClassModel) _then) = _$ClassModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, ProviderModel provider, DateTime scheduledAt, int durationMinutes, int maxCapacity, int bookedCount, String? description
});


$ProviderModelCopyWith<$Res> get provider;

}
/// @nodoc
class _$ClassModelCopyWithImpl<$Res>
    implements $ClassModelCopyWith<$Res> {
  _$ClassModelCopyWithImpl(this._self, this._then);

  final ClassModel _self;
  final $Res Function(ClassModel) _then;

/// Create a copy of ClassModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? provider = null,Object? scheduledAt = null,Object? durationMinutes = null,Object? maxCapacity = null,Object? bookedCount = null,Object? description = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as ProviderModel,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,maxCapacity: null == maxCapacity ? _self.maxCapacity : maxCapacity // ignore: cast_nullable_to_non_nullable
as int,bookedCount: null == bookedCount ? _self.bookedCount : bookedCount // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ClassModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProviderModelCopyWith<$Res> get provider {
  
  return $ProviderModelCopyWith<$Res>(_self.provider, (value) {
    return _then(_self.copyWith(provider: value));
  });
}
}


/// Adds pattern-matching-related methods to [ClassModel].
extension ClassModelPatterns on ClassModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClassModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClassModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClassModel value)  $default,){
final _that = this;
switch (_that) {
case _ClassModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClassModel value)?  $default,){
final _that = this;
switch (_that) {
case _ClassModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  ProviderModel provider,  DateTime scheduledAt,  int durationMinutes,  int maxCapacity,  int bookedCount,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClassModel() when $default != null:
return $default(_that.id,_that.title,_that.provider,_that.scheduledAt,_that.durationMinutes,_that.maxCapacity,_that.bookedCount,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  ProviderModel provider,  DateTime scheduledAt,  int durationMinutes,  int maxCapacity,  int bookedCount,  String? description)  $default,) {final _that = this;
switch (_that) {
case _ClassModel():
return $default(_that.id,_that.title,_that.provider,_that.scheduledAt,_that.durationMinutes,_that.maxCapacity,_that.bookedCount,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  ProviderModel provider,  DateTime scheduledAt,  int durationMinutes,  int maxCapacity,  int bookedCount,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _ClassModel() when $default != null:
return $default(_that.id,_that.title,_that.provider,_that.scheduledAt,_that.durationMinutes,_that.maxCapacity,_that.bookedCount,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClassModel implements ClassModel {
  const _ClassModel({required this.id, required this.title, required this.provider, required this.scheduledAt, required this.durationMinutes, required this.maxCapacity, required this.bookedCount, this.description});
  factory _ClassModel.fromJson(Map<String, dynamic> json) => _$ClassModelFromJson(json);

@override final  String id;
@override final  String title;
@override final  ProviderModel provider;
@override final  DateTime scheduledAt;
@override final  int durationMinutes;
@override final  int maxCapacity;
@override final  int bookedCount;
@override final  String? description;

/// Create a copy of ClassModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClassModelCopyWith<_ClassModel> get copyWith => __$ClassModelCopyWithImpl<_ClassModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClassModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClassModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.maxCapacity, maxCapacity) || other.maxCapacity == maxCapacity)&&(identical(other.bookedCount, bookedCount) || other.bookedCount == bookedCount)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,provider,scheduledAt,durationMinutes,maxCapacity,bookedCount,description);

@override
String toString() {
  return 'ClassModel(id: $id, title: $title, provider: $provider, scheduledAt: $scheduledAt, durationMinutes: $durationMinutes, maxCapacity: $maxCapacity, bookedCount: $bookedCount, description: $description)';
}


}

/// @nodoc
abstract mixin class _$ClassModelCopyWith<$Res> implements $ClassModelCopyWith<$Res> {
  factory _$ClassModelCopyWith(_ClassModel value, $Res Function(_ClassModel) _then) = __$ClassModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, ProviderModel provider, DateTime scheduledAt, int durationMinutes, int maxCapacity, int bookedCount, String? description
});


@override $ProviderModelCopyWith<$Res> get provider;

}
/// @nodoc
class __$ClassModelCopyWithImpl<$Res>
    implements _$ClassModelCopyWith<$Res> {
  __$ClassModelCopyWithImpl(this._self, this._then);

  final _ClassModel _self;
  final $Res Function(_ClassModel) _then;

/// Create a copy of ClassModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? provider = null,Object? scheduledAt = null,Object? durationMinutes = null,Object? maxCapacity = null,Object? bookedCount = null,Object? description = freezed,}) {
  return _then(_ClassModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as ProviderModel,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,maxCapacity: null == maxCapacity ? _self.maxCapacity : maxCapacity // ignore: cast_nullable_to_non_nullable
as int,bookedCount: null == bookedCount ? _self.bookedCount : bookedCount // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ClassModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProviderModelCopyWith<$Res> get provider {
  
  return $ProviderModelCopyWith<$Res>(_self.provider, (value) {
    return _then(_self.copyWith(provider: value));
  });
}
}

// dart format on
