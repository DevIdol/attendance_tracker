import 'package:attendance_tracker/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/entities/user.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class UserHistoryScreen extends HookConsumerWidget {
  final String userId;

  const UserHistoryScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final isFetchingMore = useState(false);
    final startDate = useState<DateTime?>(null);
    final endDate = useState<DateTime?>(null);

    final userAsync =
        ref.watch(userListNotifierProvider.notifier).getUserById(userId);

    useEffect(() {
      Future.microtask(() {
        ref
            .read(attendanceListNotifierProvider(userId).notifier)
            .startListening(
              startDate: startDate.value,
              endDate: endDate.value,
            );
      });

      void listener() {
        final state = ref.read(attendanceListNotifierProvider(userId));
        if (scrollController.position.pixels >=
                scrollController.position.maxScrollExtent - 200 &&
            !isFetchingMore.value &&
            state.hasMore) {
          isFetchingMore.value = true;
          ref.read(attendanceListNotifierProvider(userId).notifier).loadMore(
                startDate: startDate.value,
                endDate: endDate.value,
                lastDocumentId: state.lastDocumentId,
              );
          Future.delayed(
              const Duration(seconds: 1), () => isFetchingMore.value = false);
        }
      }

      scrollController.addListener(listener);

      return () => scrollController.removeListener(listener);
    }, [userId]);

    Future<void> selectDateRange(BuildContext context) async {
      final picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
      );
      if (picked != null) {
        startDate.value = picked.start;
        endDate.value = picked.end;

        Future.microtask(() {
          ref
              .read(attendanceListNotifierProvider(userId).notifier)
              .startListening(
                startDate: startDate.value,
                endDate: endDate.value,
              );
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<User>(
          future: userAsync,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text('${snapshot.data!.name}\'s Attendance History');
            }
            return const Text('User Attendance History');
          },
        ),
        actions: const [
          ConnectivityStatus(),
          ThemeToggleButton(),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    startDate.value != null
                        ? 'From: ${DateFormat.yMd().format(startDate.value!)} - To: ${DateFormat.yMd().format(endDate.value!)}'
                        : 'Select Date Range',
                    style: context.textTheme.bodyMedium,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.date_range),
                  onPressed: () => selectDateRange(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final state = ref.watch(attendanceListNotifierProvider(userId));

                return RefreshIndicator(
                  onRefresh: () async {
                    Future.microtask(() {
                      ref
                          .read(attendanceListNotifierProvider(userId).notifier)
                          .startListening(
                            startDate: startDate.value,
                            endDate: endDate.value,
                          );
                    });
                  },
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index >= state.attendance.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: LoadingIndicator(),
                              );
                            }
                            final attendance = state.attendance[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: ListTile(
                                title: Text(
                                  attendance.type == 'check_in'
                                      ? 'Check-In'
                                      : 'Check-Out',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  'Time: ${DateFormat.yMd().add_jm().format(attendance.timestamp)}',
                                ),
                                trailing: attendance.isSynced
                                    ? const Icon(Icons.cloud_done,
                                        color: Colors.green)
                                    : const Icon(Icons.cloud_off,
                                        color: Colors.red),
                              ),
                            );
                          },
                          childCount:
                              state.attendance.length + (state.hasMore ? 1 : 0),
                        ),
                      ),
                      if (state.isLoading && state.attendance.isEmpty)
                        const SliverFillRemaining(
                          child: Center(child: LoadingIndicator()),
                        ),
                      if (state.error != null)
                        SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Error: ${state.error}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.red),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    Future.microtask(() {
                                      ref
                                          .read(attendanceListNotifierProvider(
                                                  userId)
                                              .notifier)
                                          .startListening(
                                            startDate: startDate.value,
                                            endDate: endDate.value,
                                          );
                                    });
                                  },
                                  child: const Text('Retry'),
                                ),
                              ],
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
