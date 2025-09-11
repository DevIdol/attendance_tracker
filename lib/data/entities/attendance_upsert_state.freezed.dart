// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_upsert_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AttendanceUpsertState {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get timestamp => throw _privateConstructorUsedError;
  bool get isSynced => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  bool get hasCheckedInToday => throw _privateConstructorUsedError;
  bool get hasCheckedOutToday => throw _privateConstructorUsedError;

  /// Create a copy of AttendanceUpsertState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AttendanceUpsertStateCopyWith<AttendanceUpsertState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttendanceUpsertStateCopyWith<$Res> {
  factory $AttendanceUpsertStateCopyWith(AttendanceUpsertState value,
          $Res Function(AttendanceUpsertState) then) =
      _$AttendanceUpsertStateCopyWithImpl<$Res, AttendanceUpsertState>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String type,
      @TimestampConverter() DateTime timestamp,
      bool isSynced,
      bool isLoading,
      String? error,
      bool hasCheckedInToday,
      bool hasCheckedOutToday});
}

/// @nodoc
class _$AttendanceUpsertStateCopyWithImpl<$Res,
        $Val extends AttendanceUpsertState>
    implements $AttendanceUpsertStateCopyWith<$Res> {
  _$AttendanceUpsertStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AttendanceUpsertState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? timestamp = null,
    Object? isSynced = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? hasCheckedInToday = null,
    Object? hasCheckedOutToday = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      hasCheckedInToday: null == hasCheckedInToday
          ? _value.hasCheckedInToday
          : hasCheckedInToday // ignore: cast_nullable_to_non_nullable
              as bool,
      hasCheckedOutToday: null == hasCheckedOutToday
          ? _value.hasCheckedOutToday
          : hasCheckedOutToday // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AttendanceUpsertStateImplCopyWith<$Res>
    implements $AttendanceUpsertStateCopyWith<$Res> {
  factory _$$AttendanceUpsertStateImplCopyWith(
          _$AttendanceUpsertStateImpl value,
          $Res Function(_$AttendanceUpsertStateImpl) then) =
      __$$AttendanceUpsertStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String type,
      @TimestampConverter() DateTime timestamp,
      bool isSynced,
      bool isLoading,
      String? error,
      bool hasCheckedInToday,
      bool hasCheckedOutToday});
}

/// @nodoc
class __$$AttendanceUpsertStateImplCopyWithImpl<$Res>
    extends _$AttendanceUpsertStateCopyWithImpl<$Res,
        _$AttendanceUpsertStateImpl>
    implements _$$AttendanceUpsertStateImplCopyWith<$Res> {
  __$$AttendanceUpsertStateImplCopyWithImpl(_$AttendanceUpsertStateImpl _value,
      $Res Function(_$AttendanceUpsertStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AttendanceUpsertState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? timestamp = null,
    Object? isSynced = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? hasCheckedInToday = null,
    Object? hasCheckedOutToday = null,
  }) {
    return _then(_$AttendanceUpsertStateImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      hasCheckedInToday: null == hasCheckedInToday
          ? _value.hasCheckedInToday
          : hasCheckedInToday // ignore: cast_nullable_to_non_nullable
              as bool,
      hasCheckedOutToday: null == hasCheckedOutToday
          ? _value.hasCheckedOutToday
          : hasCheckedOutToday // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$AttendanceUpsertStateImpl implements _AttendanceUpsertState {
  const _$AttendanceUpsertStateImpl(
      {required this.id,
      required this.userId,
      required this.type,
      @TimestampConverter() required this.timestamp,
      required this.isSynced,
      this.isLoading = false,
      this.error,
      this.hasCheckedInToday = false,
      this.hasCheckedOutToday = false});

  @override
  final String id;
  @override
  final String userId;
  @override
  final String type;
  @override
  @TimestampConverter()
  final DateTime timestamp;
  @override
  final bool isSynced;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;
  @override
  @JsonKey()
  final bool hasCheckedInToday;
  @override
  @JsonKey()
  final bool hasCheckedOutToday;

  @override
  String toString() {
    return 'AttendanceUpsertState(id: $id, userId: $userId, type: $type, timestamp: $timestamp, isSynced: $isSynced, isLoading: $isLoading, error: $error, hasCheckedInToday: $hasCheckedInToday, hasCheckedOutToday: $hasCheckedOutToday)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttendanceUpsertStateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.isSynced, isSynced) ||
                other.isSynced == isSynced) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.hasCheckedInToday, hasCheckedInToday) ||
                other.hasCheckedInToday == hasCheckedInToday) &&
            (identical(other.hasCheckedOutToday, hasCheckedOutToday) ||
                other.hasCheckedOutToday == hasCheckedOutToday));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, userId, type, timestamp,
      isSynced, isLoading, error, hasCheckedInToday, hasCheckedOutToday);

  /// Create a copy of AttendanceUpsertState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AttendanceUpsertStateImplCopyWith<_$AttendanceUpsertStateImpl>
      get copyWith => __$$AttendanceUpsertStateImplCopyWithImpl<
          _$AttendanceUpsertStateImpl>(this, _$identity);
}

abstract class _AttendanceUpsertState implements AttendanceUpsertState {
  const factory _AttendanceUpsertState(
      {required final String id,
      required final String userId,
      required final String type,
      @TimestampConverter() required final DateTime timestamp,
      required final bool isSynced,
      final bool isLoading,
      final String? error,
      final bool hasCheckedInToday,
      final bool hasCheckedOutToday}) = _$AttendanceUpsertStateImpl;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get type;
  @override
  @TimestampConverter()
  DateTime get timestamp;
  @override
  bool get isSynced;
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  bool get hasCheckedInToday;
  @override
  bool get hasCheckedOutToday;

  /// Create a copy of AttendanceUpsertState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AttendanceUpsertStateImplCopyWith<_$AttendanceUpsertStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
