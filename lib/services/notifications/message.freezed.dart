// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$NotificationMessage {
  bool get empty =>
      throw _privateConstructorUsedError; // is the notification part empty
  String? get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get body => throw _privateConstructorUsedError;
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NotificationMessageCopyWith<NotificationMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationMessageCopyWith<$Res> {
  factory $NotificationMessageCopyWith(
          NotificationMessage value, $Res Function(NotificationMessage) then) =
      _$NotificationMessageCopyWithImpl<$Res, NotificationMessage>;
  @useResult
  $Res call(
      {bool empty,
      String? id,
      String? title,
      String? body,
      Map<String, dynamic>? data});
}

/// @nodoc
class _$NotificationMessageCopyWithImpl<$Res, $Val extends NotificationMessage>
    implements $NotificationMessageCopyWith<$Res> {
  _$NotificationMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? empty = null,
    Object? id = freezed,
    Object? title = freezed,
    Object? body = freezed,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      empty: null == empty
          ? _value.empty
          : empty // ignore: cast_nullable_to_non_nullable
              as bool,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_NotificationMessageCopyWith<$Res>
    implements $NotificationMessageCopyWith<$Res> {
  factory _$$_NotificationMessageCopyWith(_$_NotificationMessage value,
          $Res Function(_$_NotificationMessage) then) =
      __$$_NotificationMessageCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool empty,
      String? id,
      String? title,
      String? body,
      Map<String, dynamic>? data});
}

/// @nodoc
class __$$_NotificationMessageCopyWithImpl<$Res>
    extends _$NotificationMessageCopyWithImpl<$Res, _$_NotificationMessage>
    implements _$$_NotificationMessageCopyWith<$Res> {
  __$$_NotificationMessageCopyWithImpl(_$_NotificationMessage _value,
      $Res Function(_$_NotificationMessage) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? empty = null,
    Object? id = freezed,
    Object? title = freezed,
    Object? body = freezed,
    Object? data = freezed,
  }) {
    return _then(_$_NotificationMessage(
      empty: null == empty
          ? _value.empty
          : empty // ignore: cast_nullable_to_non_nullable
              as bool,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$_NotificationMessage implements _NotificationMessage {
  const _$_NotificationMessage(
      {required this.empty,
      this.id,
      this.title,
      this.body,
      final Map<String, dynamic>? data})
      : _data = data;

  @override
  final bool empty;
// is the notification part empty
  @override
  final String? id;
  @override
  final String? title;
  @override
  final String? body;
  final Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'NotificationMessage(empty: $empty, id: $id, title: $title, body: $body, data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NotificationMessage &&
            (identical(other.empty, empty) || other.empty == empty) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, empty, id, title, body,
      const DeepCollectionEquality().hash(_data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NotificationMessageCopyWith<_$_NotificationMessage> get copyWith =>
      __$$_NotificationMessageCopyWithImpl<_$_NotificationMessage>(
          this, _$identity);
}

abstract class _NotificationMessage implements NotificationMessage {
  const factory _NotificationMessage(
      {required final bool empty,
      final String? id,
      final String? title,
      final String? body,
      final Map<String, dynamic>? data}) = _$_NotificationMessage;

  @override
  bool get empty;
  @override // is the notification part empty
  String? get id;
  @override
  String? get title;
  @override
  String? get body;
  @override
  Map<String, dynamic>? get data;
  @override
  @JsonKey(ignore: true)
  _$$_NotificationMessageCopyWith<_$_NotificationMessage> get copyWith =>
      throw _privateConstructorUsedError;
}
