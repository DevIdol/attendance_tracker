import 'package:attendance_tracker/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/utils.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class HistoryScreen extends HookConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).value;
    final scrollController = useScrollController();
    final isFetchingMore = useState(false);
    final startDate = useState<DateTime?>(null);
    final endDate = useState<DateTime?>(null);

    useEffect(() {
      if (user != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref
              .read(attendanceListNotifierProvider(user.id).notifier)
              .startListening(
                startDate: startDate.value,
                endDate: endDate.value,
              );
        });

        scrollController.addListener(() {
          if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200) {
            if (!isFetchingMore.value &&
                ref.read(attendanceListNotifierProvider(user.id)).hasMore) {
              isFetchingMore.value = true;
              ref
                  .read(attendanceListNotifierProvider(user.id).notifier)
                  .loadMore(
                    startDate: startDate.value,
                    endDate: endDate.value,
                    lastDocumentId: ref
                        .read(attendanceListNotifierProvider(user.id))
                        .lastDocumentId,
                  );
              Future.delayed(const Duration(seconds: 1), () {
                isFetchingMore.value = false;
              });
            }
          }
        });
      }
      return () => scrollController.dispose();
    }, [user]);

    Future<void> selectDateRange(BuildContext context) async {
      final picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
      );
      if (picked != null && user != null) {
        startDate.value = picked.start;
        endDate.value = picked.end;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref
              .read(attendanceListNotifierProvider(user.id).notifier)
              .startListening(
                startDate: startDate.value,
                endDate: endDate.value,
              );
        });
      }
    }

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('History')),
        body: const Center(child: Text('Please log in to view history')),
      );
    }

    final state = ref.watch(attendanceListNotifierProvider(user.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Attendance History'),
        actions: const [
          ConnectivityStatus(),
          ThemeToggleButton(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          logger.i('Refreshing attendance history for user: ${user.id}');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref
                .read(attendanceListNotifierProvider(user.id).notifier)
                .startListening(
                  startDate: startDate.value,
                  endDate: endDate.value,
                );
          });
        },
        child: CustomScrollView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
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
            ),
            if (state.isLoading && state.attendance.isEmpty)
              const SliverFillRemaining(
                  child: Center(child: LoadingIndicator())),
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
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ref
                                .read(attendanceListNotifierProvider(user.id)
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
            if (state.attendance.isEmpty &&
                state.error == null &&
                !state.isLoading)
              const SliverFillRemaining(
                  child: Center(child: Text('No attendance records found'))),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == state.attendance.length && state.hasMore) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: LoadingIndicator(),
                    );
                  }

                  if (index >= state.attendance.length) return null;

                  final attendance = state.attendance[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(
                        attendance.type == 'check_in'
                            ? 'Check-In'
                            : 'Check-Out',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Time: ${DateFormat.yMd().add_jm().format(attendance.timestamp)}',
                      ),
                      trailing: attendance.isSynced
                          ? const Icon(Icons.cloud_done, color: Colors.green)
                          : const Icon(Icons.cloud_off, color: Colors.red),
                    ),
                  );
                },
                childCount: state.attendance.length + (state.hasMore ? 1 : 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
