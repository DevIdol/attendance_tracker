import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/utils/utils.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class UserListScreen extends HookConsumerWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final scrollController = useScrollController();
    final isFetchingMore = useState(false);
    final debounceTimer = useState<Timer?>(null);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(userListNotifierProvider.notifier).fetchUsers();
      });

      scrollController.addListener(() {
        final state = ref.read(userListNotifierProvider).valueOrNull;
        if (scrollController.position.pixels >=
                scrollController.position.maxScrollExtent - 200 &&
            !isFetchingMore.value &&
            state != null &&
            state.hasMore) {
          isFetchingMore.value = true;
          ref.read(userListNotifierProvider.notifier).fetchUsers(
                searchQuery: searchController.text,
                lastDocumentId: state.lastDocumentId,
              );
          Future.delayed(const Duration(seconds: 1), () {
            isFetchingMore.value = false;
          });
        }
      });

      return () {
        scrollController.dispose();
        debounceTimer.value?.cancel();
      };
    }, []);

    void handleSearch(String value) {
      logger.i('Searching users with query: $value');
      debounceTimer.value?.cancel();
      debounceTimer.value = Timer(const Duration(milliseconds: 500), () {
        ref.invalidate(userListNotifierProvider);
        ref
            .read(userListNotifierProvider.notifier)
            .fetchUsers(searchQuery: value);
      });
    }

    Future<void> handleRefresh() async {
      logger.i('Refreshing user list');
      debounceTimer.value?.cancel();
      Future.microtask(() {
        ref.invalidate(userListNotifierProvider);
        ref.read(userListNotifierProvider.notifier).fetchUsers(
              searchQuery: searchController.text.isNotEmpty
                  ? searchController.text
                  : null,
            );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: const [
          ConnectivityStatus(),
          ThemeToggleButton(),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Users (name or email)',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          handleSearch('');
                        },
                      )
                    : null,
              ),
              onChanged: handleSearch,
            ),
          ),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final state = ref.watch(userListNotifierProvider);
                return RefreshIndicator(
                  onRefresh: handleRefresh,
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    slivers: [
                      state.when(
                        data: (userListState) {
                          if (userListState.isLoading &&
                              userListState.users.isEmpty) {
                            return const SliverFillRemaining(
                              child: Center(child: LoadingIndicator()),
                            );
                          }
                          if (userListState.error != null) {
                            return SliverFillRemaining(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Error: ${userListState.error}'),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: handleRefresh,
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          if (userListState.users.isEmpty) {
                            return SliverFillRemaining(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.search_off,
                                        size: 64, color: Colors.grey),
                                    const SizedBox(height: 16),
                                    Text(
                                      userListState.searchQuery?.isNotEmpty ==
                                              true
                                          ? 'No users found for "${userListState.searchQuery}"'
                                          : 'No users found',
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                if (index >= userListState.users.length) {
                                  return const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: LoadingIndicator(),
                                  );
                                }
                                final user = userListState.users[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: ListTile(
                                    leading: user.profileImageUrl != null
                                        ? CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                user.profileImageUrl!),
                                          )
                                        : const CircleAvatar(
                                            child: Icon(Icons.person)),
                                    title: Text(user.name),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(user.email),
                                        const SizedBox(height: 4),
                                        // Chip(
                                        //   label: Text(
                                        //     user.role == UserRole.admin
                                        //         ? 'Admin'
                                        //         : 'User',
                                        //     style: const TextStyle(
                                        //       fontSize: 12,
                                        //       color: Colors.white,
                                        //     ),
                                        //   ),
                                        //   backgroundColor:
                                        //       user.role == UserRole.admin
                                        //           ? Colors.blue
                                        //           : Colors.green,
                                        //   visualDensity: VisualDensity.compact,
                                        //   materialTapTargetSize:
                                        //       MaterialTapTargetSize.shrinkWrap,
                                        // ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.visibility),
                                      onPressed: () {
                                        logger.i(
                                            'Viewing user history: ${user.id}');
                                        context.go(
                                            '/admin/user_history/${user.id}');
                                      },
                                    ),
                                  ),
                                );
                              },
                              childCount: userListState.users.length +
                                  (userListState.hasMore ? 1 : 0),
                            ),
                          );
                        },
                        loading: () => const SliverFillRemaining(
                          child: Center(child: LoadingIndicator()),
                        ),
                        error: (e, _) => SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Error: $e'),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: handleRefresh,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
