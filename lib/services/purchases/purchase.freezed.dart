// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PurchaseInfo _$PurchaseInfoFromJson(Map<String, dynamic> json) {
  return _PurchaseInfo.fromJson(json);
}

/// @nodoc
mixin _$PurchaseInfo {
  String get productId => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String get provider => throw _privateConstructorUsedError;
  String? get token => throw _privateConstructorUsedError;
  PurchaseStatus? get status => throw _privateConstructorUsedError;
  String? get baseUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PurchaseInfoCopyWith<PurchaseInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseInfoCopyWith<$Res> {
  factory $PurchaseInfoCopyWith(
          PurchaseInfo value, $Res Function(PurchaseInfo) then) =
      _$PurchaseInfoCopyWithImpl<$Res, PurchaseInfo>;
  @useResult
  $Res call(
      {String productId,
      String? type,
      String provider,
      String? token,
      PurchaseStatus? status,
      String? baseUrl});
}

/// @nodoc
class _$PurchaseInfoCopyWithImpl<$Res, $Val extends PurchaseInfo>
    implements $PurchaseInfoCopyWith<$Res> {
  _$PurchaseInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? type = freezed,
    Object? provider = null,
    Object? token = freezed,
    Object? status = freezed,
    Object? baseUrl = freezed,
  }) {
    return _then(_value.copyWith(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PurchaseStatus?,
      baseUrl: freezed == baseUrl
          ? _value.baseUrl
          : baseUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PurchaseInfoCopyWith<$Res>
    implements $PurchaseInfoCopyWith<$Res> {
  factory _$$_PurchaseInfoCopyWith(
          _$_PurchaseInfo value, $Res Function(_$_PurchaseInfo) then) =
      __$$_PurchaseInfoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String productId,
      String? type,
      String provider,
      String? token,
      PurchaseStatus? status,
      String? baseUrl});
}

/// @nodoc
class __$$_PurchaseInfoCopyWithImpl<$Res>
    extends _$PurchaseInfoCopyWithImpl<$Res, _$_PurchaseInfo>
    implements _$$_PurchaseInfoCopyWith<$Res> {
  __$$_PurchaseInfoCopyWithImpl(
      _$_PurchaseInfo _value, $Res Function(_$_PurchaseInfo) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? type = freezed,
    Object? provider = null,
    Object? token = freezed,
    Object? status = freezed,
    Object? baseUrl = freezed,
  }) {
    return _then(_$_PurchaseInfo(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PurchaseStatus?,
      baseUrl: freezed == baseUrl
          ? _value.baseUrl
          : baseUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PurchaseInfo extends _PurchaseInfo {
  const _$_PurchaseInfo(
      {required this.productId,
      this.type,
      this.provider = 'undefined',
      this.token,
      this.status,
      this.baseUrl})
      : super._();

  factory _$_PurchaseInfo.fromJson(Map<String, dynamic> json) =>
      _$$_PurchaseInfoFromJson(json);

  @override
  final String productId;
  @override
  final String? type;
  @override
  @JsonKey()
  final String provider;
  @override
  final String? token;
  @override
  final PurchaseStatus? status;
  @override
  final String? baseUrl;

  @override
  String toString() {
    return 'PurchaseInfo(productId: $productId, type: $type, provider: $provider, token: $token, status: $status, baseUrl: $baseUrl)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PurchaseInfo &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, productId, type, provider, token, status, baseUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PurchaseInfoCopyWith<_$_PurchaseInfo> get copyWith =>
      __$$_PurchaseInfoCopyWithImpl<_$_PurchaseInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PurchaseInfoToJson(
      this,
    );
  }
}

abstract class _PurchaseInfo extends PurchaseInfo {
  const factory _PurchaseInfo(
      {required final String productId,
      final String? type,
      final String provider,
      final String? token,
      final PurchaseStatus? status,
      final String? baseUrl}) = _$_PurchaseInfo;
  const _PurchaseInfo._() : super._();

  factory _PurchaseInfo.fromJson(Map<String, dynamic> json) =
      _$_PurchaseInfo.fromJson;

  @override
  String get productId;
  @override
  String? get type;
  @override
  String get provider;
  @override
  String? get token;
  @override
  PurchaseStatus? get status;
  @override
  String? get baseUrl;
  @override
  @JsonKey(ignore: true)
  _$$_PurchaseInfoCopyWith<_$_PurchaseInfo> get copyWith =>
      throw _privateConstructorUsedError;
}
