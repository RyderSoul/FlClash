// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../toolbox.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SpeedtestNetServer {

 String get host; String get name; String get cc; String get sponsor; double get latency;
/// Create a copy of SpeedtestNetServer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeedtestNetServerCopyWith<SpeedtestNetServer> get copyWith => _$SpeedtestNetServerCopyWithImpl<SpeedtestNetServer>(this as SpeedtestNetServer, _$identity);

  /// Serializes this SpeedtestNetServer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SpeedtestNetServer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeedtestNetServer&&(identical(other.host, _this.host) || other.host == _this.host)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.cc, _this.cc) || other.cc == _this.cc)&&(identical(other.sponsor, _this.sponsor) || other.sponsor == _this.sponsor)&&(identical(other.latency, _this.latency) || other.latency == _this.latency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SpeedtestNetServer;
  return Object.hash(runtimeType,_this.host,_this.name,_this.cc,_this.sponsor,_this.latency);
}

@override
String toString() {
  final _this = this as SpeedtestNetServer;
  return 'SpeedtestNetServer(host: ${_this.host}, name: ${_this.name}, cc: ${_this.cc}, sponsor: ${_this.sponsor}, latency: ${_this.latency})';
}


}

/// @nodoc
abstract mixin class $SpeedtestNetServerCopyWith<$Res>  {
  factory $SpeedtestNetServerCopyWith(SpeedtestNetServer value, $Res Function(SpeedtestNetServer) _then) = _$SpeedtestNetServerCopyWithImpl;
@useResult
$Res call({
 String host, String name, String cc, String sponsor, double latency
});




}
/// @nodoc
class _$SpeedtestNetServerCopyWithImpl<$Res>
    implements $SpeedtestNetServerCopyWith<$Res> {
  _$SpeedtestNetServerCopyWithImpl(this._self, this._then);

  final SpeedtestNetServer _self;
  final $Res Function(SpeedtestNetServer) _then;

/// Create a copy of SpeedtestNetServer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? host = null,Object? name = null,Object? cc = null,Object? sponsor = null,Object? latency = null,}) {
  return _then(SpeedtestNetServer(
host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,cc: null == cc ? _self.cc : cc // ignore: cast_nullable_to_non_nullable
as String,sponsor: null == sponsor ? _self.sponsor : sponsor // ignore: cast_nullable_to_non_nullable
as String,latency: null == latency ? _self.latency : latency // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [SpeedtestNetServer].
extension SpeedtestNetServerPatterns on SpeedtestNetServer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpeedtestNetServer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpeedtestNetServer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpeedtestNetServer value)  $default,){
final _that = this;
switch (_that) {
case _SpeedtestNetServer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpeedtestNetServer value)?  $default,){
final _that = this;
switch (_that) {
case _SpeedtestNetServer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String host,  String name,  String cc,  String sponsor,  double latency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpeedtestNetServer() when $default != null:
return $default(_that.host,_that.name,_that.cc,_that.sponsor,_that.latency);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String host,  String name,  String cc,  String sponsor,  double latency)  $default,) {final _that = this;
switch (_that) {
case _SpeedtestNetServer():
return $default(_that.host,_that.name,_that.cc,_that.sponsor,_that.latency);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String host,  String name,  String cc,  String sponsor,  double latency)?  $default,) {final _that = this;
switch (_that) {
case _SpeedtestNetServer() when $default != null:
return $default(_that.host,_that.name,_that.cc,_that.sponsor,_that.latency);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SpeedtestNetServer implements SpeedtestNetServer {
  const _SpeedtestNetServer({this.host = '', this.name = '', this.cc = '', this.sponsor = '', this.latency = 0.0});
  factory _SpeedtestNetServer.fromJson(Map<String, dynamic> json) => _$SpeedtestNetServerFromJson(json);

@override@JsonKey() final  String host;
@override@JsonKey() final  String name;
@override@JsonKey() final  String cc;
@override@JsonKey() final  String sponsor;
@override@JsonKey() final  double latency;

/// Create a copy of SpeedtestNetServer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpeedtestNetServerCopyWith<_SpeedtestNetServer> get copyWith => __$SpeedtestNetServerCopyWithImpl<_SpeedtestNetServer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpeedtestNetServerToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpeedtestNetServer&&(identical(other.host, host) || other.host == host)&&(identical(other.name, name) || other.name == name)&&(identical(other.cc, cc) || other.cc == cc)&&(identical(other.sponsor, sponsor) || other.sponsor == sponsor)&&(identical(other.latency, latency) || other.latency == latency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,host,name,cc,sponsor,latency);
}

@override
String toString() {
    return 'SpeedtestNetServer(host: $host, name: $name, cc: $cc, sponsor: $sponsor, latency: $latency)';
}


}

/// @nodoc
abstract mixin class _$SpeedtestNetServerCopyWith<$Res> implements $SpeedtestNetServerCopyWith<$Res> {
  factory _$SpeedtestNetServerCopyWith(_SpeedtestNetServer value, $Res Function(_SpeedtestNetServer) _then) = __$SpeedtestNetServerCopyWithImpl;
@override @useResult
$Res call({
 String host, String name, String cc, String sponsor, double latency
});




}
/// @nodoc
class __$SpeedtestNetServerCopyWithImpl<$Res>
    implements _$SpeedtestNetServerCopyWith<$Res> {
  __$SpeedtestNetServerCopyWithImpl(this._self, this._then);

  final _SpeedtestNetServer _self;
  final $Res Function(_SpeedtestNetServer) _then;

/// Create a copy of SpeedtestNetServer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? host = null,Object? name = null,Object? cc = null,Object? sponsor = null,Object? latency = null,}) {
  return _then(_SpeedtestNetServer(
host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,cc: null == cc ? _self.cc : cc // ignore: cast_nullable_to_non_nullable
as String,sponsor: null == sponsor ? _self.sponsor : sponsor // ignore: cast_nullable_to_non_nullable
as String,latency: null == latency ? _self.latency : latency // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$SpeedTestParams {

 String get provider; String get lang; String get proxy; int get duration; String get protocol; int get streams;@JsonKey(name: 'use-system-dns') bool get useSystemDns;@JsonKey(includeIfNull: false) SpeedtestNetServer? get server;
/// Create a copy of SpeedTestParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeedTestParamsCopyWith<SpeedTestParams> get copyWith => _$SpeedTestParamsCopyWithImpl<SpeedTestParams>(this as SpeedTestParams, _$identity);

  /// Serializes this SpeedTestParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SpeedTestParams;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeedTestParams&&(identical(other.provider, _this.provider) || other.provider == _this.provider)&&(identical(other.lang, _this.lang) || other.lang == _this.lang)&&(identical(other.proxy, _this.proxy) || other.proxy == _this.proxy)&&(identical(other.duration, _this.duration) || other.duration == _this.duration)&&(identical(other.protocol, _this.protocol) || other.protocol == _this.protocol)&&(identical(other.streams, _this.streams) || other.streams == _this.streams)&&(identical(other.useSystemDns, _this.useSystemDns) || other.useSystemDns == _this.useSystemDns)&&(identical(other.server, _this.server) || other.server == _this.server));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SpeedTestParams;
  return Object.hash(runtimeType,_this.provider,_this.lang,_this.proxy,_this.duration,_this.protocol,_this.streams,_this.useSystemDns,_this.server);
}

@override
String toString() {
  final _this = this as SpeedTestParams;
  return 'SpeedTestParams(provider: ${_this.provider}, lang: ${_this.lang}, proxy: ${_this.proxy}, duration: ${_this.duration}, protocol: ${_this.protocol}, streams: ${_this.streams}, useSystemDns: ${_this.useSystemDns}, server: ${_this.server})';
}


}

/// @nodoc
abstract mixin class $SpeedTestParamsCopyWith<$Res>  {
  factory $SpeedTestParamsCopyWith(SpeedTestParams value, $Res Function(SpeedTestParams) _then) = _$SpeedTestParamsCopyWithImpl;
@useResult
$Res call({
 String provider, String lang, String proxy, int duration, String protocol, int streams,@JsonKey(name: 'use-system-dns') bool useSystemDns,@JsonKey(includeIfNull: false) SpeedtestNetServer? server
});


$SpeedtestNetServerCopyWith<$Res>? get server;

}
/// @nodoc
class _$SpeedTestParamsCopyWithImpl<$Res>
    implements $SpeedTestParamsCopyWith<$Res> {
  _$SpeedTestParamsCopyWithImpl(this._self, this._then);

  final SpeedTestParams _self;
  final $Res Function(SpeedTestParams) _then;

/// Create a copy of SpeedTestParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? provider = null,Object? lang = null,Object? proxy = null,Object? duration = null,Object? protocol = null,Object? streams = null,Object? useSystemDns = null,Object? server = freezed,}) {
  return _then(SpeedTestParams(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,lang: null == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String,proxy: null == proxy ? _self.proxy : proxy // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,protocol: null == protocol ? _self.protocol : protocol // ignore: cast_nullable_to_non_nullable
as String,streams: null == streams ? _self.streams : streams // ignore: cast_nullable_to_non_nullable
as int,useSystemDns: null == useSystemDns ? _self.useSystemDns : useSystemDns // ignore: cast_nullable_to_non_nullable
as bool,server: freezed == server ? _self.server : server // ignore: cast_nullable_to_non_nullable
as SpeedtestNetServer?,
  ));
}
/// Create a copy of SpeedTestParams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpeedtestNetServerCopyWith<$Res>? get server {
    if (_self.server == null) {
    return null;
  }

  return $SpeedtestNetServerCopyWith<$Res>(_self.server!, (value) {
    return _then(_self.copyWith(server: value));
  });
}
}


/// Adds pattern-matching-related methods to [SpeedTestParams].
extension SpeedTestParamsPatterns on SpeedTestParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpeedTestParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpeedTestParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpeedTestParams value)  $default,){
final _that = this;
switch (_that) {
case _SpeedTestParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpeedTestParams value)?  $default,){
final _that = this;
switch (_that) {
case _SpeedTestParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String provider,  String lang,  String proxy,  int duration,  String protocol,  int streams, @JsonKey(name: 'use-system-dns')  bool useSystemDns, @JsonKey(includeIfNull: false)  SpeedtestNetServer? server)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpeedTestParams() when $default != null:
return $default(_that.provider,_that.lang,_that.proxy,_that.duration,_that.protocol,_that.streams,_that.useSystemDns,_that.server);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String provider,  String lang,  String proxy,  int duration,  String protocol,  int streams, @JsonKey(name: 'use-system-dns')  bool useSystemDns, @JsonKey(includeIfNull: false)  SpeedtestNetServer? server)  $default,) {final _that = this;
switch (_that) {
case _SpeedTestParams():
return $default(_that.provider,_that.lang,_that.proxy,_that.duration,_that.protocol,_that.streams,_that.useSystemDns,_that.server);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String provider,  String lang,  String proxy,  int duration,  String protocol,  int streams, @JsonKey(name: 'use-system-dns')  bool useSystemDns, @JsonKey(includeIfNull: false)  SpeedtestNetServer? server)?  $default,) {final _that = this;
switch (_that) {
case _SpeedTestParams() when $default != null:
return $default(_that.provider,_that.lang,_that.proxy,_that.duration,_that.protocol,_that.streams,_that.useSystemDns,_that.server);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SpeedTestParams implements SpeedTestParams {
  const _SpeedTestParams({this.provider = 'apple', this.lang = '', this.proxy = '', this.duration = 10, this.protocol = 'h1', this.streams = 8, @JsonKey(name: 'use-system-dns') this.useSystemDns = false, @JsonKey(includeIfNull: false) this.server});
  factory _SpeedTestParams.fromJson(Map<String, dynamic> json) => _$SpeedTestParamsFromJson(json);

@override@JsonKey() final  String provider;
@override@JsonKey() final  String lang;
@override@JsonKey() final  String proxy;
@override@JsonKey() final  int duration;
@override@JsonKey() final  String protocol;
@override@JsonKey() final  int streams;
@override@JsonKey(name: 'use-system-dns') final  bool useSystemDns;
@override@JsonKey(includeIfNull: false) final  SpeedtestNetServer? server;

/// Create a copy of SpeedTestParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpeedTestParamsCopyWith<_SpeedTestParams> get copyWith => __$SpeedTestParamsCopyWithImpl<_SpeedTestParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpeedTestParamsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpeedTestParams&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.proxy, proxy) || other.proxy == proxy)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.protocol, protocol) || other.protocol == protocol)&&(identical(other.streams, streams) || other.streams == streams)&&(identical(other.useSystemDns, useSystemDns) || other.useSystemDns == useSystemDns)&&(identical(other.server, server) || other.server == server));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,provider,lang,proxy,duration,protocol,streams,useSystemDns,server);
}

@override
String toString() {
    return 'SpeedTestParams(provider: $provider, lang: $lang, proxy: $proxy, duration: $duration, protocol: $protocol, streams: $streams, useSystemDns: $useSystemDns, server: $server)';
}


}

/// @nodoc
abstract mixin class _$SpeedTestParamsCopyWith<$Res> implements $SpeedTestParamsCopyWith<$Res> {
  factory _$SpeedTestParamsCopyWith(_SpeedTestParams value, $Res Function(_SpeedTestParams) _then) = __$SpeedTestParamsCopyWithImpl;
@override @useResult
$Res call({
 String provider, String lang, String proxy, int duration, String protocol, int streams,@JsonKey(name: 'use-system-dns') bool useSystemDns,@JsonKey(includeIfNull: false) SpeedtestNetServer? server
});


@override $SpeedtestNetServerCopyWith<$Res>? get server;

}
/// @nodoc
class __$SpeedTestParamsCopyWithImpl<$Res>
    implements _$SpeedTestParamsCopyWith<$Res> {
  __$SpeedTestParamsCopyWithImpl(this._self, this._then);

  final _SpeedTestParams _self;
  final $Res Function(_SpeedTestParams) _then;

/// Create a copy of SpeedTestParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? provider = null,Object? lang = null,Object? proxy = null,Object? duration = null,Object? protocol = null,Object? streams = null,Object? useSystemDns = null,Object? server = freezed,}) {
  return _then(_SpeedTestParams(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,lang: null == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String,proxy: null == proxy ? _self.proxy : proxy // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,protocol: null == protocol ? _self.protocol : protocol // ignore: cast_nullable_to_non_nullable
as String,streams: null == streams ? _self.streams : streams // ignore: cast_nullable_to_non_nullable
as int,useSystemDns: null == useSystemDns ? _self.useSystemDns : useSystemDns // ignore: cast_nullable_to_non_nullable
as bool,server: freezed == server ? _self.server : server // ignore: cast_nullable_to_non_nullable
as SpeedtestNetServer?,
  ));
}

/// Create a copy of SpeedTestParams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpeedtestNetServerCopyWith<$Res>? get server {
    if (_self.server == null) {
    return null;
  }

  return $SpeedtestNetServerCopyWith<$Res>(_self.server!, (value) {
    return _then(_self.copyWith(server: value));
  });
}
}


/// @nodoc
mixin _$SpeedTestServersParams {

 String get proxy; String get search;
/// Create a copy of SpeedTestServersParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeedTestServersParamsCopyWith<SpeedTestServersParams> get copyWith => _$SpeedTestServersParamsCopyWithImpl<SpeedTestServersParams>(this as SpeedTestServersParams, _$identity);

  /// Serializes this SpeedTestServersParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SpeedTestServersParams;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeedTestServersParams&&(identical(other.proxy, _this.proxy) || other.proxy == _this.proxy)&&(identical(other.search, _this.search) || other.search == _this.search));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SpeedTestServersParams;
  return Object.hash(runtimeType,_this.proxy,_this.search);
}

@override
String toString() {
  final _this = this as SpeedTestServersParams;
  return 'SpeedTestServersParams(proxy: ${_this.proxy}, search: ${_this.search})';
}


}

/// @nodoc
abstract mixin class $SpeedTestServersParamsCopyWith<$Res>  {
  factory $SpeedTestServersParamsCopyWith(SpeedTestServersParams value, $Res Function(SpeedTestServersParams) _then) = _$SpeedTestServersParamsCopyWithImpl;
@useResult
$Res call({
 String proxy, String search
});




}
/// @nodoc
class _$SpeedTestServersParamsCopyWithImpl<$Res>
    implements $SpeedTestServersParamsCopyWith<$Res> {
  _$SpeedTestServersParamsCopyWithImpl(this._self, this._then);

  final SpeedTestServersParams _self;
  final $Res Function(SpeedTestServersParams) _then;

/// Create a copy of SpeedTestServersParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? proxy = null,Object? search = null,}) {
  return _then(SpeedTestServersParams(
proxy: null == proxy ? _self.proxy : proxy // ignore: cast_nullable_to_non_nullable
as String,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SpeedTestServersParams].
extension SpeedTestServersParamsPatterns on SpeedTestServersParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpeedTestServersParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpeedTestServersParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpeedTestServersParams value)  $default,){
final _that = this;
switch (_that) {
case _SpeedTestServersParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpeedTestServersParams value)?  $default,){
final _that = this;
switch (_that) {
case _SpeedTestServersParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String proxy,  String search)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpeedTestServersParams() when $default != null:
return $default(_that.proxy,_that.search);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String proxy,  String search)  $default,) {final _that = this;
switch (_that) {
case _SpeedTestServersParams():
return $default(_that.proxy,_that.search);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String proxy,  String search)?  $default,) {final _that = this;
switch (_that) {
case _SpeedTestServersParams() when $default != null:
return $default(_that.proxy,_that.search);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SpeedTestServersParams implements SpeedTestServersParams {
  const _SpeedTestServersParams({this.proxy = '', this.search = ''});
  factory _SpeedTestServersParams.fromJson(Map<String, dynamic> json) => _$SpeedTestServersParamsFromJson(json);

@override@JsonKey() final  String proxy;
@override@JsonKey() final  String search;

/// Create a copy of SpeedTestServersParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpeedTestServersParamsCopyWith<_SpeedTestServersParams> get copyWith => __$SpeedTestServersParamsCopyWithImpl<_SpeedTestServersParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpeedTestServersParamsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpeedTestServersParams&&(identical(other.proxy, proxy) || other.proxy == proxy)&&(identical(other.search, search) || other.search == search));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,proxy,search);
}

@override
String toString() {
    return 'SpeedTestServersParams(proxy: $proxy, search: $search)';
}


}

/// @nodoc
abstract mixin class _$SpeedTestServersParamsCopyWith<$Res> implements $SpeedTestServersParamsCopyWith<$Res> {
  factory _$SpeedTestServersParamsCopyWith(_SpeedTestServersParams value, $Res Function(_SpeedTestServersParams) _then) = __$SpeedTestServersParamsCopyWithImpl;
@override @useResult
$Res call({
 String proxy, String search
});




}
/// @nodoc
class __$SpeedTestServersParamsCopyWithImpl<$Res>
    implements _$SpeedTestServersParamsCopyWith<$Res> {
  __$SpeedTestServersParamsCopyWithImpl(this._self, this._then);

  final _SpeedTestServersParams _self;
  final $Res Function(_SpeedTestServersParams) _then;

/// Create a copy of SpeedTestServersParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? proxy = null,Object? search = null,}) {
  return _then(_SpeedTestServersParams(
proxy: null == proxy ? _self.proxy : proxy // ignore: cast_nullable_to_non_nullable
as String,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SpeedTestOutbound {

 List<String> get chains; String get rule;@JsonKey(name: 'rule-payload') String get rulePayload;
/// Create a copy of SpeedTestOutbound
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeedTestOutboundCopyWith<SpeedTestOutbound> get copyWith => _$SpeedTestOutboundCopyWithImpl<SpeedTestOutbound>(this as SpeedTestOutbound, _$identity);

  /// Serializes this SpeedTestOutbound to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SpeedTestOutbound;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeedTestOutbound&&const DeepCollectionEquality().equals(other.chains, _this.chains)&&(identical(other.rule, _this.rule) || other.rule == _this.rule)&&(identical(other.rulePayload, _this.rulePayload) || other.rulePayload == _this.rulePayload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SpeedTestOutbound;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.chains),_this.rule,_this.rulePayload);
}

@override
String toString() {
  final _this = this as SpeedTestOutbound;
  return 'SpeedTestOutbound(chains: ${_this.chains}, rule: ${_this.rule}, rulePayload: ${_this.rulePayload})';
}


}

/// @nodoc
abstract mixin class $SpeedTestOutboundCopyWith<$Res>  {
  factory $SpeedTestOutboundCopyWith(SpeedTestOutbound value, $Res Function(SpeedTestOutbound) _then) = _$SpeedTestOutboundCopyWithImpl;
@useResult
$Res call({
 List<String> chains, String rule,@JsonKey(name: 'rule-payload') String rulePayload
});




}
/// @nodoc
class _$SpeedTestOutboundCopyWithImpl<$Res>
    implements $SpeedTestOutboundCopyWith<$Res> {
  _$SpeedTestOutboundCopyWithImpl(this._self, this._then);

  final SpeedTestOutbound _self;
  final $Res Function(SpeedTestOutbound) _then;

/// Create a copy of SpeedTestOutbound
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chains = null,Object? rule = null,Object? rulePayload = null,}) {
  return _then(SpeedTestOutbound(
chains: null == chains ? _self.chains : chains // ignore: cast_nullable_to_non_nullable
as List<String>,rule: null == rule ? _self.rule : rule // ignore: cast_nullable_to_non_nullable
as String,rulePayload: null == rulePayload ? _self.rulePayload : rulePayload // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SpeedTestOutbound].
extension SpeedTestOutboundPatterns on SpeedTestOutbound {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpeedTestOutbound value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpeedTestOutbound() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpeedTestOutbound value)  $default,){
final _that = this;
switch (_that) {
case _SpeedTestOutbound():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpeedTestOutbound value)?  $default,){
final _that = this;
switch (_that) {
case _SpeedTestOutbound() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> chains,  String rule, @JsonKey(name: 'rule-payload')  String rulePayload)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpeedTestOutbound() when $default != null:
return $default(_that.chains,_that.rule,_that.rulePayload);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> chains,  String rule, @JsonKey(name: 'rule-payload')  String rulePayload)  $default,) {final _that = this;
switch (_that) {
case _SpeedTestOutbound():
return $default(_that.chains,_that.rule,_that.rulePayload);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> chains,  String rule, @JsonKey(name: 'rule-payload')  String rulePayload)?  $default,) {final _that = this;
switch (_that) {
case _SpeedTestOutbound() when $default != null:
return $default(_that.chains,_that.rule,_that.rulePayload);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SpeedTestOutbound implements SpeedTestOutbound {
  const _SpeedTestOutbound({ List<String> chains = const [], this.rule = '', @JsonKey(name: 'rule-payload') this.rulePayload = ''}): _chains = chains;
  factory _SpeedTestOutbound.fromJson(Map<String, dynamic> json) => _$SpeedTestOutboundFromJson(json);

 final  List<String> _chains;
@override@JsonKey() List<String> get chains {
  if (_chains is EqualUnmodifiableListView) return _chains;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chains);
}

@override@JsonKey() final  String rule;
@override@JsonKey(name: 'rule-payload') final  String rulePayload;

/// Create a copy of SpeedTestOutbound
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpeedTestOutboundCopyWith<_SpeedTestOutbound> get copyWith => __$SpeedTestOutboundCopyWithImpl<_SpeedTestOutbound>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpeedTestOutboundToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpeedTestOutbound&&const DeepCollectionEquality().equals(other.chains, _chains)&&(identical(other.rule, rule) || other.rule == rule)&&(identical(other.rulePayload, rulePayload) || other.rulePayload == rulePayload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_chains),rule,rulePayload);
}

@override
String toString() {
    return 'SpeedTestOutbound(chains: $chains, rule: $rule, rulePayload: $rulePayload)';
}


}

/// @nodoc
abstract mixin class _$SpeedTestOutboundCopyWith<$Res> implements $SpeedTestOutboundCopyWith<$Res> {
  factory _$SpeedTestOutboundCopyWith(_SpeedTestOutbound value, $Res Function(_SpeedTestOutbound) _then) = __$SpeedTestOutboundCopyWithImpl;
@override @useResult
$Res call({
 List<String> chains, String rule,@JsonKey(name: 'rule-payload') String rulePayload
});




}
/// @nodoc
class __$SpeedTestOutboundCopyWithImpl<$Res>
    implements _$SpeedTestOutboundCopyWith<$Res> {
  __$SpeedTestOutboundCopyWithImpl(this._self, this._then);

  final _SpeedTestOutbound _self;
  final $Res Function(_SpeedTestOutbound) _then;

/// Create a copy of SpeedTestOutbound
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chains = null,Object? rule = null,Object? rulePayload = null,}) {
  return _then(_SpeedTestOutbound(
chains: null == chains ? _self._chains : chains // ignore: cast_nullable_to_non_nullable
as List<String>,rule: null == rule ? _self.rule : rule // ignore: cast_nullable_to_non_nullable
as String,rulePayload: null == rulePayload ? _self.rulePayload : rulePayload // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SpeedTestServer {

 String get ip; String get country; String get city; String get colo; String get host; String get sponsor;
/// Create a copy of SpeedTestServer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeedTestServerCopyWith<SpeedTestServer> get copyWith => _$SpeedTestServerCopyWithImpl<SpeedTestServer>(this as SpeedTestServer, _$identity);

  /// Serializes this SpeedTestServer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SpeedTestServer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeedTestServer&&(identical(other.ip, _this.ip) || other.ip == _this.ip)&&(identical(other.country, _this.country) || other.country == _this.country)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.colo, _this.colo) || other.colo == _this.colo)&&(identical(other.host, _this.host) || other.host == _this.host)&&(identical(other.sponsor, _this.sponsor) || other.sponsor == _this.sponsor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SpeedTestServer;
  return Object.hash(runtimeType,_this.ip,_this.country,_this.city,_this.colo,_this.host,_this.sponsor);
}

@override
String toString() {
  final _this = this as SpeedTestServer;
  return 'SpeedTestServer(ip: ${_this.ip}, country: ${_this.country}, city: ${_this.city}, colo: ${_this.colo}, host: ${_this.host}, sponsor: ${_this.sponsor})';
}


}

/// @nodoc
abstract mixin class $SpeedTestServerCopyWith<$Res>  {
  factory $SpeedTestServerCopyWith(SpeedTestServer value, $Res Function(SpeedTestServer) _then) = _$SpeedTestServerCopyWithImpl;
@useResult
$Res call({
 String ip, String country, String city, String colo, String host, String sponsor
});




}
/// @nodoc
class _$SpeedTestServerCopyWithImpl<$Res>
    implements $SpeedTestServerCopyWith<$Res> {
  _$SpeedTestServerCopyWithImpl(this._self, this._then);

  final SpeedTestServer _self;
  final $Res Function(SpeedTestServer) _then;

/// Create a copy of SpeedTestServer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ip = null,Object? country = null,Object? city = null,Object? colo = null,Object? host = null,Object? sponsor = null,}) {
  return _then(SpeedTestServer(
ip: null == ip ? _self.ip : ip // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,colo: null == colo ? _self.colo : colo // ignore: cast_nullable_to_non_nullable
as String,host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,sponsor: null == sponsor ? _self.sponsor : sponsor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SpeedTestServer].
extension SpeedTestServerPatterns on SpeedTestServer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpeedTestServer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpeedTestServer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpeedTestServer value)  $default,){
final _that = this;
switch (_that) {
case _SpeedTestServer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpeedTestServer value)?  $default,){
final _that = this;
switch (_that) {
case _SpeedTestServer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ip,  String country,  String city,  String colo,  String host,  String sponsor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpeedTestServer() when $default != null:
return $default(_that.ip,_that.country,_that.city,_that.colo,_that.host,_that.sponsor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ip,  String country,  String city,  String colo,  String host,  String sponsor)  $default,) {final _that = this;
switch (_that) {
case _SpeedTestServer():
return $default(_that.ip,_that.country,_that.city,_that.colo,_that.host,_that.sponsor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ip,  String country,  String city,  String colo,  String host,  String sponsor)?  $default,) {final _that = this;
switch (_that) {
case _SpeedTestServer() when $default != null:
return $default(_that.ip,_that.country,_that.city,_that.colo,_that.host,_that.sponsor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SpeedTestServer implements SpeedTestServer {
  const _SpeedTestServer({this.ip = '', this.country = '', this.city = '', this.colo = '', this.host = '', this.sponsor = ''});
  factory _SpeedTestServer.fromJson(Map<String, dynamic> json) => _$SpeedTestServerFromJson(json);

@override@JsonKey() final  String ip;
@override@JsonKey() final  String country;
@override@JsonKey() final  String city;
@override@JsonKey() final  String colo;
@override@JsonKey() final  String host;
@override@JsonKey() final  String sponsor;

/// Create a copy of SpeedTestServer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpeedTestServerCopyWith<_SpeedTestServer> get copyWith => __$SpeedTestServerCopyWithImpl<_SpeedTestServer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpeedTestServerToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpeedTestServer&&(identical(other.ip, ip) || other.ip == ip)&&(identical(other.country, country) || other.country == country)&&(identical(other.city, city) || other.city == city)&&(identical(other.colo, colo) || other.colo == colo)&&(identical(other.host, host) || other.host == host)&&(identical(other.sponsor, sponsor) || other.sponsor == sponsor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,ip,country,city,colo,host,sponsor);
}

@override
String toString() {
    return 'SpeedTestServer(ip: $ip, country: $country, city: $city, colo: $colo, host: $host, sponsor: $sponsor)';
}


}

/// @nodoc
abstract mixin class _$SpeedTestServerCopyWith<$Res> implements $SpeedTestServerCopyWith<$Res> {
  factory _$SpeedTestServerCopyWith(_SpeedTestServer value, $Res Function(_SpeedTestServer) _then) = __$SpeedTestServerCopyWithImpl;
@override @useResult
$Res call({
 String ip, String country, String city, String colo, String host, String sponsor
});




}
/// @nodoc
class __$SpeedTestServerCopyWithImpl<$Res>
    implements _$SpeedTestServerCopyWith<$Res> {
  __$SpeedTestServerCopyWithImpl(this._self, this._then);

  final _SpeedTestServer _self;
  final $Res Function(_SpeedTestServer) _then;

/// Create a copy of SpeedTestServer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ip = null,Object? country = null,Object? city = null,Object? colo = null,Object? host = null,Object? sponsor = null,}) {
  return _then(_SpeedTestServer(
ip: null == ip ? _self.ip : ip // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,colo: null == colo ? _self.colo : colo // ignore: cast_nullable_to_non_nullable
as String,host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,sponsor: null == sponsor ? _self.sponsor : sponsor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SpeedTestState {

 String get provider; String get protocol; bool get fallback;@JsonKey(name: 'exit-ip') String get exitIp;@JsonKey(name: 'exit-info') Map<String, dynamic>? get exitInfo; int get streams; int get duration; String get phase; double get progress; double get speed; bool get direct; SpeedTestOutbound? get outbound; SpeedTestServer? get server; double get latency; double get jitter; double get download; double get upload;@JsonKey(name: 'download-latency') double get downloadLatency;@JsonKey(name: 'upload-latency') double get uploadLatency; int get rpm; int get bytes; String get error;
/// Create a copy of SpeedTestState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeedTestStateCopyWith<SpeedTestState> get copyWith => _$SpeedTestStateCopyWithImpl<SpeedTestState>(this as SpeedTestState, _$identity);

  /// Serializes this SpeedTestState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SpeedTestState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeedTestState&&(identical(other.provider, _this.provider) || other.provider == _this.provider)&&(identical(other.protocol, _this.protocol) || other.protocol == _this.protocol)&&(identical(other.fallback, _this.fallback) || other.fallback == _this.fallback)&&(identical(other.exitIp, _this.exitIp) || other.exitIp == _this.exitIp)&&const DeepCollectionEquality().equals(other.exitInfo, _this.exitInfo)&&(identical(other.streams, _this.streams) || other.streams == _this.streams)&&(identical(other.duration, _this.duration) || other.duration == _this.duration)&&(identical(other.phase, _this.phase) || other.phase == _this.phase)&&(identical(other.progress, _this.progress) || other.progress == _this.progress)&&(identical(other.speed, _this.speed) || other.speed == _this.speed)&&(identical(other.direct, _this.direct) || other.direct == _this.direct)&&(identical(other.outbound, _this.outbound) || other.outbound == _this.outbound)&&(identical(other.server, _this.server) || other.server == _this.server)&&(identical(other.latency, _this.latency) || other.latency == _this.latency)&&(identical(other.jitter, _this.jitter) || other.jitter == _this.jitter)&&(identical(other.download, _this.download) || other.download == _this.download)&&(identical(other.upload, _this.upload) || other.upload == _this.upload)&&(identical(other.downloadLatency, _this.downloadLatency) || other.downloadLatency == _this.downloadLatency)&&(identical(other.uploadLatency, _this.uploadLatency) || other.uploadLatency == _this.uploadLatency)&&(identical(other.rpm, _this.rpm) || other.rpm == _this.rpm)&&(identical(other.bytes, _this.bytes) || other.bytes == _this.bytes)&&(identical(other.error, _this.error) || other.error == _this.error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SpeedTestState;
  return Object.hashAll([runtimeType,_this.provider,_this.protocol,_this.fallback,_this.exitIp,const DeepCollectionEquality().hash(_this.exitInfo),_this.streams,_this.duration,_this.phase,_this.progress,_this.speed,_this.direct,_this.outbound,_this.server,_this.latency,_this.jitter,_this.download,_this.upload,_this.downloadLatency,_this.uploadLatency,_this.rpm,_this.bytes,_this.error]);
}

@override
String toString() {
  final _this = this as SpeedTestState;
  return 'SpeedTestState(provider: ${_this.provider}, protocol: ${_this.protocol}, fallback: ${_this.fallback}, exitIp: ${_this.exitIp}, exitInfo: ${_this.exitInfo}, streams: ${_this.streams}, duration: ${_this.duration}, phase: ${_this.phase}, progress: ${_this.progress}, speed: ${_this.speed}, direct: ${_this.direct}, outbound: ${_this.outbound}, server: ${_this.server}, latency: ${_this.latency}, jitter: ${_this.jitter}, download: ${_this.download}, upload: ${_this.upload}, downloadLatency: ${_this.downloadLatency}, uploadLatency: ${_this.uploadLatency}, rpm: ${_this.rpm}, bytes: ${_this.bytes}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $SpeedTestStateCopyWith<$Res>  {
  factory $SpeedTestStateCopyWith(SpeedTestState value, $Res Function(SpeedTestState) _then) = _$SpeedTestStateCopyWithImpl;
@useResult
$Res call({
 String provider, String protocol, bool fallback,@JsonKey(name: 'exit-ip') String exitIp,@JsonKey(name: 'exit-info') Map<String, dynamic>? exitInfo, int streams, int duration, String phase, double progress, double speed, bool direct, SpeedTestOutbound? outbound, SpeedTestServer? server, double latency, double jitter, double download, double upload,@JsonKey(name: 'download-latency') double downloadLatency,@JsonKey(name: 'upload-latency') double uploadLatency, int rpm, int bytes, String error
});


$SpeedTestOutboundCopyWith<$Res>? get outbound;$SpeedTestServerCopyWith<$Res>? get server;

}
/// @nodoc
class _$SpeedTestStateCopyWithImpl<$Res>
    implements $SpeedTestStateCopyWith<$Res> {
  _$SpeedTestStateCopyWithImpl(this._self, this._then);

  final SpeedTestState _self;
  final $Res Function(SpeedTestState) _then;

/// Create a copy of SpeedTestState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? provider = null,Object? protocol = null,Object? fallback = null,Object? exitIp = null,Object? exitInfo = freezed,Object? streams = null,Object? duration = null,Object? phase = null,Object? progress = null,Object? speed = null,Object? direct = null,Object? outbound = freezed,Object? server = freezed,Object? latency = null,Object? jitter = null,Object? download = null,Object? upload = null,Object? downloadLatency = null,Object? uploadLatency = null,Object? rpm = null,Object? bytes = null,Object? error = null,}) {
  return _then(SpeedTestState(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,protocol: null == protocol ? _self.protocol : protocol // ignore: cast_nullable_to_non_nullable
as String,fallback: null == fallback ? _self.fallback : fallback // ignore: cast_nullable_to_non_nullable
as bool,exitIp: null == exitIp ? _self.exitIp : exitIp // ignore: cast_nullable_to_non_nullable
as String,exitInfo: freezed == exitInfo ? _self.exitInfo : exitInfo // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,streams: null == streams ? _self.streams : streams // ignore: cast_nullable_to_non_nullable
as int,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as String,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,direct: null == direct ? _self.direct : direct // ignore: cast_nullable_to_non_nullable
as bool,outbound: freezed == outbound ? _self.outbound : outbound // ignore: cast_nullable_to_non_nullable
as SpeedTestOutbound?,server: freezed == server ? _self.server : server // ignore: cast_nullable_to_non_nullable
as SpeedTestServer?,latency: null == latency ? _self.latency : latency // ignore: cast_nullable_to_non_nullable
as double,jitter: null == jitter ? _self.jitter : jitter // ignore: cast_nullable_to_non_nullable
as double,download: null == download ? _self.download : download // ignore: cast_nullable_to_non_nullable
as double,upload: null == upload ? _self.upload : upload // ignore: cast_nullable_to_non_nullable
as double,downloadLatency: null == downloadLatency ? _self.downloadLatency : downloadLatency // ignore: cast_nullable_to_non_nullable
as double,uploadLatency: null == uploadLatency ? _self.uploadLatency : uploadLatency // ignore: cast_nullable_to_non_nullable
as double,rpm: null == rpm ? _self.rpm : rpm // ignore: cast_nullable_to_non_nullable
as int,bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as int,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of SpeedTestState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpeedTestOutboundCopyWith<$Res>? get outbound {
    if (_self.outbound == null) {
    return null;
  }

  return $SpeedTestOutboundCopyWith<$Res>(_self.outbound!, (value) {
    return _then(_self.copyWith(outbound: value));
  });
}/// Create a copy of SpeedTestState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpeedTestServerCopyWith<$Res>? get server {
    if (_self.server == null) {
    return null;
  }

  return $SpeedTestServerCopyWith<$Res>(_self.server!, (value) {
    return _then(_self.copyWith(server: value));
  });
}
}


/// Adds pattern-matching-related methods to [SpeedTestState].
extension SpeedTestStatePatterns on SpeedTestState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpeedTestState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpeedTestState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpeedTestState value)  $default,){
final _that = this;
switch (_that) {
case _SpeedTestState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpeedTestState value)?  $default,){
final _that = this;
switch (_that) {
case _SpeedTestState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String provider,  String protocol,  bool fallback, @JsonKey(name: 'exit-ip')  String exitIp, @JsonKey(name: 'exit-info')  Map<String, dynamic>? exitInfo,  int streams,  int duration,  String phase,  double progress,  double speed,  bool direct,  SpeedTestOutbound? outbound,  SpeedTestServer? server,  double latency,  double jitter,  double download,  double upload, @JsonKey(name: 'download-latency')  double downloadLatency, @JsonKey(name: 'upload-latency')  double uploadLatency,  int rpm,  int bytes,  String error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpeedTestState() when $default != null:
return $default(_that.provider,_that.protocol,_that.fallback,_that.exitIp,_that.exitInfo,_that.streams,_that.duration,_that.phase,_that.progress,_that.speed,_that.direct,_that.outbound,_that.server,_that.latency,_that.jitter,_that.download,_that.upload,_that.downloadLatency,_that.uploadLatency,_that.rpm,_that.bytes,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String provider,  String protocol,  bool fallback, @JsonKey(name: 'exit-ip')  String exitIp, @JsonKey(name: 'exit-info')  Map<String, dynamic>? exitInfo,  int streams,  int duration,  String phase,  double progress,  double speed,  bool direct,  SpeedTestOutbound? outbound,  SpeedTestServer? server,  double latency,  double jitter,  double download,  double upload, @JsonKey(name: 'download-latency')  double downloadLatency, @JsonKey(name: 'upload-latency')  double uploadLatency,  int rpm,  int bytes,  String error)  $default,) {final _that = this;
switch (_that) {
case _SpeedTestState():
return $default(_that.provider,_that.protocol,_that.fallback,_that.exitIp,_that.exitInfo,_that.streams,_that.duration,_that.phase,_that.progress,_that.speed,_that.direct,_that.outbound,_that.server,_that.latency,_that.jitter,_that.download,_that.upload,_that.downloadLatency,_that.uploadLatency,_that.rpm,_that.bytes,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String provider,  String protocol,  bool fallback, @JsonKey(name: 'exit-ip')  String exitIp, @JsonKey(name: 'exit-info')  Map<String, dynamic>? exitInfo,  int streams,  int duration,  String phase,  double progress,  double speed,  bool direct,  SpeedTestOutbound? outbound,  SpeedTestServer? server,  double latency,  double jitter,  double download,  double upload, @JsonKey(name: 'download-latency')  double downloadLatency, @JsonKey(name: 'upload-latency')  double uploadLatency,  int rpm,  int bytes,  String error)?  $default,) {final _that = this;
switch (_that) {
case _SpeedTestState() when $default != null:
return $default(_that.provider,_that.protocol,_that.fallback,_that.exitIp,_that.exitInfo,_that.streams,_that.duration,_that.phase,_that.progress,_that.speed,_that.direct,_that.outbound,_that.server,_that.latency,_that.jitter,_that.download,_that.upload,_that.downloadLatency,_that.uploadLatency,_that.rpm,_that.bytes,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SpeedTestState implements SpeedTestState {
  const _SpeedTestState({this.provider = '', this.protocol = '', this.fallback = false, @JsonKey(name: 'exit-ip') this.exitIp = '', @JsonKey(name: 'exit-info')  Map<String, dynamic>? exitInfo, this.streams = 0, this.duration = 0, this.phase = '', this.progress = 0.0, this.speed = 0.0, this.direct = false, this.outbound, this.server, this.latency = 0.0, this.jitter = 0.0, this.download = 0.0, this.upload = 0.0, @JsonKey(name: 'download-latency') this.downloadLatency = 0.0, @JsonKey(name: 'upload-latency') this.uploadLatency = 0.0, this.rpm = 0, this.bytes = 0, this.error = ''}): _exitInfo = exitInfo;
  factory _SpeedTestState.fromJson(Map<String, dynamic> json) => _$SpeedTestStateFromJson(json);

@override@JsonKey() final  String provider;
@override@JsonKey() final  String protocol;
@override@JsonKey() final  bool fallback;
@override@JsonKey(name: 'exit-ip') final  String exitIp;
 final  Map<String, dynamic>? _exitInfo;
@override@JsonKey(name: 'exit-info') Map<String, dynamic>? get exitInfo {
  final value = _exitInfo;
  if (value == null) return null;
  if (_exitInfo is EqualUnmodifiableMapView) return _exitInfo;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey() final  int streams;
@override@JsonKey() final  int duration;
@override@JsonKey() final  String phase;
@override@JsonKey() final  double progress;
@override@JsonKey() final  double speed;
@override@JsonKey() final  bool direct;
@override final  SpeedTestOutbound? outbound;
@override final  SpeedTestServer? server;
@override@JsonKey() final  double latency;
@override@JsonKey() final  double jitter;
@override@JsonKey() final  double download;
@override@JsonKey() final  double upload;
@override@JsonKey(name: 'download-latency') final  double downloadLatency;
@override@JsonKey(name: 'upload-latency') final  double uploadLatency;
@override@JsonKey() final  int rpm;
@override@JsonKey() final  int bytes;
@override@JsonKey() final  String error;

/// Create a copy of SpeedTestState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpeedTestStateCopyWith<_SpeedTestState> get copyWith => __$SpeedTestStateCopyWithImpl<_SpeedTestState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpeedTestStateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpeedTestState&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.protocol, protocol) || other.protocol == protocol)&&(identical(other.fallback, fallback) || other.fallback == fallback)&&(identical(other.exitIp, exitIp) || other.exitIp == exitIp)&&const DeepCollectionEquality().equals(other.exitInfo, _exitInfo)&&(identical(other.streams, streams) || other.streams == streams)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.direct, direct) || other.direct == direct)&&(identical(other.outbound, outbound) || other.outbound == outbound)&&(identical(other.server, server) || other.server == server)&&(identical(other.latency, latency) || other.latency == latency)&&(identical(other.jitter, jitter) || other.jitter == jitter)&&(identical(other.download, download) || other.download == download)&&(identical(other.upload, upload) || other.upload == upload)&&(identical(other.downloadLatency, downloadLatency) || other.downloadLatency == downloadLatency)&&(identical(other.uploadLatency, uploadLatency) || other.uploadLatency == uploadLatency)&&(identical(other.rpm, rpm) || other.rpm == rpm)&&(identical(other.bytes, bytes) || other.bytes == bytes)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,provider,protocol,fallback,exitIp,const DeepCollectionEquality().hash(_exitInfo),streams,duration,phase,progress,speed,direct,outbound,server,latency,jitter,download,upload,downloadLatency,uploadLatency,rpm,bytes,error]);
}

@override
String toString() {
    return 'SpeedTestState(provider: $provider, protocol: $protocol, fallback: $fallback, exitIp: $exitIp, exitInfo: $exitInfo, streams: $streams, duration: $duration, phase: $phase, progress: $progress, speed: $speed, direct: $direct, outbound: $outbound, server: $server, latency: $latency, jitter: $jitter, download: $download, upload: $upload, downloadLatency: $downloadLatency, uploadLatency: $uploadLatency, rpm: $rpm, bytes: $bytes, error: $error)';
}


}

/// @nodoc
abstract mixin class _$SpeedTestStateCopyWith<$Res> implements $SpeedTestStateCopyWith<$Res> {
  factory _$SpeedTestStateCopyWith(_SpeedTestState value, $Res Function(_SpeedTestState) _then) = __$SpeedTestStateCopyWithImpl;
@override @useResult
$Res call({
 String provider, String protocol, bool fallback,@JsonKey(name: 'exit-ip') String exitIp,@JsonKey(name: 'exit-info') Map<String, dynamic>? exitInfo, int streams, int duration, String phase, double progress, double speed, bool direct, SpeedTestOutbound? outbound, SpeedTestServer? server, double latency, double jitter, double download, double upload,@JsonKey(name: 'download-latency') double downloadLatency,@JsonKey(name: 'upload-latency') double uploadLatency, int rpm, int bytes, String error
});


@override $SpeedTestOutboundCopyWith<$Res>? get outbound;@override $SpeedTestServerCopyWith<$Res>? get server;

}
/// @nodoc
class __$SpeedTestStateCopyWithImpl<$Res>
    implements _$SpeedTestStateCopyWith<$Res> {
  __$SpeedTestStateCopyWithImpl(this._self, this._then);

  final _SpeedTestState _self;
  final $Res Function(_SpeedTestState) _then;

/// Create a copy of SpeedTestState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? provider = null,Object? protocol = null,Object? fallback = null,Object? exitIp = null,Object? exitInfo = freezed,Object? streams = null,Object? duration = null,Object? phase = null,Object? progress = null,Object? speed = null,Object? direct = null,Object? outbound = freezed,Object? server = freezed,Object? latency = null,Object? jitter = null,Object? download = null,Object? upload = null,Object? downloadLatency = null,Object? uploadLatency = null,Object? rpm = null,Object? bytes = null,Object? error = null,}) {
  return _then(_SpeedTestState(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,protocol: null == protocol ? _self.protocol : protocol // ignore: cast_nullable_to_non_nullable
as String,fallback: null == fallback ? _self.fallback : fallback // ignore: cast_nullable_to_non_nullable
as bool,exitIp: null == exitIp ? _self.exitIp : exitIp // ignore: cast_nullable_to_non_nullable
as String,exitInfo: freezed == exitInfo ? _self._exitInfo : exitInfo // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,streams: null == streams ? _self.streams : streams // ignore: cast_nullable_to_non_nullable
as int,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as String,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,direct: null == direct ? _self.direct : direct // ignore: cast_nullable_to_non_nullable
as bool,outbound: freezed == outbound ? _self.outbound : outbound // ignore: cast_nullable_to_non_nullable
as SpeedTestOutbound?,server: freezed == server ? _self.server : server // ignore: cast_nullable_to_non_nullable
as SpeedTestServer?,latency: null == latency ? _self.latency : latency // ignore: cast_nullable_to_non_nullable
as double,jitter: null == jitter ? _self.jitter : jitter // ignore: cast_nullable_to_non_nullable
as double,download: null == download ? _self.download : download // ignore: cast_nullable_to_non_nullable
as double,upload: null == upload ? _self.upload : upload // ignore: cast_nullable_to_non_nullable
as double,downloadLatency: null == downloadLatency ? _self.downloadLatency : downloadLatency // ignore: cast_nullable_to_non_nullable
as double,uploadLatency: null == uploadLatency ? _self.uploadLatency : uploadLatency // ignore: cast_nullable_to_non_nullable
as double,rpm: null == rpm ? _self.rpm : rpm // ignore: cast_nullable_to_non_nullable
as int,bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as int,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of SpeedTestState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpeedTestOutboundCopyWith<$Res>? get outbound {
    if (_self.outbound == null) {
    return null;
  }

  return $SpeedTestOutboundCopyWith<$Res>(_self.outbound!, (value) {
    return _then(_self.copyWith(outbound: value));
  });
}/// Create a copy of SpeedTestState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpeedTestServerCopyWith<$Res>? get server {
    if (_self.server == null) {
    return null;
  }

  return $SpeedTestServerCopyWith<$Res>(_self.server!, (value) {
    return _then(_self.copyWith(server: value));
  });
}
}


/// @nodoc
mixin _$RouteTraceParams {

 String get target; String get network; int get port;
/// Create a copy of RouteTraceParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteTraceParamsCopyWith<RouteTraceParams> get copyWith => _$RouteTraceParamsCopyWithImpl<RouteTraceParams>(this as RouteTraceParams, _$identity);

  /// Serializes this RouteTraceParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RouteTraceParams;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteTraceParams&&(identical(other.target, _this.target) || other.target == _this.target)&&(identical(other.network, _this.network) || other.network == _this.network)&&(identical(other.port, _this.port) || other.port == _this.port));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RouteTraceParams;
  return Object.hash(runtimeType,_this.target,_this.network,_this.port);
}

@override
String toString() {
  final _this = this as RouteTraceParams;
  return 'RouteTraceParams(target: ${_this.target}, network: ${_this.network}, port: ${_this.port})';
}


}

/// @nodoc
abstract mixin class $RouteTraceParamsCopyWith<$Res>  {
  factory $RouteTraceParamsCopyWith(RouteTraceParams value, $Res Function(RouteTraceParams) _then) = _$RouteTraceParamsCopyWithImpl;
@useResult
$Res call({
 String target, String network, int port
});




}
/// @nodoc
class _$RouteTraceParamsCopyWithImpl<$Res>
    implements $RouteTraceParamsCopyWith<$Res> {
  _$RouteTraceParamsCopyWithImpl(this._self, this._then);

  final RouteTraceParams _self;
  final $Res Function(RouteTraceParams) _then;

/// Create a copy of RouteTraceParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? target = null,Object? network = null,Object? port = null,}) {
  return _then(RouteTraceParams(
target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,network: null == network ? _self.network : network // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteTraceParams].
extension RouteTraceParamsPatterns on RouteTraceParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteTraceParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteTraceParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteTraceParams value)  $default,){
final _that = this;
switch (_that) {
case _RouteTraceParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteTraceParams value)?  $default,){
final _that = this;
switch (_that) {
case _RouteTraceParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String target,  String network,  int port)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteTraceParams() when $default != null:
return $default(_that.target,_that.network,_that.port);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String target,  String network,  int port)  $default,) {final _that = this;
switch (_that) {
case _RouteTraceParams():
return $default(_that.target,_that.network,_that.port);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String target,  String network,  int port)?  $default,) {final _that = this;
switch (_that) {
case _RouteTraceParams() when $default != null:
return $default(_that.target,_that.network,_that.port);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteTraceParams implements RouteTraceParams {
  const _RouteTraceParams({required this.target, this.network = 'tcp', this.port = 443});
  factory _RouteTraceParams.fromJson(Map<String, dynamic> json) => _$RouteTraceParamsFromJson(json);

@override final  String target;
@override@JsonKey() final  String network;
@override@JsonKey() final  int port;

/// Create a copy of RouteTraceParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteTraceParamsCopyWith<_RouteTraceParams> get copyWith => __$RouteTraceParamsCopyWithImpl<_RouteTraceParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteTraceParamsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteTraceParams&&(identical(other.target, target) || other.target == target)&&(identical(other.network, network) || other.network == network)&&(identical(other.port, port) || other.port == port));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,target,network,port);
}

@override
String toString() {
    return 'RouteTraceParams(target: $target, network: $network, port: $port)';
}


}

/// @nodoc
abstract mixin class _$RouteTraceParamsCopyWith<$Res> implements $RouteTraceParamsCopyWith<$Res> {
  factory _$RouteTraceParamsCopyWith(_RouteTraceParams value, $Res Function(_RouteTraceParams) _then) = __$RouteTraceParamsCopyWithImpl;
@override @useResult
$Res call({
 String target, String network, int port
});




}
/// @nodoc
class __$RouteTraceParamsCopyWithImpl<$Res>
    implements _$RouteTraceParamsCopyWith<$Res> {
  __$RouteTraceParamsCopyWithImpl(this._self, this._then);

  final _RouteTraceParams _self;
  final $Res Function(_RouteTraceParams) _then;

/// Create a copy of RouteTraceParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? target = null,Object? network = null,Object? port = null,}) {
  return _then(_RouteTraceParams(
target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,network: null == network ? _self.network : network // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$RouteTraceStep {

 int get index; String get type; String get payload; String get adapter; bool get matched; bool get resolve; String get skipped; int get duration;
/// Create a copy of RouteTraceStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteTraceStepCopyWith<RouteTraceStep> get copyWith => _$RouteTraceStepCopyWithImpl<RouteTraceStep>(this as RouteTraceStep, _$identity);

  /// Serializes this RouteTraceStep to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RouteTraceStep;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteTraceStep&&(identical(other.index, _this.index) || other.index == _this.index)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.payload, _this.payload) || other.payload == _this.payload)&&(identical(other.adapter, _this.adapter) || other.adapter == _this.adapter)&&(identical(other.matched, _this.matched) || other.matched == _this.matched)&&(identical(other.resolve, _this.resolve) || other.resolve == _this.resolve)&&(identical(other.skipped, _this.skipped) || other.skipped == _this.skipped)&&(identical(other.duration, _this.duration) || other.duration == _this.duration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RouteTraceStep;
  return Object.hash(runtimeType,_this.index,_this.type,_this.payload,_this.adapter,_this.matched,_this.resolve,_this.skipped,_this.duration);
}

@override
String toString() {
  final _this = this as RouteTraceStep;
  return 'RouteTraceStep(index: ${_this.index}, type: ${_this.type}, payload: ${_this.payload}, adapter: ${_this.adapter}, matched: ${_this.matched}, resolve: ${_this.resolve}, skipped: ${_this.skipped}, duration: ${_this.duration})';
}


}

/// @nodoc
abstract mixin class $RouteTraceStepCopyWith<$Res>  {
  factory $RouteTraceStepCopyWith(RouteTraceStep value, $Res Function(RouteTraceStep) _then) = _$RouteTraceStepCopyWithImpl;
@useResult
$Res call({
 int index, String type, String payload, String adapter, bool matched, bool resolve, String skipped, int duration
});




}
/// @nodoc
class _$RouteTraceStepCopyWithImpl<$Res>
    implements $RouteTraceStepCopyWith<$Res> {
  _$RouteTraceStepCopyWithImpl(this._self, this._then);

  final RouteTraceStep _self;
  final $Res Function(RouteTraceStep) _then;

/// Create a copy of RouteTraceStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? index = null,Object? type = null,Object? payload = null,Object? adapter = null,Object? matched = null,Object? resolve = null,Object? skipped = null,Object? duration = null,}) {
  return _then(RouteTraceStep(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as String,adapter: null == adapter ? _self.adapter : adapter // ignore: cast_nullable_to_non_nullable
as String,matched: null == matched ? _self.matched : matched // ignore: cast_nullable_to_non_nullable
as bool,resolve: null == resolve ? _self.resolve : resolve // ignore: cast_nullable_to_non_nullable
as bool,skipped: null == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteTraceStep].
extension RouteTraceStepPatterns on RouteTraceStep {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteTraceStep value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteTraceStep() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteTraceStep value)  $default,){
final _that = this;
switch (_that) {
case _RouteTraceStep():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteTraceStep value)?  $default,){
final _that = this;
switch (_that) {
case _RouteTraceStep() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int index,  String type,  String payload,  String adapter,  bool matched,  bool resolve,  String skipped,  int duration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteTraceStep() when $default != null:
return $default(_that.index,_that.type,_that.payload,_that.adapter,_that.matched,_that.resolve,_that.skipped,_that.duration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int index,  String type,  String payload,  String adapter,  bool matched,  bool resolve,  String skipped,  int duration)  $default,) {final _that = this;
switch (_that) {
case _RouteTraceStep():
return $default(_that.index,_that.type,_that.payload,_that.adapter,_that.matched,_that.resolve,_that.skipped,_that.duration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int index,  String type,  String payload,  String adapter,  bool matched,  bool resolve,  String skipped,  int duration)?  $default,) {final _that = this;
switch (_that) {
case _RouteTraceStep() when $default != null:
return $default(_that.index,_that.type,_that.payload,_that.adapter,_that.matched,_that.resolve,_that.skipped,_that.duration);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteTraceStep implements RouteTraceStep {
  const _RouteTraceStep({this.index = 0, this.type = '', this.payload = '', this.adapter = '', this.matched = false, this.resolve = false, this.skipped = '', this.duration = 0});
  factory _RouteTraceStep.fromJson(Map<String, dynamic> json) => _$RouteTraceStepFromJson(json);

@override@JsonKey() final  int index;
@override@JsonKey() final  String type;
@override@JsonKey() final  String payload;
@override@JsonKey() final  String adapter;
@override@JsonKey() final  bool matched;
@override@JsonKey() final  bool resolve;
@override@JsonKey() final  String skipped;
@override@JsonKey() final  int duration;

/// Create a copy of RouteTraceStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteTraceStepCopyWith<_RouteTraceStep> get copyWith => __$RouteTraceStepCopyWithImpl<_RouteTraceStep>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteTraceStepToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteTraceStep&&(identical(other.index, index) || other.index == index)&&(identical(other.type, type) || other.type == type)&&(identical(other.payload, payload) || other.payload == payload)&&(identical(other.adapter, adapter) || other.adapter == adapter)&&(identical(other.matched, matched) || other.matched == matched)&&(identical(other.resolve, resolve) || other.resolve == resolve)&&(identical(other.skipped, skipped) || other.skipped == skipped)&&(identical(other.duration, duration) || other.duration == duration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,index,type,payload,adapter,matched,resolve,skipped,duration);
}

@override
String toString() {
    return 'RouteTraceStep(index: $index, type: $type, payload: $payload, adapter: $adapter, matched: $matched, resolve: $resolve, skipped: $skipped, duration: $duration)';
}


}

/// @nodoc
abstract mixin class _$RouteTraceStepCopyWith<$Res> implements $RouteTraceStepCopyWith<$Res> {
  factory _$RouteTraceStepCopyWith(_RouteTraceStep value, $Res Function(_RouteTraceStep) _then) = __$RouteTraceStepCopyWithImpl;
@override @useResult
$Res call({
 int index, String type, String payload, String adapter, bool matched, bool resolve, String skipped, int duration
});




}
/// @nodoc
class __$RouteTraceStepCopyWithImpl<$Res>
    implements _$RouteTraceStepCopyWith<$Res> {
  __$RouteTraceStepCopyWithImpl(this._self, this._then);

  final _RouteTraceStep _self;
  final $Res Function(_RouteTraceStep) _then;

/// Create a copy of RouteTraceStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? index = null,Object? type = null,Object? payload = null,Object? adapter = null,Object? matched = null,Object? resolve = null,Object? skipped = null,Object? duration = null,}) {
  return _then(_RouteTraceStep(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as String,adapter: null == adapter ? _self.adapter : adapter // ignore: cast_nullable_to_non_nullable
as String,matched: null == matched ? _self.matched : matched // ignore: cast_nullable_to_non_nullable
as bool,resolve: null == resolve ? _self.resolve : resolve // ignore: cast_nullable_to_non_nullable
as bool,skipped: null == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$RouteTraceChain {

 String get name; String get type;
/// Create a copy of RouteTraceChain
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteTraceChainCopyWith<RouteTraceChain> get copyWith => _$RouteTraceChainCopyWithImpl<RouteTraceChain>(this as RouteTraceChain, _$identity);

  /// Serializes this RouteTraceChain to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RouteTraceChain;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteTraceChain&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RouteTraceChain;
  return Object.hash(runtimeType,_this.name,_this.type);
}

@override
String toString() {
  final _this = this as RouteTraceChain;
  return 'RouteTraceChain(name: ${_this.name}, type: ${_this.type})';
}


}

/// @nodoc
abstract mixin class $RouteTraceChainCopyWith<$Res>  {
  factory $RouteTraceChainCopyWith(RouteTraceChain value, $Res Function(RouteTraceChain) _then) = _$RouteTraceChainCopyWithImpl;
@useResult
$Res call({
 String name, String type
});




}
/// @nodoc
class _$RouteTraceChainCopyWithImpl<$Res>
    implements $RouteTraceChainCopyWith<$Res> {
  _$RouteTraceChainCopyWithImpl(this._self, this._then);

  final RouteTraceChain _self;
  final $Res Function(RouteTraceChain) _then;

/// Create a copy of RouteTraceChain
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? type = null,}) {
  return _then(RouteTraceChain(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteTraceChain].
extension RouteTraceChainPatterns on RouteTraceChain {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteTraceChain value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteTraceChain() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteTraceChain value)  $default,){
final _that = this;
switch (_that) {
case _RouteTraceChain():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteTraceChain value)?  $default,){
final _that = this;
switch (_that) {
case _RouteTraceChain() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteTraceChain() when $default != null:
return $default(_that.name,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String type)  $default,) {final _that = this;
switch (_that) {
case _RouteTraceChain():
return $default(_that.name,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String type)?  $default,) {final _that = this;
switch (_that) {
case _RouteTraceChain() when $default != null:
return $default(_that.name,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteTraceChain implements RouteTraceChain {
  const _RouteTraceChain({this.name = '', this.type = ''});
  factory _RouteTraceChain.fromJson(Map<String, dynamic> json) => _$RouteTraceChainFromJson(json);

@override@JsonKey() final  String name;
@override@JsonKey() final  String type;

/// Create a copy of RouteTraceChain
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteTraceChainCopyWith<_RouteTraceChain> get copyWith => __$RouteTraceChainCopyWithImpl<_RouteTraceChain>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteTraceChainToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteTraceChain&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,type);
}

@override
String toString() {
    return 'RouteTraceChain(name: $name, type: $type)';
}


}

/// @nodoc
abstract mixin class _$RouteTraceChainCopyWith<$Res> implements $RouteTraceChainCopyWith<$Res> {
  factory _$RouteTraceChainCopyWith(_RouteTraceChain value, $Res Function(_RouteTraceChain) _then) = __$RouteTraceChainCopyWithImpl;
@override @useResult
$Res call({
 String name, String type
});




}
/// @nodoc
class __$RouteTraceChainCopyWithImpl<$Res>
    implements _$RouteTraceChainCopyWith<$Res> {
  __$RouteTraceChainCopyWithImpl(this._self, this._then);

  final _RouteTraceChain _self;
  final $Res Function(_RouteTraceChain) _then;

/// Create a copy of RouteTraceChain
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? type = null,}) {
  return _then(_RouteTraceChain(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RouteTraceResult {

 String get target; String get host; String get network; int get port; String get mode;@JsonKey(name: 'dns-mode') String get dnsMode;@JsonKey(name: 'hosts-ips') List<String> get hostsIps;@JsonKey(name: 'resolved-ips') List<String> get resolvedIps;@JsonKey(name: 'resolve-time') double get resolveTime;@JsonKey(name: 'resolve-error') String get resolveError;@JsonKey(name: 'resolved-by') int get resolvedBy;@JsonKey(name: 'dst-ip') String get dstIp; int get total; int get checked; bool get truncated; List<RouteTraceStep> get steps; RouteTraceStep? get matched; List<RouteTraceChain> get chains;@JsonKey(name: 'support-udp') bool get supportUdp;@JsonKey(name: 'match-time') double get matchTime; String get error;@JsonKey(name: 'fallback-direct') bool get fallbackDirect;
/// Create a copy of RouteTraceResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteTraceResultCopyWith<RouteTraceResult> get copyWith => _$RouteTraceResultCopyWithImpl<RouteTraceResult>(this as RouteTraceResult, _$identity);

  /// Serializes this RouteTraceResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RouteTraceResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteTraceResult&&(identical(other.target, _this.target) || other.target == _this.target)&&(identical(other.host, _this.host) || other.host == _this.host)&&(identical(other.network, _this.network) || other.network == _this.network)&&(identical(other.port, _this.port) || other.port == _this.port)&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.dnsMode, _this.dnsMode) || other.dnsMode == _this.dnsMode)&&const DeepCollectionEquality().equals(other.hostsIps, _this.hostsIps)&&const DeepCollectionEquality().equals(other.resolvedIps, _this.resolvedIps)&&(identical(other.resolveTime, _this.resolveTime) || other.resolveTime == _this.resolveTime)&&(identical(other.resolveError, _this.resolveError) || other.resolveError == _this.resolveError)&&(identical(other.resolvedBy, _this.resolvedBy) || other.resolvedBy == _this.resolvedBy)&&(identical(other.dstIp, _this.dstIp) || other.dstIp == _this.dstIp)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.checked, _this.checked) || other.checked == _this.checked)&&(identical(other.truncated, _this.truncated) || other.truncated == _this.truncated)&&const DeepCollectionEquality().equals(other.steps, _this.steps)&&(identical(other.matched, _this.matched) || other.matched == _this.matched)&&const DeepCollectionEquality().equals(other.chains, _this.chains)&&(identical(other.supportUdp, _this.supportUdp) || other.supportUdp == _this.supportUdp)&&(identical(other.matchTime, _this.matchTime) || other.matchTime == _this.matchTime)&&(identical(other.error, _this.error) || other.error == _this.error)&&(identical(other.fallbackDirect, _this.fallbackDirect) || other.fallbackDirect == _this.fallbackDirect));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RouteTraceResult;
  return Object.hashAll([runtimeType,_this.target,_this.host,_this.network,_this.port,_this.mode,_this.dnsMode,const DeepCollectionEquality().hash(_this.hostsIps),const DeepCollectionEquality().hash(_this.resolvedIps),_this.resolveTime,_this.resolveError,_this.resolvedBy,_this.dstIp,_this.total,_this.checked,_this.truncated,const DeepCollectionEquality().hash(_this.steps),_this.matched,const DeepCollectionEquality().hash(_this.chains),_this.supportUdp,_this.matchTime,_this.error,_this.fallbackDirect]);
}

@override
String toString() {
  final _this = this as RouteTraceResult;
  return 'RouteTraceResult(target: ${_this.target}, host: ${_this.host}, network: ${_this.network}, port: ${_this.port}, mode: ${_this.mode}, dnsMode: ${_this.dnsMode}, hostsIps: ${_this.hostsIps}, resolvedIps: ${_this.resolvedIps}, resolveTime: ${_this.resolveTime}, resolveError: ${_this.resolveError}, resolvedBy: ${_this.resolvedBy}, dstIp: ${_this.dstIp}, total: ${_this.total}, checked: ${_this.checked}, truncated: ${_this.truncated}, steps: ${_this.steps}, matched: ${_this.matched}, chains: ${_this.chains}, supportUdp: ${_this.supportUdp}, matchTime: ${_this.matchTime}, error: ${_this.error}, fallbackDirect: ${_this.fallbackDirect})';
}


}

/// @nodoc
abstract mixin class $RouteTraceResultCopyWith<$Res>  {
  factory $RouteTraceResultCopyWith(RouteTraceResult value, $Res Function(RouteTraceResult) _then) = _$RouteTraceResultCopyWithImpl;
@useResult
$Res call({
 String target, String host, String network, int port, String mode,@JsonKey(name: 'dns-mode') String dnsMode,@JsonKey(name: 'hosts-ips') List<String> hostsIps,@JsonKey(name: 'resolved-ips') List<String> resolvedIps,@JsonKey(name: 'resolve-time') double resolveTime,@JsonKey(name: 'resolve-error') String resolveError,@JsonKey(name: 'resolved-by') int resolvedBy,@JsonKey(name: 'dst-ip') String dstIp, int total, int checked, bool truncated, List<RouteTraceStep> steps, RouteTraceStep? matched, List<RouteTraceChain> chains,@JsonKey(name: 'support-udp') bool supportUdp,@JsonKey(name: 'match-time') double matchTime, String error,@JsonKey(name: 'fallback-direct') bool fallbackDirect
});


$RouteTraceStepCopyWith<$Res>? get matched;

}
/// @nodoc
class _$RouteTraceResultCopyWithImpl<$Res>
    implements $RouteTraceResultCopyWith<$Res> {
  _$RouteTraceResultCopyWithImpl(this._self, this._then);

  final RouteTraceResult _self;
  final $Res Function(RouteTraceResult) _then;

/// Create a copy of RouteTraceResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? target = null,Object? host = null,Object? network = null,Object? port = null,Object? mode = null,Object? dnsMode = null,Object? hostsIps = null,Object? resolvedIps = null,Object? resolveTime = null,Object? resolveError = null,Object? resolvedBy = null,Object? dstIp = null,Object? total = null,Object? checked = null,Object? truncated = null,Object? steps = null,Object? matched = freezed,Object? chains = null,Object? supportUdp = null,Object? matchTime = null,Object? error = null,Object? fallbackDirect = null,}) {
  return _then(RouteTraceResult(
target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,network: null == network ? _self.network : network // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,dnsMode: null == dnsMode ? _self.dnsMode : dnsMode // ignore: cast_nullable_to_non_nullable
as String,hostsIps: null == hostsIps ? _self.hostsIps : hostsIps // ignore: cast_nullable_to_non_nullable
as List<String>,resolvedIps: null == resolvedIps ? _self.resolvedIps : resolvedIps // ignore: cast_nullable_to_non_nullable
as List<String>,resolveTime: null == resolveTime ? _self.resolveTime : resolveTime // ignore: cast_nullable_to_non_nullable
as double,resolveError: null == resolveError ? _self.resolveError : resolveError // ignore: cast_nullable_to_non_nullable
as String,resolvedBy: null == resolvedBy ? _self.resolvedBy : resolvedBy // ignore: cast_nullable_to_non_nullable
as int,dstIp: null == dstIp ? _self.dstIp : dstIp // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,checked: null == checked ? _self.checked : checked // ignore: cast_nullable_to_non_nullable
as int,truncated: null == truncated ? _self.truncated : truncated // ignore: cast_nullable_to_non_nullable
as bool,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<RouteTraceStep>,matched: freezed == matched ? _self.matched : matched // ignore: cast_nullable_to_non_nullable
as RouteTraceStep?,chains: null == chains ? _self.chains : chains // ignore: cast_nullable_to_non_nullable
as List<RouteTraceChain>,supportUdp: null == supportUdp ? _self.supportUdp : supportUdp // ignore: cast_nullable_to_non_nullable
as bool,matchTime: null == matchTime ? _self.matchTime : matchTime // ignore: cast_nullable_to_non_nullable
as double,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,fallbackDirect: null == fallbackDirect ? _self.fallbackDirect : fallbackDirect // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of RouteTraceResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteTraceStepCopyWith<$Res>? get matched {
    if (_self.matched == null) {
    return null;
  }

  return $RouteTraceStepCopyWith<$Res>(_self.matched!, (value) {
    return _then(_self.copyWith(matched: value));
  });
}
}


/// Adds pattern-matching-related methods to [RouteTraceResult].
extension RouteTraceResultPatterns on RouteTraceResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteTraceResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteTraceResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteTraceResult value)  $default,){
final _that = this;
switch (_that) {
case _RouteTraceResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteTraceResult value)?  $default,){
final _that = this;
switch (_that) {
case _RouteTraceResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String target,  String host,  String network,  int port,  String mode, @JsonKey(name: 'dns-mode')  String dnsMode, @JsonKey(name: 'hosts-ips')  List<String> hostsIps, @JsonKey(name: 'resolved-ips')  List<String> resolvedIps, @JsonKey(name: 'resolve-time')  double resolveTime, @JsonKey(name: 'resolve-error')  String resolveError, @JsonKey(name: 'resolved-by')  int resolvedBy, @JsonKey(name: 'dst-ip')  String dstIp,  int total,  int checked,  bool truncated,  List<RouteTraceStep> steps,  RouteTraceStep? matched,  List<RouteTraceChain> chains, @JsonKey(name: 'support-udp')  bool supportUdp, @JsonKey(name: 'match-time')  double matchTime,  String error, @JsonKey(name: 'fallback-direct')  bool fallbackDirect)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteTraceResult() when $default != null:
return $default(_that.target,_that.host,_that.network,_that.port,_that.mode,_that.dnsMode,_that.hostsIps,_that.resolvedIps,_that.resolveTime,_that.resolveError,_that.resolvedBy,_that.dstIp,_that.total,_that.checked,_that.truncated,_that.steps,_that.matched,_that.chains,_that.supportUdp,_that.matchTime,_that.error,_that.fallbackDirect);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String target,  String host,  String network,  int port,  String mode, @JsonKey(name: 'dns-mode')  String dnsMode, @JsonKey(name: 'hosts-ips')  List<String> hostsIps, @JsonKey(name: 'resolved-ips')  List<String> resolvedIps, @JsonKey(name: 'resolve-time')  double resolveTime, @JsonKey(name: 'resolve-error')  String resolveError, @JsonKey(name: 'resolved-by')  int resolvedBy, @JsonKey(name: 'dst-ip')  String dstIp,  int total,  int checked,  bool truncated,  List<RouteTraceStep> steps,  RouteTraceStep? matched,  List<RouteTraceChain> chains, @JsonKey(name: 'support-udp')  bool supportUdp, @JsonKey(name: 'match-time')  double matchTime,  String error, @JsonKey(name: 'fallback-direct')  bool fallbackDirect)  $default,) {final _that = this;
switch (_that) {
case _RouteTraceResult():
return $default(_that.target,_that.host,_that.network,_that.port,_that.mode,_that.dnsMode,_that.hostsIps,_that.resolvedIps,_that.resolveTime,_that.resolveError,_that.resolvedBy,_that.dstIp,_that.total,_that.checked,_that.truncated,_that.steps,_that.matched,_that.chains,_that.supportUdp,_that.matchTime,_that.error,_that.fallbackDirect);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String target,  String host,  String network,  int port,  String mode, @JsonKey(name: 'dns-mode')  String dnsMode, @JsonKey(name: 'hosts-ips')  List<String> hostsIps, @JsonKey(name: 'resolved-ips')  List<String> resolvedIps, @JsonKey(name: 'resolve-time')  double resolveTime, @JsonKey(name: 'resolve-error')  String resolveError, @JsonKey(name: 'resolved-by')  int resolvedBy, @JsonKey(name: 'dst-ip')  String dstIp,  int total,  int checked,  bool truncated,  List<RouteTraceStep> steps,  RouteTraceStep? matched,  List<RouteTraceChain> chains, @JsonKey(name: 'support-udp')  bool supportUdp, @JsonKey(name: 'match-time')  double matchTime,  String error, @JsonKey(name: 'fallback-direct')  bool fallbackDirect)?  $default,) {final _that = this;
switch (_that) {
case _RouteTraceResult() when $default != null:
return $default(_that.target,_that.host,_that.network,_that.port,_that.mode,_that.dnsMode,_that.hostsIps,_that.resolvedIps,_that.resolveTime,_that.resolveError,_that.resolvedBy,_that.dstIp,_that.total,_that.checked,_that.truncated,_that.steps,_that.matched,_that.chains,_that.supportUdp,_that.matchTime,_that.error,_that.fallbackDirect);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteTraceResult implements RouteTraceResult {
  const _RouteTraceResult({this.target = '', this.host = '', this.network = '', this.port = 0, this.mode = '', @JsonKey(name: 'dns-mode') this.dnsMode = '', @JsonKey(name: 'hosts-ips')  List<String> hostsIps = const [], @JsonKey(name: 'resolved-ips')  List<String> resolvedIps = const [], @JsonKey(name: 'resolve-time') this.resolveTime = 0.0, @JsonKey(name: 'resolve-error') this.resolveError = '', @JsonKey(name: 'resolved-by') this.resolvedBy = 0, @JsonKey(name: 'dst-ip') this.dstIp = '', this.total = 0, this.checked = 0, this.truncated = false,  List<RouteTraceStep> steps = const [], this.matched,  List<RouteTraceChain> chains = const [], @JsonKey(name: 'support-udp') this.supportUdp = false, @JsonKey(name: 'match-time') this.matchTime = 0.0, this.error = '', @JsonKey(name: 'fallback-direct') this.fallbackDirect = false}): _hostsIps = hostsIps,_resolvedIps = resolvedIps,_steps = steps,_chains = chains;
  factory _RouteTraceResult.fromJson(Map<String, dynamic> json) => _$RouteTraceResultFromJson(json);

@override@JsonKey() final  String target;
@override@JsonKey() final  String host;
@override@JsonKey() final  String network;
@override@JsonKey() final  int port;
@override@JsonKey() final  String mode;
@override@JsonKey(name: 'dns-mode') final  String dnsMode;
 final  List<String> _hostsIps;
@override@JsonKey(name: 'hosts-ips') List<String> get hostsIps {
  if (_hostsIps is EqualUnmodifiableListView) return _hostsIps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hostsIps);
}

 final  List<String> _resolvedIps;
@override@JsonKey(name: 'resolved-ips') List<String> get resolvedIps {
  if (_resolvedIps is EqualUnmodifiableListView) return _resolvedIps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_resolvedIps);
}

@override@JsonKey(name: 'resolve-time') final  double resolveTime;
@override@JsonKey(name: 'resolve-error') final  String resolveError;
@override@JsonKey(name: 'resolved-by') final  int resolvedBy;
@override@JsonKey(name: 'dst-ip') final  String dstIp;
@override@JsonKey() final  int total;
@override@JsonKey() final  int checked;
@override@JsonKey() final  bool truncated;
 final  List<RouteTraceStep> _steps;
@override@JsonKey() List<RouteTraceStep> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}

@override final  RouteTraceStep? matched;
 final  List<RouteTraceChain> _chains;
@override@JsonKey() List<RouteTraceChain> get chains {
  if (_chains is EqualUnmodifiableListView) return _chains;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chains);
}

@override@JsonKey(name: 'support-udp') final  bool supportUdp;
@override@JsonKey(name: 'match-time') final  double matchTime;
@override@JsonKey() final  String error;
@override@JsonKey(name: 'fallback-direct') final  bool fallbackDirect;

/// Create a copy of RouteTraceResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteTraceResultCopyWith<_RouteTraceResult> get copyWith => __$RouteTraceResultCopyWithImpl<_RouteTraceResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteTraceResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteTraceResult&&(identical(other.target, target) || other.target == target)&&(identical(other.host, host) || other.host == host)&&(identical(other.network, network) || other.network == network)&&(identical(other.port, port) || other.port == port)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.dnsMode, dnsMode) || other.dnsMode == dnsMode)&&const DeepCollectionEquality().equals(other.hostsIps, _hostsIps)&&const DeepCollectionEquality().equals(other.resolvedIps, _resolvedIps)&&(identical(other.resolveTime, resolveTime) || other.resolveTime == resolveTime)&&(identical(other.resolveError, resolveError) || other.resolveError == resolveError)&&(identical(other.resolvedBy, resolvedBy) || other.resolvedBy == resolvedBy)&&(identical(other.dstIp, dstIp) || other.dstIp == dstIp)&&(identical(other.total, total) || other.total == total)&&(identical(other.checked, checked) || other.checked == checked)&&(identical(other.truncated, truncated) || other.truncated == truncated)&&const DeepCollectionEquality().equals(other.steps, _steps)&&(identical(other.matched, matched) || other.matched == matched)&&const DeepCollectionEquality().equals(other.chains, _chains)&&(identical(other.supportUdp, supportUdp) || other.supportUdp == supportUdp)&&(identical(other.matchTime, matchTime) || other.matchTime == matchTime)&&(identical(other.error, error) || other.error == error)&&(identical(other.fallbackDirect, fallbackDirect) || other.fallbackDirect == fallbackDirect));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,target,host,network,port,mode,dnsMode,const DeepCollectionEquality().hash(_hostsIps),const DeepCollectionEquality().hash(_resolvedIps),resolveTime,resolveError,resolvedBy,dstIp,total,checked,truncated,const DeepCollectionEquality().hash(_steps),matched,const DeepCollectionEquality().hash(_chains),supportUdp,matchTime,error,fallbackDirect]);
}

@override
String toString() {
    return 'RouteTraceResult(target: $target, host: $host, network: $network, port: $port, mode: $mode, dnsMode: $dnsMode, hostsIps: $hostsIps, resolvedIps: $resolvedIps, resolveTime: $resolveTime, resolveError: $resolveError, resolvedBy: $resolvedBy, dstIp: $dstIp, total: $total, checked: $checked, truncated: $truncated, steps: $steps, matched: $matched, chains: $chains, supportUdp: $supportUdp, matchTime: $matchTime, error: $error, fallbackDirect: $fallbackDirect)';
}


}

/// @nodoc
abstract mixin class _$RouteTraceResultCopyWith<$Res> implements $RouteTraceResultCopyWith<$Res> {
  factory _$RouteTraceResultCopyWith(_RouteTraceResult value, $Res Function(_RouteTraceResult) _then) = __$RouteTraceResultCopyWithImpl;
@override @useResult
$Res call({
 String target, String host, String network, int port, String mode,@JsonKey(name: 'dns-mode') String dnsMode,@JsonKey(name: 'hosts-ips') List<String> hostsIps,@JsonKey(name: 'resolved-ips') List<String> resolvedIps,@JsonKey(name: 'resolve-time') double resolveTime,@JsonKey(name: 'resolve-error') String resolveError,@JsonKey(name: 'resolved-by') int resolvedBy,@JsonKey(name: 'dst-ip') String dstIp, int total, int checked, bool truncated, List<RouteTraceStep> steps, RouteTraceStep? matched, List<RouteTraceChain> chains,@JsonKey(name: 'support-udp') bool supportUdp,@JsonKey(name: 'match-time') double matchTime, String error,@JsonKey(name: 'fallback-direct') bool fallbackDirect
});


@override $RouteTraceStepCopyWith<$Res>? get matched;

}
/// @nodoc
class __$RouteTraceResultCopyWithImpl<$Res>
    implements _$RouteTraceResultCopyWith<$Res> {
  __$RouteTraceResultCopyWithImpl(this._self, this._then);

  final _RouteTraceResult _self;
  final $Res Function(_RouteTraceResult) _then;

/// Create a copy of RouteTraceResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? target = null,Object? host = null,Object? network = null,Object? port = null,Object? mode = null,Object? dnsMode = null,Object? hostsIps = null,Object? resolvedIps = null,Object? resolveTime = null,Object? resolveError = null,Object? resolvedBy = null,Object? dstIp = null,Object? total = null,Object? checked = null,Object? truncated = null,Object? steps = null,Object? matched = freezed,Object? chains = null,Object? supportUdp = null,Object? matchTime = null,Object? error = null,Object? fallbackDirect = null,}) {
  return _then(_RouteTraceResult(
target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,network: null == network ? _self.network : network // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,dnsMode: null == dnsMode ? _self.dnsMode : dnsMode // ignore: cast_nullable_to_non_nullable
as String,hostsIps: null == hostsIps ? _self._hostsIps : hostsIps // ignore: cast_nullable_to_non_nullable
as List<String>,resolvedIps: null == resolvedIps ? _self._resolvedIps : resolvedIps // ignore: cast_nullable_to_non_nullable
as List<String>,resolveTime: null == resolveTime ? _self.resolveTime : resolveTime // ignore: cast_nullable_to_non_nullable
as double,resolveError: null == resolveError ? _self.resolveError : resolveError // ignore: cast_nullable_to_non_nullable
as String,resolvedBy: null == resolvedBy ? _self.resolvedBy : resolvedBy // ignore: cast_nullable_to_non_nullable
as int,dstIp: null == dstIp ? _self.dstIp : dstIp // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,checked: null == checked ? _self.checked : checked // ignore: cast_nullable_to_non_nullable
as int,truncated: null == truncated ? _self.truncated : truncated // ignore: cast_nullable_to_non_nullable
as bool,steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<RouteTraceStep>,matched: freezed == matched ? _self.matched : matched // ignore: cast_nullable_to_non_nullable
as RouteTraceStep?,chains: null == chains ? _self._chains : chains // ignore: cast_nullable_to_non_nullable
as List<RouteTraceChain>,supportUdp: null == supportUdp ? _self.supportUdp : supportUdp // ignore: cast_nullable_to_non_nullable
as bool,matchTime: null == matchTime ? _self.matchTime : matchTime // ignore: cast_nullable_to_non_nullable
as double,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,fallbackDirect: null == fallbackDirect ? _self.fallbackDirect : fallbackDirect // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of RouteTraceResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteTraceStepCopyWith<$Res>? get matched {
    if (_self.matched == null) {
    return null;
  }

  return $RouteTraceStepCopyWith<$Res>(_self.matched!, (value) {
    return _then(_self.copyWith(matched: value));
  });
}
}


/// @nodoc
mixin _$DnsQueryParams {

 String get domain; String get type; String get mode; String get server;
/// Create a copy of DnsQueryParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DnsQueryParamsCopyWith<DnsQueryParams> get copyWith => _$DnsQueryParamsCopyWithImpl<DnsQueryParams>(this as DnsQueryParams, _$identity);

  /// Serializes this DnsQueryParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DnsQueryParams;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DnsQueryParams&&(identical(other.domain, _this.domain) || other.domain == _this.domain)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.server, _this.server) || other.server == _this.server));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DnsQueryParams;
  return Object.hash(runtimeType,_this.domain,_this.type,_this.mode,_this.server);
}

@override
String toString() {
  final _this = this as DnsQueryParams;
  return 'DnsQueryParams(domain: ${_this.domain}, type: ${_this.type}, mode: ${_this.mode}, server: ${_this.server})';
}


}

/// @nodoc
abstract mixin class $DnsQueryParamsCopyWith<$Res>  {
  factory $DnsQueryParamsCopyWith(DnsQueryParams value, $Res Function(DnsQueryParams) _then) = _$DnsQueryParamsCopyWithImpl;
@useResult
$Res call({
 String domain, String type, String mode, String server
});




}
/// @nodoc
class _$DnsQueryParamsCopyWithImpl<$Res>
    implements $DnsQueryParamsCopyWith<$Res> {
  _$DnsQueryParamsCopyWithImpl(this._self, this._then);

  final DnsQueryParams _self;
  final $Res Function(DnsQueryParams) _then;

/// Create a copy of DnsQueryParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? domain = null,Object? type = null,Object? mode = null,Object? server = null,}) {
  return _then(DnsQueryParams(
domain: null == domain ? _self.domain : domain // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,server: null == server ? _self.server : server // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DnsQueryParams].
extension DnsQueryParamsPatterns on DnsQueryParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DnsQueryParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DnsQueryParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DnsQueryParams value)  $default,){
final _that = this;
switch (_that) {
case _DnsQueryParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DnsQueryParams value)?  $default,){
final _that = this;
switch (_that) {
case _DnsQueryParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String domain,  String type,  String mode,  String server)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DnsQueryParams() when $default != null:
return $default(_that.domain,_that.type,_that.mode,_that.server);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String domain,  String type,  String mode,  String server)  $default,) {final _that = this;
switch (_that) {
case _DnsQueryParams():
return $default(_that.domain,_that.type,_that.mode,_that.server);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String domain,  String type,  String mode,  String server)?  $default,) {final _that = this;
switch (_that) {
case _DnsQueryParams() when $default != null:
return $default(_that.domain,_that.type,_that.mode,_that.server);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DnsQueryParams implements DnsQueryParams {
  const _DnsQueryParams({required this.domain, this.type = 'A', this.mode = 'follow', this.server = ''});
  factory _DnsQueryParams.fromJson(Map<String, dynamic> json) => _$DnsQueryParamsFromJson(json);

@override final  String domain;
@override@JsonKey() final  String type;
@override@JsonKey() final  String mode;
@override@JsonKey() final  String server;

/// Create a copy of DnsQueryParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DnsQueryParamsCopyWith<_DnsQueryParams> get copyWith => __$DnsQueryParamsCopyWithImpl<_DnsQueryParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DnsQueryParamsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DnsQueryParams&&(identical(other.domain, domain) || other.domain == domain)&&(identical(other.type, type) || other.type == type)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.server, server) || other.server == server));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,domain,type,mode,server);
}

@override
String toString() {
    return 'DnsQueryParams(domain: $domain, type: $type, mode: $mode, server: $server)';
}


}

/// @nodoc
abstract mixin class _$DnsQueryParamsCopyWith<$Res> implements $DnsQueryParamsCopyWith<$Res> {
  factory _$DnsQueryParamsCopyWith(_DnsQueryParams value, $Res Function(_DnsQueryParams) _then) = __$DnsQueryParamsCopyWithImpl;
@override @useResult
$Res call({
 String domain, String type, String mode, String server
});




}
/// @nodoc
class __$DnsQueryParamsCopyWithImpl<$Res>
    implements _$DnsQueryParamsCopyWith<$Res> {
  __$DnsQueryParamsCopyWithImpl(this._self, this._then);

  final _DnsQueryParams _self;
  final $Res Function(_DnsQueryParams) _then;

/// Create a copy of DnsQueryParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? domain = null,Object? type = null,Object? mode = null,Object? server = null,}) {
  return _then(_DnsQueryParams(
domain: null == domain ? _self.domain : domain // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,server: null == server ? _self.server : server // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DnsQueryRecord {

 String get name; String get type; int get ttl; String get data;
/// Create a copy of DnsQueryRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DnsQueryRecordCopyWith<DnsQueryRecord> get copyWith => _$DnsQueryRecordCopyWithImpl<DnsQueryRecord>(this as DnsQueryRecord, _$identity);

  /// Serializes this DnsQueryRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DnsQueryRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DnsQueryRecord&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.ttl, _this.ttl) || other.ttl == _this.ttl)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DnsQueryRecord;
  return Object.hash(runtimeType,_this.name,_this.type,_this.ttl,_this.data);
}

@override
String toString() {
  final _this = this as DnsQueryRecord;
  return 'DnsQueryRecord(name: ${_this.name}, type: ${_this.type}, ttl: ${_this.ttl}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $DnsQueryRecordCopyWith<$Res>  {
  factory $DnsQueryRecordCopyWith(DnsQueryRecord value, $Res Function(DnsQueryRecord) _then) = _$DnsQueryRecordCopyWithImpl;
@useResult
$Res call({
 String name, String type, int ttl, String data
});




}
/// @nodoc
class _$DnsQueryRecordCopyWithImpl<$Res>
    implements $DnsQueryRecordCopyWith<$Res> {
  _$DnsQueryRecordCopyWithImpl(this._self, this._then);

  final DnsQueryRecord _self;
  final $Res Function(DnsQueryRecord) _then;

/// Create a copy of DnsQueryRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? type = null,Object? ttl = null,Object? data = null,}) {
  return _then(DnsQueryRecord(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,ttl: null == ttl ? _self.ttl : ttl // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DnsQueryRecord].
extension DnsQueryRecordPatterns on DnsQueryRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DnsQueryRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DnsQueryRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DnsQueryRecord value)  $default,){
final _that = this;
switch (_that) {
case _DnsQueryRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DnsQueryRecord value)?  $default,){
final _that = this;
switch (_that) {
case _DnsQueryRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String type,  int ttl,  String data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DnsQueryRecord() when $default != null:
return $default(_that.name,_that.type,_that.ttl,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String type,  int ttl,  String data)  $default,) {final _that = this;
switch (_that) {
case _DnsQueryRecord():
return $default(_that.name,_that.type,_that.ttl,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String type,  int ttl,  String data)?  $default,) {final _that = this;
switch (_that) {
case _DnsQueryRecord() when $default != null:
return $default(_that.name,_that.type,_that.ttl,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DnsQueryRecord implements DnsQueryRecord {
  const _DnsQueryRecord({this.name = '', this.type = '', this.ttl = 0, this.data = ''});
  factory _DnsQueryRecord.fromJson(Map<String, dynamic> json) => _$DnsQueryRecordFromJson(json);

@override@JsonKey() final  String name;
@override@JsonKey() final  String type;
@override@JsonKey() final  int ttl;
@override@JsonKey() final  String data;

/// Create a copy of DnsQueryRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DnsQueryRecordCopyWith<_DnsQueryRecord> get copyWith => __$DnsQueryRecordCopyWithImpl<_DnsQueryRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DnsQueryRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DnsQueryRecord&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.ttl, ttl) || other.ttl == ttl)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,type,ttl,data);
}

@override
String toString() {
    return 'DnsQueryRecord(name: $name, type: $type, ttl: $ttl, data: $data)';
}


}

/// @nodoc
abstract mixin class _$DnsQueryRecordCopyWith<$Res> implements $DnsQueryRecordCopyWith<$Res> {
  factory _$DnsQueryRecordCopyWith(_DnsQueryRecord value, $Res Function(_DnsQueryRecord) _then) = __$DnsQueryRecordCopyWithImpl;
@override @useResult
$Res call({
 String name, String type, int ttl, String data
});




}
/// @nodoc
class __$DnsQueryRecordCopyWithImpl<$Res>
    implements _$DnsQueryRecordCopyWith<$Res> {
  __$DnsQueryRecordCopyWithImpl(this._self, this._then);

  final _DnsQueryRecord _self;
  final $Res Function(_DnsQueryRecord) _then;

/// Create a copy of DnsQueryRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? type = null,Object? ttl = null,Object? data = null,}) {
  return _then(_DnsQueryRecord(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,ttl: null == ttl ? _self.ttl : ttl // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DnsQueryResult {

 String get domain; String get type; String get mode; String get server; String get rcode; List<DnsQueryRecord> get answers; double get elapsed; String get route; List<String> get hosts;@JsonKey(name: 'fake-ip-range') String get fakeIpRange;@JsonKey(name: 'filter-mode') String get filterMode; String get outbound;@JsonKey(name: 'outbound-type') String get outboundType; String get error;
/// Create a copy of DnsQueryResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DnsQueryResultCopyWith<DnsQueryResult> get copyWith => _$DnsQueryResultCopyWithImpl<DnsQueryResult>(this as DnsQueryResult, _$identity);

  /// Serializes this DnsQueryResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DnsQueryResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DnsQueryResult&&(identical(other.domain, _this.domain) || other.domain == _this.domain)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.server, _this.server) || other.server == _this.server)&&(identical(other.rcode, _this.rcode) || other.rcode == _this.rcode)&&const DeepCollectionEquality().equals(other.answers, _this.answers)&&(identical(other.elapsed, _this.elapsed) || other.elapsed == _this.elapsed)&&(identical(other.route, _this.route) || other.route == _this.route)&&const DeepCollectionEquality().equals(other.hosts, _this.hosts)&&(identical(other.fakeIpRange, _this.fakeIpRange) || other.fakeIpRange == _this.fakeIpRange)&&(identical(other.filterMode, _this.filterMode) || other.filterMode == _this.filterMode)&&(identical(other.outbound, _this.outbound) || other.outbound == _this.outbound)&&(identical(other.outboundType, _this.outboundType) || other.outboundType == _this.outboundType)&&(identical(other.error, _this.error) || other.error == _this.error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DnsQueryResult;
  return Object.hash(runtimeType,_this.domain,_this.type,_this.mode,_this.server,_this.rcode,const DeepCollectionEquality().hash(_this.answers),_this.elapsed,_this.route,const DeepCollectionEquality().hash(_this.hosts),_this.fakeIpRange,_this.filterMode,_this.outbound,_this.outboundType,_this.error);
}

@override
String toString() {
  final _this = this as DnsQueryResult;
  return 'DnsQueryResult(domain: ${_this.domain}, type: ${_this.type}, mode: ${_this.mode}, server: ${_this.server}, rcode: ${_this.rcode}, answers: ${_this.answers}, elapsed: ${_this.elapsed}, route: ${_this.route}, hosts: ${_this.hosts}, fakeIpRange: ${_this.fakeIpRange}, filterMode: ${_this.filterMode}, outbound: ${_this.outbound}, outboundType: ${_this.outboundType}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $DnsQueryResultCopyWith<$Res>  {
  factory $DnsQueryResultCopyWith(DnsQueryResult value, $Res Function(DnsQueryResult) _then) = _$DnsQueryResultCopyWithImpl;
@useResult
$Res call({
 String domain, String type, String mode, String server, String rcode, List<DnsQueryRecord> answers, double elapsed, String route, List<String> hosts,@JsonKey(name: 'fake-ip-range') String fakeIpRange,@JsonKey(name: 'filter-mode') String filterMode, String outbound,@JsonKey(name: 'outbound-type') String outboundType, String error
});




}
/// @nodoc
class _$DnsQueryResultCopyWithImpl<$Res>
    implements $DnsQueryResultCopyWith<$Res> {
  _$DnsQueryResultCopyWithImpl(this._self, this._then);

  final DnsQueryResult _self;
  final $Res Function(DnsQueryResult) _then;

/// Create a copy of DnsQueryResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? domain = null,Object? type = null,Object? mode = null,Object? server = null,Object? rcode = null,Object? answers = null,Object? elapsed = null,Object? route = null,Object? hosts = null,Object? fakeIpRange = null,Object? filterMode = null,Object? outbound = null,Object? outboundType = null,Object? error = null,}) {
  return _then(DnsQueryResult(
domain: null == domain ? _self.domain : domain // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,server: null == server ? _self.server : server // ignore: cast_nullable_to_non_nullable
as String,rcode: null == rcode ? _self.rcode : rcode // ignore: cast_nullable_to_non_nullable
as String,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as List<DnsQueryRecord>,elapsed: null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as double,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String,hosts: null == hosts ? _self.hosts : hosts // ignore: cast_nullable_to_non_nullable
as List<String>,fakeIpRange: null == fakeIpRange ? _self.fakeIpRange : fakeIpRange // ignore: cast_nullable_to_non_nullable
as String,filterMode: null == filterMode ? _self.filterMode : filterMode // ignore: cast_nullable_to_non_nullable
as String,outbound: null == outbound ? _self.outbound : outbound // ignore: cast_nullable_to_non_nullable
as String,outboundType: null == outboundType ? _self.outboundType : outboundType // ignore: cast_nullable_to_non_nullable
as String,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DnsQueryResult].
extension DnsQueryResultPatterns on DnsQueryResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DnsQueryResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DnsQueryResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DnsQueryResult value)  $default,){
final _that = this;
switch (_that) {
case _DnsQueryResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DnsQueryResult value)?  $default,){
final _that = this;
switch (_that) {
case _DnsQueryResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String domain,  String type,  String mode,  String server,  String rcode,  List<DnsQueryRecord> answers,  double elapsed,  String route,  List<String> hosts, @JsonKey(name: 'fake-ip-range')  String fakeIpRange, @JsonKey(name: 'filter-mode')  String filterMode,  String outbound, @JsonKey(name: 'outbound-type')  String outboundType,  String error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DnsQueryResult() when $default != null:
return $default(_that.domain,_that.type,_that.mode,_that.server,_that.rcode,_that.answers,_that.elapsed,_that.route,_that.hosts,_that.fakeIpRange,_that.filterMode,_that.outbound,_that.outboundType,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String domain,  String type,  String mode,  String server,  String rcode,  List<DnsQueryRecord> answers,  double elapsed,  String route,  List<String> hosts, @JsonKey(name: 'fake-ip-range')  String fakeIpRange, @JsonKey(name: 'filter-mode')  String filterMode,  String outbound, @JsonKey(name: 'outbound-type')  String outboundType,  String error)  $default,) {final _that = this;
switch (_that) {
case _DnsQueryResult():
return $default(_that.domain,_that.type,_that.mode,_that.server,_that.rcode,_that.answers,_that.elapsed,_that.route,_that.hosts,_that.fakeIpRange,_that.filterMode,_that.outbound,_that.outboundType,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String domain,  String type,  String mode,  String server,  String rcode,  List<DnsQueryRecord> answers,  double elapsed,  String route,  List<String> hosts, @JsonKey(name: 'fake-ip-range')  String fakeIpRange, @JsonKey(name: 'filter-mode')  String filterMode,  String outbound, @JsonKey(name: 'outbound-type')  String outboundType,  String error)?  $default,) {final _that = this;
switch (_that) {
case _DnsQueryResult() when $default != null:
return $default(_that.domain,_that.type,_that.mode,_that.server,_that.rcode,_that.answers,_that.elapsed,_that.route,_that.hosts,_that.fakeIpRange,_that.filterMode,_that.outbound,_that.outboundType,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DnsQueryResult implements DnsQueryResult {
  const _DnsQueryResult({this.domain = '', this.type = '', this.mode = '', this.server = '', this.rcode = '',  List<DnsQueryRecord> answers = const [], this.elapsed = 0.0, this.route = '',  List<String> hosts = const [], @JsonKey(name: 'fake-ip-range') this.fakeIpRange = '', @JsonKey(name: 'filter-mode') this.filterMode = '', this.outbound = '', @JsonKey(name: 'outbound-type') this.outboundType = '', this.error = ''}): _answers = answers,_hosts = hosts;
  factory _DnsQueryResult.fromJson(Map<String, dynamic> json) => _$DnsQueryResultFromJson(json);

@override@JsonKey() final  String domain;
@override@JsonKey() final  String type;
@override@JsonKey() final  String mode;
@override@JsonKey() final  String server;
@override@JsonKey() final  String rcode;
 final  List<DnsQueryRecord> _answers;
@override@JsonKey() List<DnsQueryRecord> get answers {
  if (_answers is EqualUnmodifiableListView) return _answers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_answers);
}

@override@JsonKey() final  double elapsed;
@override@JsonKey() final  String route;
 final  List<String> _hosts;
@override@JsonKey() List<String> get hosts {
  if (_hosts is EqualUnmodifiableListView) return _hosts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hosts);
}

@override@JsonKey(name: 'fake-ip-range') final  String fakeIpRange;
@override@JsonKey(name: 'filter-mode') final  String filterMode;
@override@JsonKey() final  String outbound;
@override@JsonKey(name: 'outbound-type') final  String outboundType;
@override@JsonKey() final  String error;

/// Create a copy of DnsQueryResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DnsQueryResultCopyWith<_DnsQueryResult> get copyWith => __$DnsQueryResultCopyWithImpl<_DnsQueryResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DnsQueryResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DnsQueryResult&&(identical(other.domain, domain) || other.domain == domain)&&(identical(other.type, type) || other.type == type)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.server, server) || other.server == server)&&(identical(other.rcode, rcode) || other.rcode == rcode)&&const DeepCollectionEquality().equals(other.answers, _answers)&&(identical(other.elapsed, elapsed) || other.elapsed == elapsed)&&(identical(other.route, route) || other.route == route)&&const DeepCollectionEquality().equals(other.hosts, _hosts)&&(identical(other.fakeIpRange, fakeIpRange) || other.fakeIpRange == fakeIpRange)&&(identical(other.filterMode, filterMode) || other.filterMode == filterMode)&&(identical(other.outbound, outbound) || other.outbound == outbound)&&(identical(other.outboundType, outboundType) || other.outboundType == outboundType)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,domain,type,mode,server,rcode,const DeepCollectionEquality().hash(_answers),elapsed,route,const DeepCollectionEquality().hash(_hosts),fakeIpRange,filterMode,outbound,outboundType,error);
}

@override
String toString() {
    return 'DnsQueryResult(domain: $domain, type: $type, mode: $mode, server: $server, rcode: $rcode, answers: $answers, elapsed: $elapsed, route: $route, hosts: $hosts, fakeIpRange: $fakeIpRange, filterMode: $filterMode, outbound: $outbound, outboundType: $outboundType, error: $error)';
}


}

/// @nodoc
abstract mixin class _$DnsQueryResultCopyWith<$Res> implements $DnsQueryResultCopyWith<$Res> {
  factory _$DnsQueryResultCopyWith(_DnsQueryResult value, $Res Function(_DnsQueryResult) _then) = __$DnsQueryResultCopyWithImpl;
@override @useResult
$Res call({
 String domain, String type, String mode, String server, String rcode, List<DnsQueryRecord> answers, double elapsed, String route, List<String> hosts,@JsonKey(name: 'fake-ip-range') String fakeIpRange,@JsonKey(name: 'filter-mode') String filterMode, String outbound,@JsonKey(name: 'outbound-type') String outboundType, String error
});




}
/// @nodoc
class __$DnsQueryResultCopyWithImpl<$Res>
    implements _$DnsQueryResultCopyWith<$Res> {
  __$DnsQueryResultCopyWithImpl(this._self, this._then);

  final _DnsQueryResult _self;
  final $Res Function(_DnsQueryResult) _then;

/// Create a copy of DnsQueryResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? domain = null,Object? type = null,Object? mode = null,Object? server = null,Object? rcode = null,Object? answers = null,Object? elapsed = null,Object? route = null,Object? hosts = null,Object? fakeIpRange = null,Object? filterMode = null,Object? outbound = null,Object? outboundType = null,Object? error = null,}) {
  return _then(_DnsQueryResult(
domain: null == domain ? _self.domain : domain // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,server: null == server ? _self.server : server // ignore: cast_nullable_to_non_nullable
as String,rcode: null == rcode ? _self.rcode : rcode // ignore: cast_nullable_to_non_nullable
as String,answers: null == answers ? _self._answers : answers // ignore: cast_nullable_to_non_nullable
as List<DnsQueryRecord>,elapsed: null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as double,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String,hosts: null == hosts ? _self._hosts : hosts // ignore: cast_nullable_to_non_nullable
as List<String>,fakeIpRange: null == fakeIpRange ? _self.fakeIpRange : fakeIpRange // ignore: cast_nullable_to_non_nullable
as String,filterMode: null == filterMode ? _self.filterMode : filterMode // ignore: cast_nullable_to_non_nullable
as String,outbound: null == outbound ? _self.outbound : outbound // ignore: cast_nullable_to_non_nullable
as String,outboundType: null == outboundType ? _self.outboundType : outboundType // ignore: cast_nullable_to_non_nullable
as String,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$MrsPrepareResult {

 String get version; int get geosite; int get geoip; bool get extracted; double get elapsed; String get error;
/// Create a copy of MrsPrepareResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MrsPrepareResultCopyWith<MrsPrepareResult> get copyWith => _$MrsPrepareResultCopyWithImpl<MrsPrepareResult>(this as MrsPrepareResult, _$identity);

  /// Serializes this MrsPrepareResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MrsPrepareResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MrsPrepareResult&&(identical(other.version, _this.version) || other.version == _this.version)&&(identical(other.geosite, _this.geosite) || other.geosite == _this.geosite)&&(identical(other.geoip, _this.geoip) || other.geoip == _this.geoip)&&(identical(other.extracted, _this.extracted) || other.extracted == _this.extracted)&&(identical(other.elapsed, _this.elapsed) || other.elapsed == _this.elapsed)&&(identical(other.error, _this.error) || other.error == _this.error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MrsPrepareResult;
  return Object.hash(runtimeType,_this.version,_this.geosite,_this.geoip,_this.extracted,_this.elapsed,_this.error);
}

@override
String toString() {
  final _this = this as MrsPrepareResult;
  return 'MrsPrepareResult(version: ${_this.version}, geosite: ${_this.geosite}, geoip: ${_this.geoip}, extracted: ${_this.extracted}, elapsed: ${_this.elapsed}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $MrsPrepareResultCopyWith<$Res>  {
  factory $MrsPrepareResultCopyWith(MrsPrepareResult value, $Res Function(MrsPrepareResult) _then) = _$MrsPrepareResultCopyWithImpl;
@useResult
$Res call({
 String version, int geosite, int geoip, bool extracted, double elapsed, String error
});




}
/// @nodoc
class _$MrsPrepareResultCopyWithImpl<$Res>
    implements $MrsPrepareResultCopyWith<$Res> {
  _$MrsPrepareResultCopyWithImpl(this._self, this._then);

  final MrsPrepareResult _self;
  final $Res Function(MrsPrepareResult) _then;

/// Create a copy of MrsPrepareResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? geosite = null,Object? geoip = null,Object? extracted = null,Object? elapsed = null,Object? error = null,}) {
  return _then(MrsPrepareResult(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,geosite: null == geosite ? _self.geosite : geosite // ignore: cast_nullable_to_non_nullable
as int,geoip: null == geoip ? _self.geoip : geoip // ignore: cast_nullable_to_non_nullable
as int,extracted: null == extracted ? _self.extracted : extracted // ignore: cast_nullable_to_non_nullable
as bool,elapsed: null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as double,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MrsPrepareResult].
extension MrsPrepareResultPatterns on MrsPrepareResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MrsPrepareResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MrsPrepareResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MrsPrepareResult value)  $default,){
final _that = this;
switch (_that) {
case _MrsPrepareResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MrsPrepareResult value)?  $default,){
final _that = this;
switch (_that) {
case _MrsPrepareResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String version,  int geosite,  int geoip,  bool extracted,  double elapsed,  String error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MrsPrepareResult() when $default != null:
return $default(_that.version,_that.geosite,_that.geoip,_that.extracted,_that.elapsed,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String version,  int geosite,  int geoip,  bool extracted,  double elapsed,  String error)  $default,) {final _that = this;
switch (_that) {
case _MrsPrepareResult():
return $default(_that.version,_that.geosite,_that.geoip,_that.extracted,_that.elapsed,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String version,  int geosite,  int geoip,  bool extracted,  double elapsed,  String error)?  $default,) {final _that = this;
switch (_that) {
case _MrsPrepareResult() when $default != null:
return $default(_that.version,_that.geosite,_that.geoip,_that.extracted,_that.elapsed,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MrsPrepareResult implements MrsPrepareResult {
  const _MrsPrepareResult({this.version = '', this.geosite = 0, this.geoip = 0, this.extracted = false, this.elapsed = 0.0, this.error = ''});
  factory _MrsPrepareResult.fromJson(Map<String, dynamic> json) => _$MrsPrepareResultFromJson(json);

@override@JsonKey() final  String version;
@override@JsonKey() final  int geosite;
@override@JsonKey() final  int geoip;
@override@JsonKey() final  bool extracted;
@override@JsonKey() final  double elapsed;
@override@JsonKey() final  String error;

/// Create a copy of MrsPrepareResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MrsPrepareResultCopyWith<_MrsPrepareResult> get copyWith => __$MrsPrepareResultCopyWithImpl<_MrsPrepareResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MrsPrepareResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MrsPrepareResult&&(identical(other.version, version) || other.version == version)&&(identical(other.geosite, geosite) || other.geosite == geosite)&&(identical(other.geoip, geoip) || other.geoip == geoip)&&(identical(other.extracted, extracted) || other.extracted == extracted)&&(identical(other.elapsed, elapsed) || other.elapsed == elapsed)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,version,geosite,geoip,extracted,elapsed,error);
}

@override
String toString() {
    return 'MrsPrepareResult(version: $version, geosite: $geosite, geoip: $geoip, extracted: $extracted, elapsed: $elapsed, error: $error)';
}


}

/// @nodoc
abstract mixin class _$MrsPrepareResultCopyWith<$Res> implements $MrsPrepareResultCopyWith<$Res> {
  factory _$MrsPrepareResultCopyWith(_MrsPrepareResult value, $Res Function(_MrsPrepareResult) _then) = __$MrsPrepareResultCopyWithImpl;
@override @useResult
$Res call({
 String version, int geosite, int geoip, bool extracted, double elapsed, String error
});




}
/// @nodoc
class __$MrsPrepareResultCopyWithImpl<$Res>
    implements _$MrsPrepareResultCopyWith<$Res> {
  __$MrsPrepareResultCopyWithImpl(this._self, this._then);

  final _MrsPrepareResult _self;
  final $Res Function(_MrsPrepareResult) _then;

/// Create a copy of MrsPrepareResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? geosite = null,Object? geoip = null,Object? extracted = null,Object? elapsed = null,Object? error = null,}) {
  return _then(_MrsPrepareResult(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,geosite: null == geosite ? _self.geosite : geosite // ignore: cast_nullable_to_non_nullable
as int,geoip: null == geoip ? _self.geoip : geoip // ignore: cast_nullable_to_non_nullable
as int,extracted: null == extracted ? _self.extracted : extracted // ignore: cast_nullable_to_non_nullable
as bool,elapsed: null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as double,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$MrsLookupParams {

 String get target; bool get resolve;
/// Create a copy of MrsLookupParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MrsLookupParamsCopyWith<MrsLookupParams> get copyWith => _$MrsLookupParamsCopyWithImpl<MrsLookupParams>(this as MrsLookupParams, _$identity);

  /// Serializes this MrsLookupParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MrsLookupParams;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MrsLookupParams&&(identical(other.target, _this.target) || other.target == _this.target)&&(identical(other.resolve, _this.resolve) || other.resolve == _this.resolve));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MrsLookupParams;
  return Object.hash(runtimeType,_this.target,_this.resolve);
}

@override
String toString() {
  final _this = this as MrsLookupParams;
  return 'MrsLookupParams(target: ${_this.target}, resolve: ${_this.resolve})';
}


}

/// @nodoc
abstract mixin class $MrsLookupParamsCopyWith<$Res>  {
  factory $MrsLookupParamsCopyWith(MrsLookupParams value, $Res Function(MrsLookupParams) _then) = _$MrsLookupParamsCopyWithImpl;
@useResult
$Res call({
 String target, bool resolve
});




}
/// @nodoc
class _$MrsLookupParamsCopyWithImpl<$Res>
    implements $MrsLookupParamsCopyWith<$Res> {
  _$MrsLookupParamsCopyWithImpl(this._self, this._then);

  final MrsLookupParams _self;
  final $Res Function(MrsLookupParams) _then;

/// Create a copy of MrsLookupParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? target = null,Object? resolve = null,}) {
  return _then(MrsLookupParams(
target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,resolve: null == resolve ? _self.resolve : resolve // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MrsLookupParams].
extension MrsLookupParamsPatterns on MrsLookupParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MrsLookupParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MrsLookupParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MrsLookupParams value)  $default,){
final _that = this;
switch (_that) {
case _MrsLookupParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MrsLookupParams value)?  $default,){
final _that = this;
switch (_that) {
case _MrsLookupParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String target,  bool resolve)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MrsLookupParams() when $default != null:
return $default(_that.target,_that.resolve);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String target,  bool resolve)  $default,) {final _that = this;
switch (_that) {
case _MrsLookupParams():
return $default(_that.target,_that.resolve);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String target,  bool resolve)?  $default,) {final _that = this;
switch (_that) {
case _MrsLookupParams() when $default != null:
return $default(_that.target,_that.resolve);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MrsLookupParams implements MrsLookupParams {
  const _MrsLookupParams({required this.target, this.resolve = true});
  factory _MrsLookupParams.fromJson(Map<String, dynamic> json) => _$MrsLookupParamsFromJson(json);

@override final  String target;
@override@JsonKey() final  bool resolve;

/// Create a copy of MrsLookupParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MrsLookupParamsCopyWith<_MrsLookupParams> get copyWith => __$MrsLookupParamsCopyWithImpl<_MrsLookupParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MrsLookupParamsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MrsLookupParams&&(identical(other.target, target) || other.target == target)&&(identical(other.resolve, resolve) || other.resolve == resolve));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,target,resolve);
}

@override
String toString() {
    return 'MrsLookupParams(target: $target, resolve: $resolve)';
}


}

/// @nodoc
abstract mixin class _$MrsLookupParamsCopyWith<$Res> implements $MrsLookupParamsCopyWith<$Res> {
  factory _$MrsLookupParamsCopyWith(_MrsLookupParams value, $Res Function(_MrsLookupParams) _then) = __$MrsLookupParamsCopyWithImpl;
@override @useResult
$Res call({
 String target, bool resolve
});




}
/// @nodoc
class __$MrsLookupParamsCopyWithImpl<$Res>
    implements _$MrsLookupParamsCopyWith<$Res> {
  __$MrsLookupParamsCopyWithImpl(this._self, this._then);

  final _MrsLookupParams _self;
  final $Res Function(_MrsLookupParams) _then;

/// Create a copy of MrsLookupParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? target = null,Object? resolve = null,}) {
  return _then(_MrsLookupParams(
target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,resolve: null == resolve ? _self.resolve : resolve // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$MrsMatch {

 String get kind; String get name; String get file; int get count; String get via; bool get referenced;
/// Create a copy of MrsMatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MrsMatchCopyWith<MrsMatch> get copyWith => _$MrsMatchCopyWithImpl<MrsMatch>(this as MrsMatch, _$identity);

  /// Serializes this MrsMatch to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MrsMatch;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MrsMatch&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.file, _this.file) || other.file == _this.file)&&(identical(other.count, _this.count) || other.count == _this.count)&&(identical(other.via, _this.via) || other.via == _this.via)&&(identical(other.referenced, _this.referenced) || other.referenced == _this.referenced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MrsMatch;
  return Object.hash(runtimeType,_this.kind,_this.name,_this.file,_this.count,_this.via,_this.referenced);
}

@override
String toString() {
  final _this = this as MrsMatch;
  return 'MrsMatch(kind: ${_this.kind}, name: ${_this.name}, file: ${_this.file}, count: ${_this.count}, via: ${_this.via}, referenced: ${_this.referenced})';
}


}

/// @nodoc
abstract mixin class $MrsMatchCopyWith<$Res>  {
  factory $MrsMatchCopyWith(MrsMatch value, $Res Function(MrsMatch) _then) = _$MrsMatchCopyWithImpl;
@useResult
$Res call({
 String kind, String name, String file, int count, String via, bool referenced
});




}
/// @nodoc
class _$MrsMatchCopyWithImpl<$Res>
    implements $MrsMatchCopyWith<$Res> {
  _$MrsMatchCopyWithImpl(this._self, this._then);

  final MrsMatch _self;
  final $Res Function(MrsMatch) _then;

/// Create a copy of MrsMatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? name = null,Object? file = null,Object? count = null,Object? via = null,Object? referenced = null,}) {
  return _then(MrsMatch(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,file: null == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,via: null == via ? _self.via : via // ignore: cast_nullable_to_non_nullable
as String,referenced: null == referenced ? _self.referenced : referenced // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MrsMatch].
extension MrsMatchPatterns on MrsMatch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MrsMatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MrsMatch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MrsMatch value)  $default,){
final _that = this;
switch (_that) {
case _MrsMatch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MrsMatch value)?  $default,){
final _that = this;
switch (_that) {
case _MrsMatch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String kind,  String name,  String file,  int count,  String via,  bool referenced)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MrsMatch() when $default != null:
return $default(_that.kind,_that.name,_that.file,_that.count,_that.via,_that.referenced);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String kind,  String name,  String file,  int count,  String via,  bool referenced)  $default,) {final _that = this;
switch (_that) {
case _MrsMatch():
return $default(_that.kind,_that.name,_that.file,_that.count,_that.via,_that.referenced);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String kind,  String name,  String file,  int count,  String via,  bool referenced)?  $default,) {final _that = this;
switch (_that) {
case _MrsMatch() when $default != null:
return $default(_that.kind,_that.name,_that.file,_that.count,_that.via,_that.referenced);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MrsMatch implements MrsMatch {
  const _MrsMatch({this.kind = '', this.name = '', this.file = '', this.count = 0, this.via = '', this.referenced = false});
  factory _MrsMatch.fromJson(Map<String, dynamic> json) => _$MrsMatchFromJson(json);

@override@JsonKey() final  String kind;
@override@JsonKey() final  String name;
@override@JsonKey() final  String file;
@override@JsonKey() final  int count;
@override@JsonKey() final  String via;
@override@JsonKey() final  bool referenced;

/// Create a copy of MrsMatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MrsMatchCopyWith<_MrsMatch> get copyWith => __$MrsMatchCopyWithImpl<_MrsMatch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MrsMatchToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MrsMatch&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.name, name) || other.name == name)&&(identical(other.file, file) || other.file == file)&&(identical(other.count, count) || other.count == count)&&(identical(other.via, via) || other.via == via)&&(identical(other.referenced, referenced) || other.referenced == referenced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,name,file,count,via,referenced);
}

@override
String toString() {
    return 'MrsMatch(kind: $kind, name: $name, file: $file, count: $count, via: $via, referenced: $referenced)';
}


}

/// @nodoc
abstract mixin class _$MrsMatchCopyWith<$Res> implements $MrsMatchCopyWith<$Res> {
  factory _$MrsMatchCopyWith(_MrsMatch value, $Res Function(_MrsMatch) _then) = __$MrsMatchCopyWithImpl;
@override @useResult
$Res call({
 String kind, String name, String file, int count, String via, bool referenced
});




}
/// @nodoc
class __$MrsMatchCopyWithImpl<$Res>
    implements _$MrsMatchCopyWith<$Res> {
  __$MrsMatchCopyWithImpl(this._self, this._then);

  final _MrsMatch _self;
  final $Res Function(_MrsMatch) _then;

/// Create a copy of MrsMatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? name = null,Object? file = null,Object? count = null,Object? via = null,Object? referenced = null,}) {
  return _then(_MrsMatch(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,file: null == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,via: null == via ? _self.via : via // ignore: cast_nullable_to_non_nullable
as String,referenced: null == referenced ? _self.referenced : referenced // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$MrsLookupResult {

 String get target; String get host; List<String> get ips; List<MrsMatch> get matches; double get elapsed; String get error;
/// Create a copy of MrsLookupResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MrsLookupResultCopyWith<MrsLookupResult> get copyWith => _$MrsLookupResultCopyWithImpl<MrsLookupResult>(this as MrsLookupResult, _$identity);

  /// Serializes this MrsLookupResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MrsLookupResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MrsLookupResult&&(identical(other.target, _this.target) || other.target == _this.target)&&(identical(other.host, _this.host) || other.host == _this.host)&&const DeepCollectionEquality().equals(other.ips, _this.ips)&&const DeepCollectionEquality().equals(other.matches, _this.matches)&&(identical(other.elapsed, _this.elapsed) || other.elapsed == _this.elapsed)&&(identical(other.error, _this.error) || other.error == _this.error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MrsLookupResult;
  return Object.hash(runtimeType,_this.target,_this.host,const DeepCollectionEquality().hash(_this.ips),const DeepCollectionEquality().hash(_this.matches),_this.elapsed,_this.error);
}

@override
String toString() {
  final _this = this as MrsLookupResult;
  return 'MrsLookupResult(target: ${_this.target}, host: ${_this.host}, ips: ${_this.ips}, matches: ${_this.matches}, elapsed: ${_this.elapsed}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $MrsLookupResultCopyWith<$Res>  {
  factory $MrsLookupResultCopyWith(MrsLookupResult value, $Res Function(MrsLookupResult) _then) = _$MrsLookupResultCopyWithImpl;
@useResult
$Res call({
 String target, String host, List<String> ips, List<MrsMatch> matches, double elapsed, String error
});




}
/// @nodoc
class _$MrsLookupResultCopyWithImpl<$Res>
    implements $MrsLookupResultCopyWith<$Res> {
  _$MrsLookupResultCopyWithImpl(this._self, this._then);

  final MrsLookupResult _self;
  final $Res Function(MrsLookupResult) _then;

/// Create a copy of MrsLookupResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? target = null,Object? host = null,Object? ips = null,Object? matches = null,Object? elapsed = null,Object? error = null,}) {
  return _then(MrsLookupResult(
target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,ips: null == ips ? _self.ips : ips // ignore: cast_nullable_to_non_nullable
as List<String>,matches: null == matches ? _self.matches : matches // ignore: cast_nullable_to_non_nullable
as List<MrsMatch>,elapsed: null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as double,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MrsLookupResult].
extension MrsLookupResultPatterns on MrsLookupResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MrsLookupResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MrsLookupResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MrsLookupResult value)  $default,){
final _that = this;
switch (_that) {
case _MrsLookupResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MrsLookupResult value)?  $default,){
final _that = this;
switch (_that) {
case _MrsLookupResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String target,  String host,  List<String> ips,  List<MrsMatch> matches,  double elapsed,  String error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MrsLookupResult() when $default != null:
return $default(_that.target,_that.host,_that.ips,_that.matches,_that.elapsed,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String target,  String host,  List<String> ips,  List<MrsMatch> matches,  double elapsed,  String error)  $default,) {final _that = this;
switch (_that) {
case _MrsLookupResult():
return $default(_that.target,_that.host,_that.ips,_that.matches,_that.elapsed,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String target,  String host,  List<String> ips,  List<MrsMatch> matches,  double elapsed,  String error)?  $default,) {final _that = this;
switch (_that) {
case _MrsLookupResult() when $default != null:
return $default(_that.target,_that.host,_that.ips,_that.matches,_that.elapsed,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MrsLookupResult implements MrsLookupResult {
  const _MrsLookupResult({this.target = '', this.host = '',  List<String> ips = const [],  List<MrsMatch> matches = const [], this.elapsed = 0.0, this.error = ''}): _ips = ips,_matches = matches;
  factory _MrsLookupResult.fromJson(Map<String, dynamic> json) => _$MrsLookupResultFromJson(json);

@override@JsonKey() final  String target;
@override@JsonKey() final  String host;
 final  List<String> _ips;
@override@JsonKey() List<String> get ips {
  if (_ips is EqualUnmodifiableListView) return _ips;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ips);
}

 final  List<MrsMatch> _matches;
@override@JsonKey() List<MrsMatch> get matches {
  if (_matches is EqualUnmodifiableListView) return _matches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_matches);
}

@override@JsonKey() final  double elapsed;
@override@JsonKey() final  String error;

/// Create a copy of MrsLookupResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MrsLookupResultCopyWith<_MrsLookupResult> get copyWith => __$MrsLookupResultCopyWithImpl<_MrsLookupResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MrsLookupResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MrsLookupResult&&(identical(other.target, target) || other.target == target)&&(identical(other.host, host) || other.host == host)&&const DeepCollectionEquality().equals(other.ips, _ips)&&const DeepCollectionEquality().equals(other.matches, _matches)&&(identical(other.elapsed, elapsed) || other.elapsed == elapsed)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,target,host,const DeepCollectionEquality().hash(_ips),const DeepCollectionEquality().hash(_matches),elapsed,error);
}

@override
String toString() {
    return 'MrsLookupResult(target: $target, host: $host, ips: $ips, matches: $matches, elapsed: $elapsed, error: $error)';
}


}

/// @nodoc
abstract mixin class _$MrsLookupResultCopyWith<$Res> implements $MrsLookupResultCopyWith<$Res> {
  factory _$MrsLookupResultCopyWith(_MrsLookupResult value, $Res Function(_MrsLookupResult) _then) = __$MrsLookupResultCopyWithImpl;
@override @useResult
$Res call({
 String target, String host, List<String> ips, List<MrsMatch> matches, double elapsed, String error
});




}
/// @nodoc
class __$MrsLookupResultCopyWithImpl<$Res>
    implements _$MrsLookupResultCopyWith<$Res> {
  __$MrsLookupResultCopyWithImpl(this._self, this._then);

  final _MrsLookupResult _self;
  final $Res Function(_MrsLookupResult) _then;

/// Create a copy of MrsLookupResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? target = null,Object? host = null,Object? ips = null,Object? matches = null,Object? elapsed = null,Object? error = null,}) {
  return _then(_MrsLookupResult(
target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,ips: null == ips ? _self._ips : ips // ignore: cast_nullable_to_non_nullable
as List<String>,matches: null == matches ? _self._matches : matches // ignore: cast_nullable_to_non_nullable
as List<MrsMatch>,elapsed: null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as double,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$StunTestParams {

 String get server; String get proxy;
/// Create a copy of StunTestParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StunTestParamsCopyWith<StunTestParams> get copyWith => _$StunTestParamsCopyWithImpl<StunTestParams>(this as StunTestParams, _$identity);

  /// Serializes this StunTestParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StunTestParams;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StunTestParams&&(identical(other.server, _this.server) || other.server == _this.server)&&(identical(other.proxy, _this.proxy) || other.proxy == _this.proxy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StunTestParams;
  return Object.hash(runtimeType,_this.server,_this.proxy);
}

@override
String toString() {
  final _this = this as StunTestParams;
  return 'StunTestParams(server: ${_this.server}, proxy: ${_this.proxy})';
}


}

/// @nodoc
abstract mixin class $StunTestParamsCopyWith<$Res>  {
  factory $StunTestParamsCopyWith(StunTestParams value, $Res Function(StunTestParams) _then) = _$StunTestParamsCopyWithImpl;
@useResult
$Res call({
 String server, String proxy
});




}
/// @nodoc
class _$StunTestParamsCopyWithImpl<$Res>
    implements $StunTestParamsCopyWith<$Res> {
  _$StunTestParamsCopyWithImpl(this._self, this._then);

  final StunTestParams _self;
  final $Res Function(StunTestParams) _then;

/// Create a copy of StunTestParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? server = null,Object? proxy = null,}) {
  return _then(StunTestParams(
server: null == server ? _self.server : server // ignore: cast_nullable_to_non_nullable
as String,proxy: null == proxy ? _self.proxy : proxy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StunTestParams].
extension StunTestParamsPatterns on StunTestParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StunTestParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StunTestParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StunTestParams value)  $default,){
final _that = this;
switch (_that) {
case _StunTestParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StunTestParams value)?  $default,){
final _that = this;
switch (_that) {
case _StunTestParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String server,  String proxy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StunTestParams() when $default != null:
return $default(_that.server,_that.proxy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String server,  String proxy)  $default,) {final _that = this;
switch (_that) {
case _StunTestParams():
return $default(_that.server,_that.proxy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String server,  String proxy)?  $default,) {final _that = this;
switch (_that) {
case _StunTestParams() when $default != null:
return $default(_that.server,_that.proxy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StunTestParams implements StunTestParams {
  const _StunTestParams({this.server = '', this.proxy = ''});
  factory _StunTestParams.fromJson(Map<String, dynamic> json) => _$StunTestParamsFromJson(json);

@override@JsonKey() final  String server;
@override@JsonKey() final  String proxy;

/// Create a copy of StunTestParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StunTestParamsCopyWith<_StunTestParams> get copyWith => __$StunTestParamsCopyWithImpl<_StunTestParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StunTestParamsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StunTestParams&&(identical(other.server, server) || other.server == server)&&(identical(other.proxy, proxy) || other.proxy == proxy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,server,proxy);
}

@override
String toString() {
    return 'StunTestParams(server: $server, proxy: $proxy)';
}


}

/// @nodoc
abstract mixin class _$StunTestParamsCopyWith<$Res> implements $StunTestParamsCopyWith<$Res> {
  factory _$StunTestParamsCopyWith(_StunTestParams value, $Res Function(_StunTestParams) _then) = __$StunTestParamsCopyWithImpl;
@override @useResult
$Res call({
 String server, String proxy
});




}
/// @nodoc
class __$StunTestParamsCopyWithImpl<$Res>
    implements _$StunTestParamsCopyWith<$Res> {
  __$StunTestParamsCopyWithImpl(this._self, this._then);

  final _StunTestParams _self;
  final $Res Function(_StunTestParams) _then;

/// Create a copy of StunTestParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? server = null,Object? proxy = null,}) {
  return _then(_StunTestParams(
server: null == server ? _self.server : server // ignore: cast_nullable_to_non_nullable
as String,proxy: null == proxy ? _self.proxy : proxy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$StunTestState {

 String get phase; double get progress; String get server; String get address; bool get direct; SpeedTestOutbound? get outbound;@JsonKey(name: 'nat-type') String get natType; String get mapping; String get filtering; bool get public;@JsonKey(name: 'rfc5780') bool get rfc5780;@JsonKey(name: 'external-ip') String get externalIp;@JsonKey(name: 'external-port') int get externalPort;@JsonKey(name: 'local-ip') String get localIp;@JsonKey(name: 'local-port') int get localPort;@JsonKey(name: 'port-preserved') int get portPreserved;@JsonKey(name: 'other-address') String get otherAddress; String get software; double get latency; double get jitter;@JsonKey(name: 'packet-loss') double get packetLoss; String get error;
/// Create a copy of StunTestState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StunTestStateCopyWith<StunTestState> get copyWith => _$StunTestStateCopyWithImpl<StunTestState>(this as StunTestState, _$identity);

  /// Serializes this StunTestState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StunTestState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StunTestState&&(identical(other.phase, _this.phase) || other.phase == _this.phase)&&(identical(other.progress, _this.progress) || other.progress == _this.progress)&&(identical(other.server, _this.server) || other.server == _this.server)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.direct, _this.direct) || other.direct == _this.direct)&&(identical(other.outbound, _this.outbound) || other.outbound == _this.outbound)&&(identical(other.natType, _this.natType) || other.natType == _this.natType)&&(identical(other.mapping, _this.mapping) || other.mapping == _this.mapping)&&(identical(other.filtering, _this.filtering) || other.filtering == _this.filtering)&&(identical(other.public, _this.public) || other.public == _this.public)&&(identical(other.rfc5780, _this.rfc5780) || other.rfc5780 == _this.rfc5780)&&(identical(other.externalIp, _this.externalIp) || other.externalIp == _this.externalIp)&&(identical(other.externalPort, _this.externalPort) || other.externalPort == _this.externalPort)&&(identical(other.localIp, _this.localIp) || other.localIp == _this.localIp)&&(identical(other.localPort, _this.localPort) || other.localPort == _this.localPort)&&(identical(other.portPreserved, _this.portPreserved) || other.portPreserved == _this.portPreserved)&&(identical(other.otherAddress, _this.otherAddress) || other.otherAddress == _this.otherAddress)&&(identical(other.software, _this.software) || other.software == _this.software)&&(identical(other.latency, _this.latency) || other.latency == _this.latency)&&(identical(other.jitter, _this.jitter) || other.jitter == _this.jitter)&&(identical(other.packetLoss, _this.packetLoss) || other.packetLoss == _this.packetLoss)&&(identical(other.error, _this.error) || other.error == _this.error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StunTestState;
  return Object.hashAll([runtimeType,_this.phase,_this.progress,_this.server,_this.address,_this.direct,_this.outbound,_this.natType,_this.mapping,_this.filtering,_this.public,_this.rfc5780,_this.externalIp,_this.externalPort,_this.localIp,_this.localPort,_this.portPreserved,_this.otherAddress,_this.software,_this.latency,_this.jitter,_this.packetLoss,_this.error]);
}

@override
String toString() {
  final _this = this as StunTestState;
  return 'StunTestState(phase: ${_this.phase}, progress: ${_this.progress}, server: ${_this.server}, address: ${_this.address}, direct: ${_this.direct}, outbound: ${_this.outbound}, natType: ${_this.natType}, mapping: ${_this.mapping}, filtering: ${_this.filtering}, public: ${_this.public}, rfc5780: ${_this.rfc5780}, externalIp: ${_this.externalIp}, externalPort: ${_this.externalPort}, localIp: ${_this.localIp}, localPort: ${_this.localPort}, portPreserved: ${_this.portPreserved}, otherAddress: ${_this.otherAddress}, software: ${_this.software}, latency: ${_this.latency}, jitter: ${_this.jitter}, packetLoss: ${_this.packetLoss}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $StunTestStateCopyWith<$Res>  {
  factory $StunTestStateCopyWith(StunTestState value, $Res Function(StunTestState) _then) = _$StunTestStateCopyWithImpl;
@useResult
$Res call({
 String phase, double progress, String server, String address, bool direct, SpeedTestOutbound? outbound,@JsonKey(name: 'nat-type') String natType, String mapping, String filtering, bool public,@JsonKey(name: 'rfc5780') bool rfc5780,@JsonKey(name: 'external-ip') String externalIp,@JsonKey(name: 'external-port') int externalPort,@JsonKey(name: 'local-ip') String localIp,@JsonKey(name: 'local-port') int localPort,@JsonKey(name: 'port-preserved') int portPreserved,@JsonKey(name: 'other-address') String otherAddress, String software, double latency, double jitter,@JsonKey(name: 'packet-loss') double packetLoss, String error
});


$SpeedTestOutboundCopyWith<$Res>? get outbound;

}
/// @nodoc
class _$StunTestStateCopyWithImpl<$Res>
    implements $StunTestStateCopyWith<$Res> {
  _$StunTestStateCopyWithImpl(this._self, this._then);

  final StunTestState _self;
  final $Res Function(StunTestState) _then;

/// Create a copy of StunTestState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phase = null,Object? progress = null,Object? server = null,Object? address = null,Object? direct = null,Object? outbound = freezed,Object? natType = null,Object? mapping = null,Object? filtering = null,Object? public = null,Object? rfc5780 = null,Object? externalIp = null,Object? externalPort = null,Object? localIp = null,Object? localPort = null,Object? portPreserved = null,Object? otherAddress = null,Object? software = null,Object? latency = null,Object? jitter = null,Object? packetLoss = null,Object? error = null,}) {
  return _then(StunTestState(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as String,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,server: null == server ? _self.server : server // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,direct: null == direct ? _self.direct : direct // ignore: cast_nullable_to_non_nullable
as bool,outbound: freezed == outbound ? _self.outbound : outbound // ignore: cast_nullable_to_non_nullable
as SpeedTestOutbound?,natType: null == natType ? _self.natType : natType // ignore: cast_nullable_to_non_nullable
as String,mapping: null == mapping ? _self.mapping : mapping // ignore: cast_nullable_to_non_nullable
as String,filtering: null == filtering ? _self.filtering : filtering // ignore: cast_nullable_to_non_nullable
as String,public: null == public ? _self.public : public // ignore: cast_nullable_to_non_nullable
as bool,rfc5780: null == rfc5780 ? _self.rfc5780 : rfc5780 // ignore: cast_nullable_to_non_nullable
as bool,externalIp: null == externalIp ? _self.externalIp : externalIp // ignore: cast_nullable_to_non_nullable
as String,externalPort: null == externalPort ? _self.externalPort : externalPort // ignore: cast_nullable_to_non_nullable
as int,localIp: null == localIp ? _self.localIp : localIp // ignore: cast_nullable_to_non_nullable
as String,localPort: null == localPort ? _self.localPort : localPort // ignore: cast_nullable_to_non_nullable
as int,portPreserved: null == portPreserved ? _self.portPreserved : portPreserved // ignore: cast_nullable_to_non_nullable
as int,otherAddress: null == otherAddress ? _self.otherAddress : otherAddress // ignore: cast_nullable_to_non_nullable
as String,software: null == software ? _self.software : software // ignore: cast_nullable_to_non_nullable
as String,latency: null == latency ? _self.latency : latency // ignore: cast_nullable_to_non_nullable
as double,jitter: null == jitter ? _self.jitter : jitter // ignore: cast_nullable_to_non_nullable
as double,packetLoss: null == packetLoss ? _self.packetLoss : packetLoss // ignore: cast_nullable_to_non_nullable
as double,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of StunTestState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpeedTestOutboundCopyWith<$Res>? get outbound {
    if (_self.outbound == null) {
    return null;
  }

  return $SpeedTestOutboundCopyWith<$Res>(_self.outbound!, (value) {
    return _then(_self.copyWith(outbound: value));
  });
}
}


/// Adds pattern-matching-related methods to [StunTestState].
extension StunTestStatePatterns on StunTestState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StunTestState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StunTestState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StunTestState value)  $default,){
final _that = this;
switch (_that) {
case _StunTestState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StunTestState value)?  $default,){
final _that = this;
switch (_that) {
case _StunTestState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String phase,  double progress,  String server,  String address,  bool direct,  SpeedTestOutbound? outbound, @JsonKey(name: 'nat-type')  String natType,  String mapping,  String filtering,  bool public, @JsonKey(name: 'rfc5780')  bool rfc5780, @JsonKey(name: 'external-ip')  String externalIp, @JsonKey(name: 'external-port')  int externalPort, @JsonKey(name: 'local-ip')  String localIp, @JsonKey(name: 'local-port')  int localPort, @JsonKey(name: 'port-preserved')  int portPreserved, @JsonKey(name: 'other-address')  String otherAddress,  String software,  double latency,  double jitter, @JsonKey(name: 'packet-loss')  double packetLoss,  String error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StunTestState() when $default != null:
return $default(_that.phase,_that.progress,_that.server,_that.address,_that.direct,_that.outbound,_that.natType,_that.mapping,_that.filtering,_that.public,_that.rfc5780,_that.externalIp,_that.externalPort,_that.localIp,_that.localPort,_that.portPreserved,_that.otherAddress,_that.software,_that.latency,_that.jitter,_that.packetLoss,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String phase,  double progress,  String server,  String address,  bool direct,  SpeedTestOutbound? outbound, @JsonKey(name: 'nat-type')  String natType,  String mapping,  String filtering,  bool public, @JsonKey(name: 'rfc5780')  bool rfc5780, @JsonKey(name: 'external-ip')  String externalIp, @JsonKey(name: 'external-port')  int externalPort, @JsonKey(name: 'local-ip')  String localIp, @JsonKey(name: 'local-port')  int localPort, @JsonKey(name: 'port-preserved')  int portPreserved, @JsonKey(name: 'other-address')  String otherAddress,  String software,  double latency,  double jitter, @JsonKey(name: 'packet-loss')  double packetLoss,  String error)  $default,) {final _that = this;
switch (_that) {
case _StunTestState():
return $default(_that.phase,_that.progress,_that.server,_that.address,_that.direct,_that.outbound,_that.natType,_that.mapping,_that.filtering,_that.public,_that.rfc5780,_that.externalIp,_that.externalPort,_that.localIp,_that.localPort,_that.portPreserved,_that.otherAddress,_that.software,_that.latency,_that.jitter,_that.packetLoss,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String phase,  double progress,  String server,  String address,  bool direct,  SpeedTestOutbound? outbound, @JsonKey(name: 'nat-type')  String natType,  String mapping,  String filtering,  bool public, @JsonKey(name: 'rfc5780')  bool rfc5780, @JsonKey(name: 'external-ip')  String externalIp, @JsonKey(name: 'external-port')  int externalPort, @JsonKey(name: 'local-ip')  String localIp, @JsonKey(name: 'local-port')  int localPort, @JsonKey(name: 'port-preserved')  int portPreserved, @JsonKey(name: 'other-address')  String otherAddress,  String software,  double latency,  double jitter, @JsonKey(name: 'packet-loss')  double packetLoss,  String error)?  $default,) {final _that = this;
switch (_that) {
case _StunTestState() when $default != null:
return $default(_that.phase,_that.progress,_that.server,_that.address,_that.direct,_that.outbound,_that.natType,_that.mapping,_that.filtering,_that.public,_that.rfc5780,_that.externalIp,_that.externalPort,_that.localIp,_that.localPort,_that.portPreserved,_that.otherAddress,_that.software,_that.latency,_that.jitter,_that.packetLoss,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StunTestState implements StunTestState {
  const _StunTestState({this.phase = '', this.progress = 0.0, this.server = '', this.address = '', this.direct = false, this.outbound, @JsonKey(name: 'nat-type') this.natType = '', this.mapping = '', this.filtering = '', this.public = false, @JsonKey(name: 'rfc5780') this.rfc5780 = false, @JsonKey(name: 'external-ip') this.externalIp = '', @JsonKey(name: 'external-port') this.externalPort = 0, @JsonKey(name: 'local-ip') this.localIp = '', @JsonKey(name: 'local-port') this.localPort = 0, @JsonKey(name: 'port-preserved') this.portPreserved = 0, @JsonKey(name: 'other-address') this.otherAddress = '', this.software = '', this.latency = 0.0, this.jitter = 0.0, @JsonKey(name: 'packet-loss') this.packetLoss = 0.0, this.error = ''});
  factory _StunTestState.fromJson(Map<String, dynamic> json) => _$StunTestStateFromJson(json);

@override@JsonKey() final  String phase;
@override@JsonKey() final  double progress;
@override@JsonKey() final  String server;
@override@JsonKey() final  String address;
@override@JsonKey() final  bool direct;
@override final  SpeedTestOutbound? outbound;
@override@JsonKey(name: 'nat-type') final  String natType;
@override@JsonKey() final  String mapping;
@override@JsonKey() final  String filtering;
@override@JsonKey() final  bool public;
@override@JsonKey(name: 'rfc5780') final  bool rfc5780;
@override@JsonKey(name: 'external-ip') final  String externalIp;
@override@JsonKey(name: 'external-port') final  int externalPort;
@override@JsonKey(name: 'local-ip') final  String localIp;
@override@JsonKey(name: 'local-port') final  int localPort;
@override@JsonKey(name: 'port-preserved') final  int portPreserved;
@override@JsonKey(name: 'other-address') final  String otherAddress;
@override@JsonKey() final  String software;
@override@JsonKey() final  double latency;
@override@JsonKey() final  double jitter;
@override@JsonKey(name: 'packet-loss') final  double packetLoss;
@override@JsonKey() final  String error;

/// Create a copy of StunTestState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StunTestStateCopyWith<_StunTestState> get copyWith => __$StunTestStateCopyWithImpl<_StunTestState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StunTestStateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StunTestState&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.server, server) || other.server == server)&&(identical(other.address, address) || other.address == address)&&(identical(other.direct, direct) || other.direct == direct)&&(identical(other.outbound, outbound) || other.outbound == outbound)&&(identical(other.natType, natType) || other.natType == natType)&&(identical(other.mapping, mapping) || other.mapping == mapping)&&(identical(other.filtering, filtering) || other.filtering == filtering)&&(identical(other.public, public) || other.public == public)&&(identical(other.rfc5780, rfc5780) || other.rfc5780 == rfc5780)&&(identical(other.externalIp, externalIp) || other.externalIp == externalIp)&&(identical(other.externalPort, externalPort) || other.externalPort == externalPort)&&(identical(other.localIp, localIp) || other.localIp == localIp)&&(identical(other.localPort, localPort) || other.localPort == localPort)&&(identical(other.portPreserved, portPreserved) || other.portPreserved == portPreserved)&&(identical(other.otherAddress, otherAddress) || other.otherAddress == otherAddress)&&(identical(other.software, software) || other.software == software)&&(identical(other.latency, latency) || other.latency == latency)&&(identical(other.jitter, jitter) || other.jitter == jitter)&&(identical(other.packetLoss, packetLoss) || other.packetLoss == packetLoss)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,phase,progress,server,address,direct,outbound,natType,mapping,filtering,public,rfc5780,externalIp,externalPort,localIp,localPort,portPreserved,otherAddress,software,latency,jitter,packetLoss,error]);
}

@override
String toString() {
    return 'StunTestState(phase: $phase, progress: $progress, server: $server, address: $address, direct: $direct, outbound: $outbound, natType: $natType, mapping: $mapping, filtering: $filtering, public: $public, rfc5780: $rfc5780, externalIp: $externalIp, externalPort: $externalPort, localIp: $localIp, localPort: $localPort, portPreserved: $portPreserved, otherAddress: $otherAddress, software: $software, latency: $latency, jitter: $jitter, packetLoss: $packetLoss, error: $error)';
}


}

/// @nodoc
abstract mixin class _$StunTestStateCopyWith<$Res> implements $StunTestStateCopyWith<$Res> {
  factory _$StunTestStateCopyWith(_StunTestState value, $Res Function(_StunTestState) _then) = __$StunTestStateCopyWithImpl;
@override @useResult
$Res call({
 String phase, double progress, String server, String address, bool direct, SpeedTestOutbound? outbound,@JsonKey(name: 'nat-type') String natType, String mapping, String filtering, bool public,@JsonKey(name: 'rfc5780') bool rfc5780,@JsonKey(name: 'external-ip') String externalIp,@JsonKey(name: 'external-port') int externalPort,@JsonKey(name: 'local-ip') String localIp,@JsonKey(name: 'local-port') int localPort,@JsonKey(name: 'port-preserved') int portPreserved,@JsonKey(name: 'other-address') String otherAddress, String software, double latency, double jitter,@JsonKey(name: 'packet-loss') double packetLoss, String error
});


@override $SpeedTestOutboundCopyWith<$Res>? get outbound;

}
/// @nodoc
class __$StunTestStateCopyWithImpl<$Res>
    implements _$StunTestStateCopyWith<$Res> {
  __$StunTestStateCopyWithImpl(this._self, this._then);

  final _StunTestState _self;
  final $Res Function(_StunTestState) _then;

/// Create a copy of StunTestState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phase = null,Object? progress = null,Object? server = null,Object? address = null,Object? direct = null,Object? outbound = freezed,Object? natType = null,Object? mapping = null,Object? filtering = null,Object? public = null,Object? rfc5780 = null,Object? externalIp = null,Object? externalPort = null,Object? localIp = null,Object? localPort = null,Object? portPreserved = null,Object? otherAddress = null,Object? software = null,Object? latency = null,Object? jitter = null,Object? packetLoss = null,Object? error = null,}) {
  return _then(_StunTestState(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as String,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,server: null == server ? _self.server : server // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,direct: null == direct ? _self.direct : direct // ignore: cast_nullable_to_non_nullable
as bool,outbound: freezed == outbound ? _self.outbound : outbound // ignore: cast_nullable_to_non_nullable
as SpeedTestOutbound?,natType: null == natType ? _self.natType : natType // ignore: cast_nullable_to_non_nullable
as String,mapping: null == mapping ? _self.mapping : mapping // ignore: cast_nullable_to_non_nullable
as String,filtering: null == filtering ? _self.filtering : filtering // ignore: cast_nullable_to_non_nullable
as String,public: null == public ? _self.public : public // ignore: cast_nullable_to_non_nullable
as bool,rfc5780: null == rfc5780 ? _self.rfc5780 : rfc5780 // ignore: cast_nullable_to_non_nullable
as bool,externalIp: null == externalIp ? _self.externalIp : externalIp // ignore: cast_nullable_to_non_nullable
as String,externalPort: null == externalPort ? _self.externalPort : externalPort // ignore: cast_nullable_to_non_nullable
as int,localIp: null == localIp ? _self.localIp : localIp // ignore: cast_nullable_to_non_nullable
as String,localPort: null == localPort ? _self.localPort : localPort // ignore: cast_nullable_to_non_nullable
as int,portPreserved: null == portPreserved ? _self.portPreserved : portPreserved // ignore: cast_nullable_to_non_nullable
as int,otherAddress: null == otherAddress ? _self.otherAddress : otherAddress // ignore: cast_nullable_to_non_nullable
as String,software: null == software ? _self.software : software // ignore: cast_nullable_to_non_nullable
as String,latency: null == latency ? _self.latency : latency // ignore: cast_nullable_to_non_nullable
as double,jitter: null == jitter ? _self.jitter : jitter // ignore: cast_nullable_to_non_nullable
as double,packetLoss: null == packetLoss ? _self.packetLoss : packetLoss // ignore: cast_nullable_to_non_nullable
as double,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of StunTestState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpeedTestOutboundCopyWith<$Res>? get outbound {
    if (_self.outbound == null) {
    return null;
  }

  return $SpeedTestOutboundCopyWith<$Res>(_self.outbound!, (value) {
    return _then(_self.copyWith(outbound: value));
  });
}
}


/// @nodoc
mixin _$LocalPingParams {

 String get target; String get protocol; int get port; int get count; int get interval; int get size;
/// Create a copy of LocalPingParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalPingParamsCopyWith<LocalPingParams> get copyWith => _$LocalPingParamsCopyWithImpl<LocalPingParams>(this as LocalPingParams, _$identity);

  /// Serializes this LocalPingParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LocalPingParams;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalPingParams&&(identical(other.target, _this.target) || other.target == _this.target)&&(identical(other.protocol, _this.protocol) || other.protocol == _this.protocol)&&(identical(other.port, _this.port) || other.port == _this.port)&&(identical(other.count, _this.count) || other.count == _this.count)&&(identical(other.interval, _this.interval) || other.interval == _this.interval)&&(identical(other.size, _this.size) || other.size == _this.size));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LocalPingParams;
  return Object.hash(runtimeType,_this.target,_this.protocol,_this.port,_this.count,_this.interval,_this.size);
}

@override
String toString() {
  final _this = this as LocalPingParams;
  return 'LocalPingParams(target: ${_this.target}, protocol: ${_this.protocol}, port: ${_this.port}, count: ${_this.count}, interval: ${_this.interval}, size: ${_this.size})';
}


}

/// @nodoc
abstract mixin class $LocalPingParamsCopyWith<$Res>  {
  factory $LocalPingParamsCopyWith(LocalPingParams value, $Res Function(LocalPingParams) _then) = _$LocalPingParamsCopyWithImpl;
@useResult
$Res call({
 String target, String protocol, int port, int count, int interval, int size
});




}
/// @nodoc
class _$LocalPingParamsCopyWithImpl<$Res>
    implements $LocalPingParamsCopyWith<$Res> {
  _$LocalPingParamsCopyWithImpl(this._self, this._then);

  final LocalPingParams _self;
  final $Res Function(LocalPingParams) _then;

/// Create a copy of LocalPingParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? target = null,Object? protocol = null,Object? port = null,Object? count = null,Object? interval = null,Object? size = null,}) {
  return _then(LocalPingParams(
target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,protocol: null == protocol ? _self.protocol : protocol // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LocalPingParams].
extension LocalPingParamsPatterns on LocalPingParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocalPingParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocalPingParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocalPingParams value)  $default,){
final _that = this;
switch (_that) {
case _LocalPingParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocalPingParams value)?  $default,){
final _that = this;
switch (_that) {
case _LocalPingParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String target,  String protocol,  int port,  int count,  int interval,  int size)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocalPingParams() when $default != null:
return $default(_that.target,_that.protocol,_that.port,_that.count,_that.interval,_that.size);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String target,  String protocol,  int port,  int count,  int interval,  int size)  $default,) {final _that = this;
switch (_that) {
case _LocalPingParams():
return $default(_that.target,_that.protocol,_that.port,_that.count,_that.interval,_that.size);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String target,  String protocol,  int port,  int count,  int interval,  int size)?  $default,) {final _that = this;
switch (_that) {
case _LocalPingParams() when $default != null:
return $default(_that.target,_that.protocol,_that.port,_that.count,_that.interval,_that.size);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LocalPingParams implements LocalPingParams {
  const _LocalPingParams({required this.target, this.protocol = 'icmp', this.port = 0, this.count = 10, this.interval = 1000, this.size = 0});
  factory _LocalPingParams.fromJson(Map<String, dynamic> json) => _$LocalPingParamsFromJson(json);

@override final  String target;
@override@JsonKey() final  String protocol;
@override@JsonKey() final  int port;
@override@JsonKey() final  int count;
@override@JsonKey() final  int interval;
@override@JsonKey() final  int size;

/// Create a copy of LocalPingParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocalPingParamsCopyWith<_LocalPingParams> get copyWith => __$LocalPingParamsCopyWithImpl<_LocalPingParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LocalPingParamsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocalPingParams&&(identical(other.target, target) || other.target == target)&&(identical(other.protocol, protocol) || other.protocol == protocol)&&(identical(other.port, port) || other.port == port)&&(identical(other.count, count) || other.count == count)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.size, size) || other.size == size));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,target,protocol,port,count,interval,size);
}

@override
String toString() {
    return 'LocalPingParams(target: $target, protocol: $protocol, port: $port, count: $count, interval: $interval, size: $size)';
}


}

/// @nodoc
abstract mixin class _$LocalPingParamsCopyWith<$Res> implements $LocalPingParamsCopyWith<$Res> {
  factory _$LocalPingParamsCopyWith(_LocalPingParams value, $Res Function(_LocalPingParams) _then) = __$LocalPingParamsCopyWithImpl;
@override @useResult
$Res call({
 String target, String protocol, int port, int count, int interval, int size
});




}
/// @nodoc
class __$LocalPingParamsCopyWithImpl<$Res>
    implements _$LocalPingParamsCopyWith<$Res> {
  __$LocalPingParamsCopyWithImpl(this._self, this._then);

  final _LocalPingParams _self;
  final $Res Function(_LocalPingParams) _then;

/// Create a copy of LocalPingParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? target = null,Object? protocol = null,Object? port = null,Object? count = null,Object? interval = null,Object? size = null,}) {
  return _then(_LocalPingParams(
target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,protocol: null == protocol ? _self.protocol : protocol // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$LocalPingReply {

 int get seq; String get status; double get rtt; int get ttl; int get bytes;
/// Create a copy of LocalPingReply
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalPingReplyCopyWith<LocalPingReply> get copyWith => _$LocalPingReplyCopyWithImpl<LocalPingReply>(this as LocalPingReply, _$identity);

  /// Serializes this LocalPingReply to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LocalPingReply;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalPingReply&&(identical(other.seq, _this.seq) || other.seq == _this.seq)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.rtt, _this.rtt) || other.rtt == _this.rtt)&&(identical(other.ttl, _this.ttl) || other.ttl == _this.ttl)&&(identical(other.bytes, _this.bytes) || other.bytes == _this.bytes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LocalPingReply;
  return Object.hash(runtimeType,_this.seq,_this.status,_this.rtt,_this.ttl,_this.bytes);
}

@override
String toString() {
  final _this = this as LocalPingReply;
  return 'LocalPingReply(seq: ${_this.seq}, status: ${_this.status}, rtt: ${_this.rtt}, ttl: ${_this.ttl}, bytes: ${_this.bytes})';
}


}

/// @nodoc
abstract mixin class $LocalPingReplyCopyWith<$Res>  {
  factory $LocalPingReplyCopyWith(LocalPingReply value, $Res Function(LocalPingReply) _then) = _$LocalPingReplyCopyWithImpl;
@useResult
$Res call({
 int seq, String status, double rtt, int ttl, int bytes
});




}
/// @nodoc
class _$LocalPingReplyCopyWithImpl<$Res>
    implements $LocalPingReplyCopyWith<$Res> {
  _$LocalPingReplyCopyWithImpl(this._self, this._then);

  final LocalPingReply _self;
  final $Res Function(LocalPingReply) _then;

/// Create a copy of LocalPingReply
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? seq = null,Object? status = null,Object? rtt = null,Object? ttl = null,Object? bytes = null,}) {
  return _then(LocalPingReply(
seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,rtt: null == rtt ? _self.rtt : rtt // ignore: cast_nullable_to_non_nullable
as double,ttl: null == ttl ? _self.ttl : ttl // ignore: cast_nullable_to_non_nullable
as int,bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LocalPingReply].
extension LocalPingReplyPatterns on LocalPingReply {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocalPingReply value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocalPingReply() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocalPingReply value)  $default,){
final _that = this;
switch (_that) {
case _LocalPingReply():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocalPingReply value)?  $default,){
final _that = this;
switch (_that) {
case _LocalPingReply() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int seq,  String status,  double rtt,  int ttl,  int bytes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocalPingReply() when $default != null:
return $default(_that.seq,_that.status,_that.rtt,_that.ttl,_that.bytes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int seq,  String status,  double rtt,  int ttl,  int bytes)  $default,) {final _that = this;
switch (_that) {
case _LocalPingReply():
return $default(_that.seq,_that.status,_that.rtt,_that.ttl,_that.bytes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int seq,  String status,  double rtt,  int ttl,  int bytes)?  $default,) {final _that = this;
switch (_that) {
case _LocalPingReply() when $default != null:
return $default(_that.seq,_that.status,_that.rtt,_that.ttl,_that.bytes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LocalPingReply implements LocalPingReply {
  const _LocalPingReply({this.seq = 0, this.status = '', this.rtt = 0.0, this.ttl = 0, this.bytes = 0});
  factory _LocalPingReply.fromJson(Map<String, dynamic> json) => _$LocalPingReplyFromJson(json);

@override@JsonKey() final  int seq;
@override@JsonKey() final  String status;
@override@JsonKey() final  double rtt;
@override@JsonKey() final  int ttl;
@override@JsonKey() final  int bytes;

/// Create a copy of LocalPingReply
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocalPingReplyCopyWith<_LocalPingReply> get copyWith => __$LocalPingReplyCopyWithImpl<_LocalPingReply>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LocalPingReplyToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocalPingReply&&(identical(other.seq, seq) || other.seq == seq)&&(identical(other.status, status) || other.status == status)&&(identical(other.rtt, rtt) || other.rtt == rtt)&&(identical(other.ttl, ttl) || other.ttl == ttl)&&(identical(other.bytes, bytes) || other.bytes == bytes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,seq,status,rtt,ttl,bytes);
}

@override
String toString() {
    return 'LocalPingReply(seq: $seq, status: $status, rtt: $rtt, ttl: $ttl, bytes: $bytes)';
}


}

/// @nodoc
abstract mixin class _$LocalPingReplyCopyWith<$Res> implements $LocalPingReplyCopyWith<$Res> {
  factory _$LocalPingReplyCopyWith(_LocalPingReply value, $Res Function(_LocalPingReply) _then) = __$LocalPingReplyCopyWithImpl;
@override @useResult
$Res call({
 int seq, String status, double rtt, int ttl, int bytes
});




}
/// @nodoc
class __$LocalPingReplyCopyWithImpl<$Res>
    implements _$LocalPingReplyCopyWith<$Res> {
  __$LocalPingReplyCopyWithImpl(this._self, this._then);

  final _LocalPingReply _self;
  final $Res Function(_LocalPingReply) _then;

/// Create a copy of LocalPingReply
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? seq = null,Object? status = null,Object? rtt = null,Object? ttl = null,Object? bytes = null,}) {
  return _then(_LocalPingReply(
seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,rtt: null == rtt ? _self.rtt : rtt // ignore: cast_nullable_to_non_nullable
as double,ttl: null == ttl ? _self.ttl : ttl // ignore: cast_nullable_to_non_nullable
as int,bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$LocalPingState {

 int get session; String get phase; String get target; String get address; String get protocol; int get port; int get size; int get count; int get interval; int get sent; double get elapsed; LocalPingReply? get reply; List<LocalPingReply> get replies; String get error;
/// Create a copy of LocalPingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalPingStateCopyWith<LocalPingState> get copyWith => _$LocalPingStateCopyWithImpl<LocalPingState>(this as LocalPingState, _$identity);

  /// Serializes this LocalPingState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LocalPingState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalPingState&&(identical(other.session, _this.session) || other.session == _this.session)&&(identical(other.phase, _this.phase) || other.phase == _this.phase)&&(identical(other.target, _this.target) || other.target == _this.target)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.protocol, _this.protocol) || other.protocol == _this.protocol)&&(identical(other.port, _this.port) || other.port == _this.port)&&(identical(other.size, _this.size) || other.size == _this.size)&&(identical(other.count, _this.count) || other.count == _this.count)&&(identical(other.interval, _this.interval) || other.interval == _this.interval)&&(identical(other.sent, _this.sent) || other.sent == _this.sent)&&(identical(other.elapsed, _this.elapsed) || other.elapsed == _this.elapsed)&&(identical(other.reply, _this.reply) || other.reply == _this.reply)&&const DeepCollectionEquality().equals(other.replies, _this.replies)&&(identical(other.error, _this.error) || other.error == _this.error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LocalPingState;
  return Object.hash(runtimeType,_this.session,_this.phase,_this.target,_this.address,_this.protocol,_this.port,_this.size,_this.count,_this.interval,_this.sent,_this.elapsed,_this.reply,const DeepCollectionEquality().hash(_this.replies),_this.error);
}

@override
String toString() {
  final _this = this as LocalPingState;
  return 'LocalPingState(session: ${_this.session}, phase: ${_this.phase}, target: ${_this.target}, address: ${_this.address}, protocol: ${_this.protocol}, port: ${_this.port}, size: ${_this.size}, count: ${_this.count}, interval: ${_this.interval}, sent: ${_this.sent}, elapsed: ${_this.elapsed}, reply: ${_this.reply}, replies: ${_this.replies}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $LocalPingStateCopyWith<$Res>  {
  factory $LocalPingStateCopyWith(LocalPingState value, $Res Function(LocalPingState) _then) = _$LocalPingStateCopyWithImpl;
@useResult
$Res call({
 int session, String phase, String target, String address, String protocol, int port, int size, int count, int interval, int sent, double elapsed, LocalPingReply? reply, List<LocalPingReply> replies, String error
});


$LocalPingReplyCopyWith<$Res>? get reply;

}
/// @nodoc
class _$LocalPingStateCopyWithImpl<$Res>
    implements $LocalPingStateCopyWith<$Res> {
  _$LocalPingStateCopyWithImpl(this._self, this._then);

  final LocalPingState _self;
  final $Res Function(LocalPingState) _then;

/// Create a copy of LocalPingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? session = null,Object? phase = null,Object? target = null,Object? address = null,Object? protocol = null,Object? port = null,Object? size = null,Object? count = null,Object? interval = null,Object? sent = null,Object? elapsed = null,Object? reply = freezed,Object? replies = null,Object? error = null,}) {
  return _then(LocalPingState(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as int,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as String,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,protocol: null == protocol ? _self.protocol : protocol // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,sent: null == sent ? _self.sent : sent // ignore: cast_nullable_to_non_nullable
as int,elapsed: null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as double,reply: freezed == reply ? _self.reply : reply // ignore: cast_nullable_to_non_nullable
as LocalPingReply?,replies: null == replies ? _self.replies : replies // ignore: cast_nullable_to_non_nullable
as List<LocalPingReply>,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of LocalPingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalPingReplyCopyWith<$Res>? get reply {
    if (_self.reply == null) {
    return null;
  }

  return $LocalPingReplyCopyWith<$Res>(_self.reply!, (value) {
    return _then(_self.copyWith(reply: value));
  });
}
}


/// Adds pattern-matching-related methods to [LocalPingState].
extension LocalPingStatePatterns on LocalPingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocalPingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocalPingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocalPingState value)  $default,){
final _that = this;
switch (_that) {
case _LocalPingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocalPingState value)?  $default,){
final _that = this;
switch (_that) {
case _LocalPingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int session,  String phase,  String target,  String address,  String protocol,  int port,  int size,  int count,  int interval,  int sent,  double elapsed,  LocalPingReply? reply,  List<LocalPingReply> replies,  String error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocalPingState() when $default != null:
return $default(_that.session,_that.phase,_that.target,_that.address,_that.protocol,_that.port,_that.size,_that.count,_that.interval,_that.sent,_that.elapsed,_that.reply,_that.replies,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int session,  String phase,  String target,  String address,  String protocol,  int port,  int size,  int count,  int interval,  int sent,  double elapsed,  LocalPingReply? reply,  List<LocalPingReply> replies,  String error)  $default,) {final _that = this;
switch (_that) {
case _LocalPingState():
return $default(_that.session,_that.phase,_that.target,_that.address,_that.protocol,_that.port,_that.size,_that.count,_that.interval,_that.sent,_that.elapsed,_that.reply,_that.replies,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int session,  String phase,  String target,  String address,  String protocol,  int port,  int size,  int count,  int interval,  int sent,  double elapsed,  LocalPingReply? reply,  List<LocalPingReply> replies,  String error)?  $default,) {final _that = this;
switch (_that) {
case _LocalPingState() when $default != null:
return $default(_that.session,_that.phase,_that.target,_that.address,_that.protocol,_that.port,_that.size,_that.count,_that.interval,_that.sent,_that.elapsed,_that.reply,_that.replies,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LocalPingState implements LocalPingState {
  const _LocalPingState({this.session = 0, this.phase = '', this.target = '', this.address = '', this.protocol = '', this.port = 0, this.size = 0, this.count = 0, this.interval = 0, this.sent = 0, this.elapsed = 0.0, this.reply,  List<LocalPingReply> replies = const [], this.error = ''}): _replies = replies;
  factory _LocalPingState.fromJson(Map<String, dynamic> json) => _$LocalPingStateFromJson(json);

@override@JsonKey() final  int session;
@override@JsonKey() final  String phase;
@override@JsonKey() final  String target;
@override@JsonKey() final  String address;
@override@JsonKey() final  String protocol;
@override@JsonKey() final  int port;
@override@JsonKey() final  int size;
@override@JsonKey() final  int count;
@override@JsonKey() final  int interval;
@override@JsonKey() final  int sent;
@override@JsonKey() final  double elapsed;
@override final  LocalPingReply? reply;
 final  List<LocalPingReply> _replies;
@override@JsonKey() List<LocalPingReply> get replies {
  if (_replies is EqualUnmodifiableListView) return _replies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_replies);
}

@override@JsonKey() final  String error;

/// Create a copy of LocalPingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocalPingStateCopyWith<_LocalPingState> get copyWith => __$LocalPingStateCopyWithImpl<_LocalPingState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LocalPingStateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocalPingState&&(identical(other.session, session) || other.session == session)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.target, target) || other.target == target)&&(identical(other.address, address) || other.address == address)&&(identical(other.protocol, protocol) || other.protocol == protocol)&&(identical(other.port, port) || other.port == port)&&(identical(other.size, size) || other.size == size)&&(identical(other.count, count) || other.count == count)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.sent, sent) || other.sent == sent)&&(identical(other.elapsed, elapsed) || other.elapsed == elapsed)&&(identical(other.reply, reply) || other.reply == reply)&&const DeepCollectionEquality().equals(other.replies, _replies)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,session,phase,target,address,protocol,port,size,count,interval,sent,elapsed,reply,const DeepCollectionEquality().hash(_replies),error);
}

@override
String toString() {
    return 'LocalPingState(session: $session, phase: $phase, target: $target, address: $address, protocol: $protocol, port: $port, size: $size, count: $count, interval: $interval, sent: $sent, elapsed: $elapsed, reply: $reply, replies: $replies, error: $error)';
}


}

/// @nodoc
abstract mixin class _$LocalPingStateCopyWith<$Res> implements $LocalPingStateCopyWith<$Res> {
  factory _$LocalPingStateCopyWith(_LocalPingState value, $Res Function(_LocalPingState) _then) = __$LocalPingStateCopyWithImpl;
@override @useResult
$Res call({
 int session, String phase, String target, String address, String protocol, int port, int size, int count, int interval, int sent, double elapsed, LocalPingReply? reply, List<LocalPingReply> replies, String error
});


@override $LocalPingReplyCopyWith<$Res>? get reply;

}
/// @nodoc
class __$LocalPingStateCopyWithImpl<$Res>
    implements _$LocalPingStateCopyWith<$Res> {
  __$LocalPingStateCopyWithImpl(this._self, this._then);

  final _LocalPingState _self;
  final $Res Function(_LocalPingState) _then;

/// Create a copy of LocalPingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? session = null,Object? phase = null,Object? target = null,Object? address = null,Object? protocol = null,Object? port = null,Object? size = null,Object? count = null,Object? interval = null,Object? sent = null,Object? elapsed = null,Object? reply = freezed,Object? replies = null,Object? error = null,}) {
  return _then(_LocalPingState(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as int,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as String,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,protocol: null == protocol ? _self.protocol : protocol // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,sent: null == sent ? _self.sent : sent // ignore: cast_nullable_to_non_nullable
as int,elapsed: null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as double,reply: freezed == reply ? _self.reply : reply // ignore: cast_nullable_to_non_nullable
as LocalPingReply?,replies: null == replies ? _self._replies : replies // ignore: cast_nullable_to_non_nullable
as List<LocalPingReply>,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of LocalPingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalPingReplyCopyWith<$Res>? get reply {
    if (_self.reply == null) {
    return null;
  }

  return $LocalPingReplyCopyWith<$Res>(_self.reply!, (value) {
    return _then(_self.copyWith(reply: value));
  });
}
}


/// @nodoc
mixin _$AgeKeyPair {

@JsonKey(name: 'public-key') String get publicKey;@JsonKey(name: 'secret-key') String get secretKey;
/// Create a copy of AgeKeyPair
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgeKeyPairCopyWith<AgeKeyPair> get copyWith => _$AgeKeyPairCopyWithImpl<AgeKeyPair>(this as AgeKeyPair, _$identity);

  /// Serializes this AgeKeyPair to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AgeKeyPair;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgeKeyPair&&(identical(other.publicKey, _this.publicKey) || other.publicKey == _this.publicKey)&&(identical(other.secretKey, _this.secretKey) || other.secretKey == _this.secretKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AgeKeyPair;
  return Object.hash(runtimeType,_this.publicKey,_this.secretKey);
}

@override
String toString() {
  final _this = this as AgeKeyPair;
  return 'AgeKeyPair(publicKey: ${_this.publicKey}, secretKey: ${_this.secretKey})';
}


}

/// @nodoc
abstract mixin class $AgeKeyPairCopyWith<$Res>  {
  factory $AgeKeyPairCopyWith(AgeKeyPair value, $Res Function(AgeKeyPair) _then) = _$AgeKeyPairCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'public-key') String publicKey,@JsonKey(name: 'secret-key') String secretKey
});




}
/// @nodoc
class _$AgeKeyPairCopyWithImpl<$Res>
    implements $AgeKeyPairCopyWith<$Res> {
  _$AgeKeyPairCopyWithImpl(this._self, this._then);

  final AgeKeyPair _self;
  final $Res Function(AgeKeyPair) _then;

/// Create a copy of AgeKeyPair
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? publicKey = null,Object? secretKey = null,}) {
  return _then(AgeKeyPair(
publicKey: null == publicKey ? _self.publicKey : publicKey // ignore: cast_nullable_to_non_nullable
as String,secretKey: null == secretKey ? _self.secretKey : secretKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AgeKeyPair].
extension AgeKeyPairPatterns on AgeKeyPair {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgeKeyPair value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgeKeyPair() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgeKeyPair value)  $default,){
final _that = this;
switch (_that) {
case _AgeKeyPair():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgeKeyPair value)?  $default,){
final _that = this;
switch (_that) {
case _AgeKeyPair() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'public-key')  String publicKey, @JsonKey(name: 'secret-key')  String secretKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgeKeyPair() when $default != null:
return $default(_that.publicKey,_that.secretKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'public-key')  String publicKey, @JsonKey(name: 'secret-key')  String secretKey)  $default,) {final _that = this;
switch (_that) {
case _AgeKeyPair():
return $default(_that.publicKey,_that.secretKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'public-key')  String publicKey, @JsonKey(name: 'secret-key')  String secretKey)?  $default,) {final _that = this;
switch (_that) {
case _AgeKeyPair() when $default != null:
return $default(_that.publicKey,_that.secretKey);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AgeKeyPair implements AgeKeyPair {
  const _AgeKeyPair({@JsonKey(name: 'public-key') this.publicKey = '', @JsonKey(name: 'secret-key') this.secretKey = ''});
  factory _AgeKeyPair.fromJson(Map<String, dynamic> json) => _$AgeKeyPairFromJson(json);

@override@JsonKey(name: 'public-key') final  String publicKey;
@override@JsonKey(name: 'secret-key') final  String secretKey;

/// Create a copy of AgeKeyPair
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgeKeyPairCopyWith<_AgeKeyPair> get copyWith => __$AgeKeyPairCopyWithImpl<_AgeKeyPair>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AgeKeyPairToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgeKeyPair&&(identical(other.publicKey, publicKey) || other.publicKey == publicKey)&&(identical(other.secretKey, secretKey) || other.secretKey == secretKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,publicKey,secretKey);
}

@override
String toString() {
    return 'AgeKeyPair(publicKey: $publicKey, secretKey: $secretKey)';
}


}

/// @nodoc
abstract mixin class _$AgeKeyPairCopyWith<$Res> implements $AgeKeyPairCopyWith<$Res> {
  factory _$AgeKeyPairCopyWith(_AgeKeyPair value, $Res Function(_AgeKeyPair) _then) = __$AgeKeyPairCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'public-key') String publicKey,@JsonKey(name: 'secret-key') String secretKey
});




}
/// @nodoc
class __$AgeKeyPairCopyWithImpl<$Res>
    implements _$AgeKeyPairCopyWith<$Res> {
  __$AgeKeyPairCopyWithImpl(this._self, this._then);

  final _AgeKeyPair _self;
  final $Res Function(_AgeKeyPair) _then;

/// Create a copy of AgeKeyPair
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? publicKey = null,Object? secretKey = null,}) {
  return _then(_AgeKeyPair(
publicKey: null == publicKey ? _self.publicKey : publicKey // ignore: cast_nullable_to_non_nullable
as String,secretKey: null == secretKey ? _self.secretKey : secretKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AgeCryptParams {

 String get mode; String get data; List<String> get keys;
/// Create a copy of AgeCryptParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgeCryptParamsCopyWith<AgeCryptParams> get copyWith => _$AgeCryptParamsCopyWithImpl<AgeCryptParams>(this as AgeCryptParams, _$identity);

  /// Serializes this AgeCryptParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AgeCryptParams;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgeCryptParams&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.data, _this.data) || other.data == _this.data)&&const DeepCollectionEquality().equals(other.keys, _this.keys));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AgeCryptParams;
  return Object.hash(runtimeType,_this.mode,_this.data,const DeepCollectionEquality().hash(_this.keys));
}

@override
String toString() {
  final _this = this as AgeCryptParams;
  return 'AgeCryptParams(mode: ${_this.mode}, data: ${_this.data}, keys: ${_this.keys})';
}


}

/// @nodoc
abstract mixin class $AgeCryptParamsCopyWith<$Res>  {
  factory $AgeCryptParamsCopyWith(AgeCryptParams value, $Res Function(AgeCryptParams) _then) = _$AgeCryptParamsCopyWithImpl;
@useResult
$Res call({
 String mode, String data, List<String> keys
});




}
/// @nodoc
class _$AgeCryptParamsCopyWithImpl<$Res>
    implements $AgeCryptParamsCopyWith<$Res> {
  _$AgeCryptParamsCopyWithImpl(this._self, this._then);

  final AgeCryptParams _self;
  final $Res Function(AgeCryptParams) _then;

/// Create a copy of AgeCryptParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? data = null,Object? keys = null,}) {
  return _then(AgeCryptParams(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as String,keys: null == keys ? _self.keys : keys // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [AgeCryptParams].
extension AgeCryptParamsPatterns on AgeCryptParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgeCryptParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgeCryptParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgeCryptParams value)  $default,){
final _that = this;
switch (_that) {
case _AgeCryptParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgeCryptParams value)?  $default,){
final _that = this;
switch (_that) {
case _AgeCryptParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String mode,  String data,  List<String> keys)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgeCryptParams() when $default != null:
return $default(_that.mode,_that.data,_that.keys);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String mode,  String data,  List<String> keys)  $default,) {final _that = this;
switch (_that) {
case _AgeCryptParams():
return $default(_that.mode,_that.data,_that.keys);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String mode,  String data,  List<String> keys)?  $default,) {final _that = this;
switch (_that) {
case _AgeCryptParams() when $default != null:
return $default(_that.mode,_that.data,_that.keys);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AgeCryptParams implements AgeCryptParams {
  const _AgeCryptParams({required this.mode, required this.data, required  List<String> keys}): _keys = keys;
  factory _AgeCryptParams.fromJson(Map<String, dynamic> json) => _$AgeCryptParamsFromJson(json);

@override final  String mode;
@override final  String data;
 final  List<String> _keys;
@override List<String> get keys {
  if (_keys is EqualUnmodifiableListView) return _keys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_keys);
}


/// Create a copy of AgeCryptParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgeCryptParamsCopyWith<_AgeCryptParams> get copyWith => __$AgeCryptParamsCopyWithImpl<_AgeCryptParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AgeCryptParamsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgeCryptParams&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.data, data) || other.data == data)&&const DeepCollectionEquality().equals(other.keys, _keys));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,mode,data,const DeepCollectionEquality().hash(_keys));
}

@override
String toString() {
    return 'AgeCryptParams(mode: $mode, data: $data, keys: $keys)';
}


}

/// @nodoc
abstract mixin class _$AgeCryptParamsCopyWith<$Res> implements $AgeCryptParamsCopyWith<$Res> {
  factory _$AgeCryptParamsCopyWith(_AgeCryptParams value, $Res Function(_AgeCryptParams) _then) = __$AgeCryptParamsCopyWithImpl;
@override @useResult
$Res call({
 String mode, String data, List<String> keys
});




}
/// @nodoc
class __$AgeCryptParamsCopyWithImpl<$Res>
    implements _$AgeCryptParamsCopyWith<$Res> {
  __$AgeCryptParamsCopyWithImpl(this._self, this._then);

  final _AgeCryptParams _self;
  final $Res Function(_AgeCryptParams) _then;

/// Create a copy of AgeCryptParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? data = null,Object? keys = null,}) {
  return _then(_AgeCryptParams(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as String,keys: null == keys ? _self._keys : keys // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$AgeCryptResult {

 String get data; String get error;
/// Create a copy of AgeCryptResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgeCryptResultCopyWith<AgeCryptResult> get copyWith => _$AgeCryptResultCopyWithImpl<AgeCryptResult>(this as AgeCryptResult, _$identity);

  /// Serializes this AgeCryptResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AgeCryptResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgeCryptResult&&(identical(other.data, _this.data) || other.data == _this.data)&&(identical(other.error, _this.error) || other.error == _this.error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AgeCryptResult;
  return Object.hash(runtimeType,_this.data,_this.error);
}

@override
String toString() {
  final _this = this as AgeCryptResult;
  return 'AgeCryptResult(data: ${_this.data}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $AgeCryptResultCopyWith<$Res>  {
  factory $AgeCryptResultCopyWith(AgeCryptResult value, $Res Function(AgeCryptResult) _then) = _$AgeCryptResultCopyWithImpl;
@useResult
$Res call({
 String data, String error
});




}
/// @nodoc
class _$AgeCryptResultCopyWithImpl<$Res>
    implements $AgeCryptResultCopyWith<$Res> {
  _$AgeCryptResultCopyWithImpl(this._self, this._then);

  final AgeCryptResult _self;
  final $Res Function(AgeCryptResult) _then;

/// Create a copy of AgeCryptResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,Object? error = null,}) {
  return _then(AgeCryptResult(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as String,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AgeCryptResult].
extension AgeCryptResultPatterns on AgeCryptResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgeCryptResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgeCryptResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgeCryptResult value)  $default,){
final _that = this;
switch (_that) {
case _AgeCryptResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgeCryptResult value)?  $default,){
final _that = this;
switch (_that) {
case _AgeCryptResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String data,  String error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgeCryptResult() when $default != null:
return $default(_that.data,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String data,  String error)  $default,) {final _that = this;
switch (_that) {
case _AgeCryptResult():
return $default(_that.data,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String data,  String error)?  $default,) {final _that = this;
switch (_that) {
case _AgeCryptResult() when $default != null:
return $default(_that.data,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AgeCryptResult implements AgeCryptResult {
  const _AgeCryptResult({this.data = '', this.error = ''});
  factory _AgeCryptResult.fromJson(Map<String, dynamic> json) => _$AgeCryptResultFromJson(json);

@override@JsonKey() final  String data;
@override@JsonKey() final  String error;

/// Create a copy of AgeCryptResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgeCryptResultCopyWith<_AgeCryptResult> get copyWith => __$AgeCryptResultCopyWithImpl<_AgeCryptResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AgeCryptResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgeCryptResult&&(identical(other.data, data) || other.data == data)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,data,error);
}

@override
String toString() {
    return 'AgeCryptResult(data: $data, error: $error)';
}


}

/// @nodoc
abstract mixin class _$AgeCryptResultCopyWith<$Res> implements $AgeCryptResultCopyWith<$Res> {
  factory _$AgeCryptResultCopyWith(_AgeCryptResult value, $Res Function(_AgeCryptResult) _then) = __$AgeCryptResultCopyWithImpl;
@override @useResult
$Res call({
 String data, String error
});




}
/// @nodoc
class __$AgeCryptResultCopyWithImpl<$Res>
    implements _$AgeCryptResultCopyWith<$Res> {
  __$AgeCryptResultCopyWithImpl(this._self, this._then);

  final _AgeCryptResult _self;
  final $Res Function(_AgeCryptResult) _then;

/// Create a copy of AgeCryptResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,Object? error = null,}) {
  return _then(_AgeCryptResult(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as String,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
