import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/data.dart';

part 'user_list_state.freezed.dart';

@freezed
class UserListState with _$UserListState {
  const factory UserListState({
    @Default([]) List<User> users,
    @Default(false) bool isLoading,
    String? error,
    @Default(false) bool hasMore,
    String? lastDocumentId,
    String? searchQuery,
  }) = _UserListState;
}
