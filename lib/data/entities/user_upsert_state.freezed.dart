// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_upsert_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserUpsertState {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  UserRole get role => throw _privateConstructorUsedError;
  String? get profileImageUrl => throw _privateConstructorUsedError;
  List<String> get fcmTokens => throw _privateConstructorUsedError;
  @GeoPointConverter()
  GeoPoint? get location => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of UserUpsertState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserUpsertStateCopyWith<UserUpsertState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserUpsertStateCopyWith<$Res> {
  factory $UserUpsertStateCopyWith(
          UserUpsertState value, $Res Function(UserUpsertState) then) =
      _$UserUpsertStateCopyWithImpl<$Res, UserUpsertState>;
  @useResult
  $Res call(
      {String id,
      String email,
      String name,
      UserRole role,
      String? profileImageUrl,
      List<String> fcmTokens,
      @GeoPointConverter() GeoPoint? location,
      @TimestampConverter() DateTime createdAt,
      @TimestampConverter() DateTime updatedAt,
      bool isLoading,
      String? error});
}

/// @nodoc
class _$UserUpsertStateCopyWithImpl<$Res, $Val extends UserUpsertState>
    implements $UserUpsertStateCopyWith<$Res> {
  _$UserUpsertStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserUpsertState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = null,
    Object? role = null,
    Object? profileImageUrl = freezed,
    Object? fcmTokens = null,
    Object? location = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      fcmTokens: null == fcmTokens
          ? _value.fcmTokens
          : fcmTokens // ignore: cast_nullable_to_non_nullable
              as List<String>,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as GeoPoint?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserUpsertStateImplCopyWith<$Res>
    implements $UserUpsertStateCopyWith<$Res> {
  factory _$$UserUpsertStateImplCopyWith(_$UserUpsertStateImpl value,
          $Res Function(_$UserUpsertStateImpl) then) =
      __$$UserUpsertStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      String name,
      UserRole role,
      String? profileImageUrl,
      List<String> fcmTokens,
      @GeoPointConverter() GeoPoint? location,
      @TimestampConverter() DateTime createdAt,
      @TimestampConverter() DateTime updatedAt,
      bool isLoading,
      String? error});
}

/// @nodoc
class __$$UserUpsertStateImplCopyWithImpl<$Res>
    extends _$UserUpsertStateCopyWithImpl<$Res, _$UserUpsertStateImpl>
    implements _$$UserUpsertStateImplCopyWith<$Res> {
  __$$UserUpsertStateImplCopyWithImpl(
      _$UserUpsertStateImpl _value, $Res Function(_$UserUpsertStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserUpsertState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = null,
    Object? role = null,
    Object? profileImageUrl = freezed,
    Object? fcmTokens = null,
    Object? location = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$UserUpsertStateImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      fcmTokens: null == fcmTokens
          ? _value._fcmTokens
          : fcmTokens // ignore: cast_nullable_to_non_nullable
              as List<String>,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as GeoPoint?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$UserUpsertStateImpl implements _UserUpsertState {
  const _$UserUpsertStateImpl(
      {required this.id,
      required this.email,
      required this.name,
      required this.role,
      this.profileImageUrl,
      final List<String> fcmTokens = const [],
      @GeoPointConverter() this.location,
      @TimestampConverter() required this.createdAt,
      @TimestampConverter() required this.updatedAt,
      this.isLoading = false,
      this.error})
      : _fcmTokens = fcmTokens;

  @override
  final String id;
  @override
  final String email;
  @override
  final String name;
  @override
  final UserRole role;
  @override
  final String? profileImageUrl;
  final List<String> _fcmTokens;
  @override
  @JsonKey()
  List<String> get fcmTokens {
    if (_fcmTokens is EqualUnmodifiableListView) return _fcmTokens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fcmTokens);
  }

  @override
  @GeoPointConverter()
  final GeoPoint? location;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampConverter()
  final DateTime updatedAt;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'UserUpsertState(id: $id, email: $email, name: $name, role: $role, profileImageUrl: $profileImageUrl, fcmTokens: $fcmTokens, location: $location, createdAt: $createdAt, updatedAt: $updatedAt, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserUpsertStateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            const DeepCollectionEquality()
                .equals(other._fcmTokens, _fcmTokens) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      name,
      role,
      profileImageUrl,
      const DeepCollectionEquality().hash(_fcmTokens),
      location,
      createdAt,
      updatedAt,
      isLoading,
      error);

  /// Create a copy of UserUpsertState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserUpsertStateImplCopyWith<_$UserUpsertStateImpl> get copyWith =>
      __$$UserUpsertStateImplCopyWithImpl<_$UserUpsertStateImpl>(
          this, _$identity);
}

abstract class _UserUpsertState implements UserUpsertState {
  const factory _UserUpsertState(
      {required final String id,
      required final String email,
      required final String name,
      required final UserRole role,
      final String? profileImageUrl,
      final List<String> fcmTokens,
      @GeoPointConverter() final GeoPoint? location,
      @TimestampConverter() required final DateTime createdAt,
      @TimestampConverter() required final DateTime updatedAt,
      final bool isLoading,
      final String? error}) = _$UserUpsertStateImpl;

  @override
  String get id;
  @override
  String get email;
  @override
  String get name;
  @override
  UserRole get role;
  @override
  String? get profileImageUrl;
  @override
  List<String> get fcmTokens;
  @override
  @GeoPointConverter()
  GeoPoint? get location;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampConverter()
  DateTime get updatedAt;
  @override
  bool get isLoading;
  @override
  String? get error;

  /// Create a copy of UserUpsertState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserUpsertStateImplCopyWith<_$UserUpsertStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
