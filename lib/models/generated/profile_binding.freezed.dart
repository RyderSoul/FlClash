// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../profile_binding.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupAttachment {

 String get target; SubscriptionAttachMode get mode;
/// Create a copy of GroupAttachment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupAttachmentCopyWith<GroupAttachment> get copyWith => _$GroupAttachmentCopyWithImpl<GroupAttachment>(this as GroupAttachment, _$identity);

  /// Serializes this GroupAttachment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GroupAttachment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupAttachment&&(identical(other.target, _this.target) || other.target == _this.target)&&(identical(other.mode, _this.mode) || other.mode == _this.mode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GroupAttachment;
  return Object.hash(runtimeType,_this.target,_this.mode);
}

@override
String toString() {
  final _this = this as GroupAttachment;
  return 'GroupAttachment(target: ${_this.target}, mode: ${_this.mode})';
}


}

/// @nodoc
abstract mixin class $GroupAttachmentCopyWith<$Res>  {
  factory $GroupAttachmentCopyWith(GroupAttachment value, $Res Function(GroupAttachment) _then) = _$GroupAttachmentCopyWithImpl;
@useResult
$Res call({
 String target, SubscriptionAttachMode mode
});




}
/// @nodoc
class _$GroupAttachmentCopyWithImpl<$Res>
    implements $GroupAttachmentCopyWith<$Res> {
  _$GroupAttachmentCopyWithImpl(this._self, this._then);

  final GroupAttachment _self;
  final $Res Function(GroupAttachment) _then;

/// Create a copy of GroupAttachment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? target = null,Object? mode = null,}) {
  return _then(GroupAttachment(
target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as SubscriptionAttachMode,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupAttachment].
extension GroupAttachmentPatterns on GroupAttachment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupAttachment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupAttachment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupAttachment value)  $default,){
final _that = this;
switch (_that) {
case _GroupAttachment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupAttachment value)?  $default,){
final _that = this;
switch (_that) {
case _GroupAttachment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String target,  SubscriptionAttachMode mode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupAttachment() when $default != null:
return $default(_that.target,_that.mode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String target,  SubscriptionAttachMode mode)  $default,) {final _that = this;
switch (_that) {
case _GroupAttachment():
return $default(_that.target,_that.mode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String target,  SubscriptionAttachMode mode)?  $default,) {final _that = this;
switch (_that) {
case _GroupAttachment() when $default != null:
return $default(_that.target,_that.mode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupAttachment implements GroupAttachment {
  const _GroupAttachment({required this.target, this.mode = SubscriptionAttachMode.nodes});
  factory _GroupAttachment.fromJson(Map<String, dynamic> json) => _$GroupAttachmentFromJson(json);

@override final  String target;
@override@JsonKey() final  SubscriptionAttachMode mode;

/// Create a copy of GroupAttachment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupAttachmentCopyWith<_GroupAttachment> get copyWith => __$GroupAttachmentCopyWithImpl<_GroupAttachment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupAttachmentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupAttachment&&(identical(other.target, target) || other.target == target)&&(identical(other.mode, mode) || other.mode == mode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,target,mode);
}

@override
String toString() {
    return 'GroupAttachment(target: $target, mode: $mode)';
}


}

/// @nodoc
abstract mixin class _$GroupAttachmentCopyWith<$Res> implements $GroupAttachmentCopyWith<$Res> {
  factory _$GroupAttachmentCopyWith(_GroupAttachment value, $Res Function(_GroupAttachment) _then) = __$GroupAttachmentCopyWithImpl;
@override @useResult
$Res call({
 String target, SubscriptionAttachMode mode
});




}
/// @nodoc
class __$GroupAttachmentCopyWithImpl<$Res>
    implements _$GroupAttachmentCopyWith<$Res> {
  __$GroupAttachmentCopyWithImpl(this._self, this._then);

  final _GroupAttachment _self;
  final $Res Function(_GroupAttachment) _then;

/// Create a copy of GroupAttachment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? target = null,Object? mode = null,}) {
  return _then(_GroupAttachment(
target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as SubscriptionAttachMode,
  ));
}


}


/// @nodoc
mixin _$SubscriptionBinding {

 String get id; int get sourceId; String get name; bool get enabled; String get filter; GroupType get groupType; List<GroupAttachment> get attachments;
/// Create a copy of SubscriptionBinding
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionBindingCopyWith<SubscriptionBinding> get copyWith => _$SubscriptionBindingCopyWithImpl<SubscriptionBinding>(this as SubscriptionBinding, _$identity);

  /// Serializes this SubscriptionBinding to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SubscriptionBinding;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionBinding&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.sourceId, _this.sourceId) || other.sourceId == _this.sourceId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.enabled, _this.enabled) || other.enabled == _this.enabled)&&(identical(other.filter, _this.filter) || other.filter == _this.filter)&&(identical(other.groupType, _this.groupType) || other.groupType == _this.groupType)&&const DeepCollectionEquality().equals(other.attachments, _this.attachments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SubscriptionBinding;
  return Object.hash(runtimeType,_this.id,_this.sourceId,_this.name,_this.enabled,_this.filter,_this.groupType,const DeepCollectionEquality().hash(_this.attachments));
}

@override
String toString() {
  final _this = this as SubscriptionBinding;
  return 'SubscriptionBinding(id: ${_this.id}, sourceId: ${_this.sourceId}, name: ${_this.name}, enabled: ${_this.enabled}, filter: ${_this.filter}, groupType: ${_this.groupType}, attachments: ${_this.attachments})';
}


}

/// @nodoc
abstract mixin class $SubscriptionBindingCopyWith<$Res>  {
  factory $SubscriptionBindingCopyWith(SubscriptionBinding value, $Res Function(SubscriptionBinding) _then) = _$SubscriptionBindingCopyWithImpl;
@useResult
$Res call({
 String id, int sourceId, String name, bool enabled, String filter, GroupType groupType, List<GroupAttachment> attachments
});




}
/// @nodoc
class _$SubscriptionBindingCopyWithImpl<$Res>
    implements $SubscriptionBindingCopyWith<$Res> {
  _$SubscriptionBindingCopyWithImpl(this._self, this._then);

  final SubscriptionBinding _self;
  final $Res Function(SubscriptionBinding) _then;

/// Create a copy of SubscriptionBinding
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sourceId = null,Object? name = null,Object? enabled = null,Object? filter = null,Object? groupType = null,Object? attachments = null,}) {
  return _then(SubscriptionBinding(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as String,groupType: null == groupType ? _self.groupType : groupType // ignore: cast_nullable_to_non_nullable
as GroupType,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<GroupAttachment>,
  ));
}

}


/// Adds pattern-matching-related methods to [SubscriptionBinding].
extension SubscriptionBindingPatterns on SubscriptionBinding {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubscriptionBinding value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubscriptionBinding() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubscriptionBinding value)  $default,){
final _that = this;
switch (_that) {
case _SubscriptionBinding():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubscriptionBinding value)?  $default,){
final _that = this;
switch (_that) {
case _SubscriptionBinding() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int sourceId,  String name,  bool enabled,  String filter,  GroupType groupType,  List<GroupAttachment> attachments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubscriptionBinding() when $default != null:
return $default(_that.id,_that.sourceId,_that.name,_that.enabled,_that.filter,_that.groupType,_that.attachments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int sourceId,  String name,  bool enabled,  String filter,  GroupType groupType,  List<GroupAttachment> attachments)  $default,) {final _that = this;
switch (_that) {
case _SubscriptionBinding():
return $default(_that.id,_that.sourceId,_that.name,_that.enabled,_that.filter,_that.groupType,_that.attachments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int sourceId,  String name,  bool enabled,  String filter,  GroupType groupType,  List<GroupAttachment> attachments)?  $default,) {final _that = this;
switch (_that) {
case _SubscriptionBinding() when $default != null:
return $default(_that.id,_that.sourceId,_that.name,_that.enabled,_that.filter,_that.groupType,_that.attachments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubscriptionBinding implements SubscriptionBinding {
  const _SubscriptionBinding({required this.id, required this.sourceId, required this.name, this.enabled = true, this.filter = '', this.groupType = GroupType.Selector,  List<GroupAttachment> attachments = const []}): _attachments = attachments;
  factory _SubscriptionBinding.fromJson(Map<String, dynamic> json) => _$SubscriptionBindingFromJson(json);

@override final  String id;
@override final  int sourceId;
@override final  String name;
@override@JsonKey() final  bool enabled;
@override@JsonKey() final  String filter;
@override@JsonKey() final  GroupType groupType;
 final  List<GroupAttachment> _attachments;
@override@JsonKey() List<GroupAttachment> get attachments {
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachments);
}


/// Create a copy of SubscriptionBinding
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscriptionBindingCopyWith<_SubscriptionBinding> get copyWith => __$SubscriptionBindingCopyWithImpl<_SubscriptionBinding>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubscriptionBindingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubscriptionBinding&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.name, name) || other.name == name)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.groupType, groupType) || other.groupType == groupType)&&const DeepCollectionEquality().equals(other.attachments, _attachments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,sourceId,name,enabled,filter,groupType,const DeepCollectionEquality().hash(_attachments));
}

@override
String toString() {
    return 'SubscriptionBinding(id: $id, sourceId: $sourceId, name: $name, enabled: $enabled, filter: $filter, groupType: $groupType, attachments: $attachments)';
}


}

/// @nodoc
abstract mixin class _$SubscriptionBindingCopyWith<$Res> implements $SubscriptionBindingCopyWith<$Res> {
  factory _$SubscriptionBindingCopyWith(_SubscriptionBinding value, $Res Function(_SubscriptionBinding) _then) = __$SubscriptionBindingCopyWithImpl;
@override @useResult
$Res call({
 String id, int sourceId, String name, bool enabled, String filter, GroupType groupType, List<GroupAttachment> attachments
});




}
/// @nodoc
class __$SubscriptionBindingCopyWithImpl<$Res>
    implements _$SubscriptionBindingCopyWith<$Res> {
  __$SubscriptionBindingCopyWithImpl(this._self, this._then);

  final _SubscriptionBinding _self;
  final $Res Function(_SubscriptionBinding) _then;

/// Create a copy of SubscriptionBinding
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sourceId = null,Object? name = null,Object? enabled = null,Object? filter = null,Object? groupType = null,Object? attachments = null,}) {
  return _then(_SubscriptionBinding(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as String,groupType: null == groupType ? _self.groupType : groupType // ignore: cast_nullable_to_non_nullable
as GroupType,attachments: null == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<GroupAttachment>,
  ));
}


}


/// @nodoc
mixin _$RuleSetBinding {

 String get id; int get sourceId; String get target; bool get enabled;
/// Create a copy of RuleSetBinding
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RuleSetBindingCopyWith<RuleSetBinding> get copyWith => _$RuleSetBindingCopyWithImpl<RuleSetBinding>(this as RuleSetBinding, _$identity);

  /// Serializes this RuleSetBinding to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RuleSetBinding;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RuleSetBinding&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.sourceId, _this.sourceId) || other.sourceId == _this.sourceId)&&(identical(other.target, _this.target) || other.target == _this.target)&&(identical(other.enabled, _this.enabled) || other.enabled == _this.enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RuleSetBinding;
  return Object.hash(runtimeType,_this.id,_this.sourceId,_this.target,_this.enabled);
}

@override
String toString() {
  final _this = this as RuleSetBinding;
  return 'RuleSetBinding(id: ${_this.id}, sourceId: ${_this.sourceId}, target: ${_this.target}, enabled: ${_this.enabled})';
}


}

/// @nodoc
abstract mixin class $RuleSetBindingCopyWith<$Res>  {
  factory $RuleSetBindingCopyWith(RuleSetBinding value, $Res Function(RuleSetBinding) _then) = _$RuleSetBindingCopyWithImpl;
@useResult
$Res call({
 String id, int sourceId, String target, bool enabled
});




}
/// @nodoc
class _$RuleSetBindingCopyWithImpl<$Res>
    implements $RuleSetBindingCopyWith<$Res> {
  _$RuleSetBindingCopyWithImpl(this._self, this._then);

  final RuleSetBinding _self;
  final $Res Function(RuleSetBinding) _then;

/// Create a copy of RuleSetBinding
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sourceId = null,Object? target = null,Object? enabled = null,}) {
  return _then(RuleSetBinding(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as int,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RuleSetBinding].
extension RuleSetBindingPatterns on RuleSetBinding {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RuleSetBinding value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RuleSetBinding() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RuleSetBinding value)  $default,){
final _that = this;
switch (_that) {
case _RuleSetBinding():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RuleSetBinding value)?  $default,){
final _that = this;
switch (_that) {
case _RuleSetBinding() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int sourceId,  String target,  bool enabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RuleSetBinding() when $default != null:
return $default(_that.id,_that.sourceId,_that.target,_that.enabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int sourceId,  String target,  bool enabled)  $default,) {final _that = this;
switch (_that) {
case _RuleSetBinding():
return $default(_that.id,_that.sourceId,_that.target,_that.enabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int sourceId,  String target,  bool enabled)?  $default,) {final _that = this;
switch (_that) {
case _RuleSetBinding() when $default != null:
return $default(_that.id,_that.sourceId,_that.target,_that.enabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RuleSetBinding implements RuleSetBinding {
  const _RuleSetBinding({required this.id, required this.sourceId, required this.target, this.enabled = true});
  factory _RuleSetBinding.fromJson(Map<String, dynamic> json) => _$RuleSetBindingFromJson(json);

@override final  String id;
@override final  int sourceId;
@override final  String target;
@override@JsonKey() final  bool enabled;

/// Create a copy of RuleSetBinding
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RuleSetBindingCopyWith<_RuleSetBinding> get copyWith => __$RuleSetBindingCopyWithImpl<_RuleSetBinding>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RuleSetBindingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RuleSetBinding&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.target, target) || other.target == target)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,sourceId,target,enabled);
}

@override
String toString() {
    return 'RuleSetBinding(id: $id, sourceId: $sourceId, target: $target, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$RuleSetBindingCopyWith<$Res> implements $RuleSetBindingCopyWith<$Res> {
  factory _$RuleSetBindingCopyWith(_RuleSetBinding value, $Res Function(_RuleSetBinding) _then) = __$RuleSetBindingCopyWithImpl;
@override @useResult
$Res call({
 String id, int sourceId, String target, bool enabled
});




}
/// @nodoc
class __$RuleSetBindingCopyWithImpl<$Res>
    implements _$RuleSetBindingCopyWith<$Res> {
  __$RuleSetBindingCopyWithImpl(this._self, this._then);

  final _RuleSetBinding _self;
  final $Res Function(_RuleSetBinding) _then;

/// Create a copy of RuleSetBinding
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sourceId = null,Object? target = null,Object? enabled = null,}) {
  return _then(_RuleSetBinding(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as int,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
