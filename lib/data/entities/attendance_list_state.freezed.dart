// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AttendanceListState {
  List<Attendance> get attendance => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  String? get lastDocumentId => throw _privateConstructorUsedError;

  /// Create a copy of AttendanceListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AttendanceListStateCopyWith<AttendanceListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttendanceListStateCopyWith<$Res> {
  factory $AttendanceListStateCopyWith(
          AttendanceListState value, $Res Function(AttendanceListState) then) =
      _$AttendanceListStateCopyWithImpl<$Res, AttendanceListState>;
  @useResult
  $Res call(
      {List<Attendance> attendance,
      bool isLoading,
      String? error,
      bool hasMore,
      String? lastDocumentId});
}

/// @nodoc
class _$AttendanceListStateCopyWithImpl<$Res, $Val extends AttendanceListState>
    implements $AttendanceListStateCopyWith<$Res> {
  _$AttendanceListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AttendanceListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? attendance = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? hasMore = null,
    Object? lastDocumentId = freezed,
  }) {
    return _then(_value.copyWith(
      attendance: null == attendance
          ? _value.attendance
          : attendance // ignore: cast_nullable_to_non_nullable
              as List<Attendance>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      lastDocumentId: freezed == lastDocumentId
          ? _value.lastDocumentId
          : lastDocumentId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AttendanceListStateImplCopyWith<$Res>
    implements $AttendanceListStateCopyWith<$Res> {
  factory _$$AttendanceListStateImplCopyWith(_$AttendanceListStateImpl value,
          $Res Function(_$AttendanceListStateImpl) then) =
      __$$AttendanceListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Attendance> attendance,
      bool isLoading,
      String? error,
      bool hasMore,
      String? lastDocumentId});
}

/// @nodoc
class __$$AttendanceListStateImplCopyWithImpl<$Res>
    extends _$AttendanceListStateCopyWithImpl<$Res, _$AttendanceListStateImpl>
    implements _$$AttendanceListStateImplCopyWith<$Res> {
  __$$AttendanceListStateImplCopyWithImpl(_$AttendanceListStateImpl _value,
      $Res Function(_$AttendanceListStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AttendanceListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? attendance = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? hasMore = null,
    Object? lastDocumentId = freezed,
  }) {
    return _then(_$AttendanceListStateImpl(
      attendance: null == attendance
          ? _value._attendance
          : attendance // ignore: cast_nullable_to_non_nullable
              as List<Attendance>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      lastDocumentId: freezed == lastDocumentId
          ? _value.lastDocumentId
          : lastDocumentId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AttendanceListStateImpl implements _AttendanceListState {
  const _$AttendanceListStateImpl(
      {final List<Attendance> attendance = const [],
      this.isLoading = false,
      this.error,
      this.hasMore = true,
      this.lastDocumentId})
      : _attendance = attendance;

  final List<Attendance> _attendance;
  @override
  @JsonKey()
  List<Attendance> get attendance {
    if (_attendance is EqualUnmodifiableListView) return _attendance;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attendance);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;
  @override
  @JsonKey()
  final bool hasMore;
  @override
  final String? lastDocumentId;

  @override
  String toString() {
    return 'AttendanceListState(attendance: $attendance, isLoading: $isLoading, error: $error, hasMore: $hasMore, lastDocumentId: $lastDocumentId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttendanceListStateImpl &&
            const DeepCollectionEquality()
                .equals(other._attendance, _attendance) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.lastDocumentId, lastDocumentId) ||
                other.lastDocumentId == lastDocumentId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_attendance),
      isLoading,
      error,
      hasMore,
      lastDocumentId);

  /// Create a copy of AttendanceListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AttendanceListStateImplCopyWith<_$AttendanceListStateImpl> get copyWith =>
      __$$AttendanceListStateImplCopyWithImpl<_$AttendanceListStateImpl>(
          this, _$identity);
}

abstract class _AttendanceListState implements AttendanceListState {
  const factory _AttendanceListState(
      {final List<Attendance> attendance,
      final bool isLoading,
      final String? error,
      final bool hasMore,
      final String? lastDocumentId}) = _$AttendanceListStateImpl;

  @override
  List<Attendance> get attendance;
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  bool get hasMore;
  @override
  String? get lastDocumentId;

  /// Create a copy of AttendanceListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AttendanceListStateImplCopyWith<_$AttendanceListStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
