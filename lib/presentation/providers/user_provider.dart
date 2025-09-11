import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/utils/utils.dart';
import '../../data/entities/entities.dart';
import '../../data/repositories/repositories.dart';

part 'user_provider.g.dart';

@Riverpod(keepAlive: true)
class UserListNotifier extends _$UserListNotifier {
  @override
  AsyncValue<UserListState> build() {
    return const AsyncValue.data(UserListState());
  }

  void fetchUsers(
      {String? searchQuery, int limit = 20, String? lastDocumentId}) {
    final currentState = state.valueOrNull ?? const UserListState();

    if (currentState.isLoading) return;

    final isNewSearch =
        searchQuery != currentState.searchQuery || lastDocumentId == null;

    state = AsyncValue.data(currentState.copyWith(
      isLoading: true,
      error: null,
      searchQuery: searchQuery,
    ));

    Future.microtask(() {
      try {
        logger.i('Fetching users with provider');
        final stream = ref.read(userRepositoryProvider).getUsers(
              searchQuery: searchQuery,
              limit: limit,
              lastDocumentId: lastDocumentId,
            );

        stream.listen((users) {
          final latestState = state.valueOrNull ?? const UserListState();

          final newUsers =
              isNewSearch ? users : [...latestState.users, ...users];

          state = AsyncValue.data(latestState.copyWith(
            users: newUsers,
            isLoading: false,
            hasMore: users.length == limit,
            lastDocumentId:
                users.isNotEmpty ? users.last.id : latestState.lastDocumentId,
            searchQuery: searchQuery,
          ));
        }, onError: (e, stack) {
          logger.e('Error fetching users: $e');
          final latestState = state.valueOrNull ?? const UserListState();
          state = AsyncValue.data(latestState.copyWith(
            isLoading: false,
            error: e.toString(),
          ));
        });
      } catch (e) {
        logger.e('Error fetching users: $e');
        final currentState = state.valueOrNull ?? const UserListState();
        state = AsyncValue.data(currentState.copyWith(
          isLoading: false,
          error: e.toString(),
        ));
      }
    });
  }

  Future<User> getUserById(String userId) async {
    try {
      logger.i('Fetching user with provider: $userId');
      final user = await ref.read(userRepositoryProvider).getUserById(userId);
      return user;
    } catch (e) {
      logger.e('Error fetching user: $e');
      rethrow;
    }
  }
}
