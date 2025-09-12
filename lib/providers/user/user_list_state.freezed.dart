// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserListState {
  List<User> get users => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  String? get lastDocumentId => throw _privateConstructorUsedError;
  String? get searchQuery => throw _privateConstructorUsedError;

  /// Create a copy of UserListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserListStateCopyWith<UserListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserListStateCopyWith<$Res> {
  factory $UserListStateCopyWith(
          UserListState value, $Res Function(UserListState) then) =
      _$UserListStateCopyWithImpl<$Res, UserListState>;
  @useResult
  $Res call(
      {List<User> users,
      bool isLoading,
      String? error,
      bool hasMore,
      String? lastDocumentId,
      String? searchQuery});
}

/// @nodoc
class _$UserListStateCopyWithImpl<$Res, $Val extends UserListState>
    implements $UserListStateCopyWith<$Res> {
  _$UserListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? users = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? hasMore = null,
    Object? lastDocumentId = freezed,
    Object? searchQuery = freezed,
  }) {
    return _then(_value.copyWith(
      users: null == users
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as List<User>,
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
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserListStateImplCopyWith<$Res>
    implements $UserListStateCopyWith<$Res> {
  factory _$$UserListStateImplCopyWith(
          _$UserListStateImpl value, $Res Function(_$UserListStateImpl) then) =
      __$$UserListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<User> users,
      bool isLoading,
      String? error,
      bool hasMore,
      String? lastDocumentId,
      String? searchQuery});
}

/// @nodoc
class __$$UserListStateImplCopyWithImpl<$Res>
    extends _$UserListStateCopyWithImpl<$Res, _$UserListStateImpl>
    implements _$$UserListStateImplCopyWith<$Res> {
  __$$UserListStateImplCopyWithImpl(
      _$UserListStateImpl _value, $Res Function(_$UserListStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? users = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? hasMore = null,
    Object? lastDocumentId = freezed,
    Object? searchQuery = freezed,
  }) {
    return _then(_$UserListStateImpl(
      users: null == users
          ? _value._users
          : users // ignore: cast_nullable_to_non_nullable
              as List<User>,
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
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$UserListStateImpl implements _UserListState {
  const _$UserListStateImpl(
      {final List<User> users = const [],
      this.isLoading = false,
      this.error,
      this.hasMore = false,
      this.lastDocumentId,
      this.searchQuery})
      : _users = users;

  final List<User> _users;
  @override
  @JsonKey()
  List<User> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
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
  final String? searchQuery;

  @override
  String toString() {
    return 'UserListState(users: $users, isLoading: $isLoading, error: $error, hasMore: $hasMore, lastDocumentId: $lastDocumentId, searchQuery: $searchQuery)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserListStateImpl &&
            const DeepCollectionEquality().equals(other._users, _users) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.lastDocumentId, lastDocumentId) ||
                other.lastDocumentId == lastDocumentId) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_users),
      isLoading,
      error,
      hasMore,
      lastDocumentId,
      searchQuery);

  /// Create a copy of UserListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserListStateImplCopyWith<_$UserListStateImpl> get copyWith =>
      __$$UserListStateImplCopyWithImpl<_$UserListStateImpl>(this, _$identity);
}

abstract class _UserListState implements UserListState {
  const factory _UserListState(
      {final List<User> users,
      final bool isLoading,
      final String? error,
      final bool hasMore,
      final String? lastDocumentId,
      final String? searchQuery}) = _$UserListStateImpl;

  @override
  List<User> get users;
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  bool get hasMore;
  @override
  String? get lastDocumentId;
  @override
  String? get searchQuery;

  /// Create a copy of UserListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserListStateImplCopyWith<_$UserListStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
