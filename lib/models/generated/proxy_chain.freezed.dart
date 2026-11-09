// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../proxy_chain.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProxyChain {

 String get id; String get name; List<String> get hops; bool get enabled; bool get hidden; String? get targetGroup; List<String> get targetGroups;
/// Create a copy of ProxyChain
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProxyChainCopyWith<ProxyChain> get copyWith => _$ProxyChainCopyWithImpl<ProxyChain>(this as ProxyChain, _$identity);

  /// Serializes this ProxyChain to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProxyChain;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProxyChain&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.hops, _this.hops)&&(identical(other.enabled, _this.enabled) || other.enabled == _this.enabled)&&(identical(other.hidden, _this.hidden) || other.hidden == _this.hidden)&&(identical(other.targetGroup, _this.targetGroup) || other.targetGroup == _this.targetGroup)&&const DeepCollectionEquality().equals(other.targetGroups, _this.targetGroups));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProxyChain;
  return Object.hash(runtimeType,_this.id,_this.name,const DeepCollectionEquality().hash(_this.hops),_this.enabled,_this.hidden,_this.targetGroup,const DeepCollectionEquality().hash(_this.targetGroups));
}

@override
String toString() {
  final _this = this as ProxyChain;
  return 'ProxyChain(id: ${_this.id}, name: ${_this.name}, hops: ${_this.hops}, enabled: ${_this.enabled}, hidden: ${_this.hidden}, targetGroup: ${_this.targetGroup}, targetGroups: ${_this.targetGroups})';
}


}

/// @nodoc
abstract mixin class $ProxyChainCopyWith<$Res>  {
  factory $ProxyChainCopyWith(ProxyChain value, $Res Function(ProxyChain) _then) = _$ProxyChainCopyWithImpl;
@useResult
$Res call({
 String id, String name, List<String> hops, bool enabled, bool hidden, String? targetGroup, List<String> targetGroups
});




}
/// @nodoc
class _$ProxyChainCopyWithImpl<$Res>
    implements $ProxyChainCopyWith<$Res> {
  _$ProxyChainCopyWithImpl(this._self, this._then);

  final ProxyChain _self;
  final $Res Function(ProxyChain) _then;

/// Create a copy of ProxyChain
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? hops = null,Object? enabled = null,Object? hidden = null,Object? targetGroup = freezed,Object? targetGroups = null,}) {
  return _then(ProxyChain(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,hops: null == hops ? _self.hops : hops // ignore: cast_nullable_to_non_nullable
as List<String>,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,hidden: null == hidden ? _self.hidden : hidden // ignore: cast_nullable_to_non_nullable
as bool,targetGroup: freezed == targetGroup ? _self.targetGroup : targetGroup // ignore: cast_nullable_to_non_nullable
as String?,targetGroups: null == targetGroups ? _self.targetGroups : targetGroups // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProxyChain].
extension ProxyChainPatterns on ProxyChain {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProxyChain value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProxyChain() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProxyChain value)  $default,){
final _that = this;
switch (_that) {
case _ProxyChain():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProxyChain value)?  $default,){
final _that = this;
switch (_that) {
case _ProxyChain() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  List<String> hops,  bool enabled,  bool hidden,  String? targetGroup,  List<String> targetGroups)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProxyChain() when $default != null:
return $default(_that.id,_that.name,_that.hops,_that.enabled,_that.hidden,_that.targetGroup,_that.targetGroups);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  List<String> hops,  bool enabled,  bool hidden,  String? targetGroup,  List<String> targetGroups)  $default,) {final _that = this;
switch (_that) {
case _ProxyChain():
return $default(_that.id,_that.name,_that.hops,_that.enabled,_that.hidden,_that.targetGroup,_that.targetGroups);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  List<String> hops,  bool enabled,  bool hidden,  String? targetGroup,  List<String> targetGroups)?  $default,) {final _that = this;
switch (_that) {
case _ProxyChain() when $default != null:
return $default(_that.id,_that.name,_that.hops,_that.enabled,_that.hidden,_that.targetGroup,_that.targetGroups);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProxyChain implements ProxyChain {
  const _ProxyChain({required this.id, required this.name,  List<String> hops = const [], this.enabled = true, this.hidden = false, this.targetGroup,  List<String> targetGroups = const []}): _hops = hops,_targetGroups = targetGroups;
  factory _ProxyChain.fromJson(Map<String, dynamic> json) => _$ProxyChainFromJson(json);

@override final  String id;
@override final  String name;
 final  List<String> _hops;
@override@JsonKey() List<String> get hops {
  if (_hops is EqualUnmodifiableListView) return _hops;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hops);
}

@override@JsonKey() final  bool enabled;
@override@JsonKey() final  bool hidden;
@override final  String? targetGroup;
 final  List<String> _targetGroups;
@override@JsonKey() List<String> get targetGroups {
  if (_targetGroups is EqualUnmodifiableListView) return _targetGroups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_targetGroups);
}


/// Create a copy of ProxyChain
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProxyChainCopyWith<_ProxyChain> get copyWith => __$ProxyChainCopyWithImpl<_ProxyChain>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProxyChainToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProxyChain&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.hops, _hops)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.hidden, hidden) || other.hidden == hidden)&&(identical(other.targetGroup, targetGroup) || other.targetGroup == targetGroup)&&const DeepCollectionEquality().equals(other.targetGroups, _targetGroups));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_hops),enabled,hidden,targetGroup,const DeepCollectionEquality().hash(_targetGroups));
}

@override
String toString() {
    return 'ProxyChain(id: $id, name: $name, hops: $hops, enabled: $enabled, hidden: $hidden, targetGroup: $targetGroup, targetGroups: $targetGroups)';
}


}

/// @nodoc
abstract mixin class _$ProxyChainCopyWith<$Res> implements $ProxyChainCopyWith<$Res> {
  factory _$ProxyChainCopyWith(_ProxyChain value, $Res Function(_ProxyChain) _then) = __$ProxyChainCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, List<String> hops, bool enabled, bool hidden, String? targetGroup, List<String> targetGroups
});




}
/// @nodoc
class __$ProxyChainCopyWithImpl<$Res>
    implements _$ProxyChainCopyWith<$Res> {
  __$ProxyChainCopyWithImpl(this._self, this._then);

  final _ProxyChain _self;
  final $Res Function(_ProxyChain) _then;

/// Create a copy of ProxyChain
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? hops = null,Object? enabled = null,Object? hidden = null,Object? targetGroup = freezed,Object? targetGroups = null,}) {
  return _then(_ProxyChain(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,hops: null == hops ? _self._hops : hops // ignore: cast_nullable_to_non_nullable
as List<String>,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,hidden: null == hidden ? _self.hidden : hidden // ignore: cast_nullable_to_non_nullable
as bool,targetGroup: freezed == targetGroup ? _self.targetGroup : targetGroup // ignore: cast_nullable_to_non_nullable
as String?,targetGroups: null == targetGroups ? _self._targetGroups : targetGroups // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
