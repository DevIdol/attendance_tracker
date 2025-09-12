import 'package:attendance_tracker/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/data.dart';
import '../../../providers/providers.dart';
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
    final isMounted = useIsMounted();

    // Get user details
    final userAsync =
        ref.watch(userListNotifierProvider.notifier).getUserById(userId);

    // Get attendance state
    final attendanceState = ref.watch(attendanceUpsertNotifierProvider(userId));

    useEffect(() {
      // Start listening for attendance data
      Future.microtask(() {
        if (isMounted()) {
          ref
              .read(attendanceListNotifierProvider(userId).notifier)
              .startListening(
                startDate: startDate.value,
                endDate: endDate.value,
              );
        }
      });

      // Refresh attendance status
      Future.microtask(() {
        if (isMounted()) {
          ref
              .read(attendanceUpsertNotifierProvider(userId).notifier)
              .refreshHasCheckedInToday();
          ref
              .read(attendanceUpsertNotifierProvider(userId).notifier)
              .refreshHasCheckedOutToday();
        }
      });

      // Pagination listener
      void listener() {
        if (!isMounted()) return;
        final state = ref.read(attendanceListNotifierProvider(userId));
        if (scrollController.hasClients &&
            scrollController.position.pixels >=
                scrollController.position.maxScrollExtent - 200 &&
            !isFetchingMore.value &&
            state.hasMore) {
          isFetchingMore.value = true;
          ref.read(attendanceListNotifierProvider(userId).notifier).loadMore(
                startDate: startDate.value,
                endDate: endDate.value,
                lastDocumentId: state.lastDocumentId,
              );
          Future.delayed(const Duration(seconds: 1), () {
            if (isMounted()) {
              isFetchingMore.value = false;
            }
          });
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
      if (picked != null && isMounted()) {
        startDate.value = picked.start;
        endDate.value = picked.end;

        Future.microtask(() {
          if (isMounted()) {
            ref
                .read(attendanceListNotifierProvider(userId).notifier)
                .startListening(
                  startDate: startDate.value,
                  endDate: endDate.value,
                );
          }
        });
      }
    }

    Future<void> handleAdminCheckIn() async {
      try {
        final user = await userAsync;
        await ref
            .read(attendanceUpsertNotifierProvider(userId).notifier)
            .checkIn(userId, user.name);
        if (context.mounted) {
          context.showSnackBar('Checked in ${user.name} successfully');
        }

        ref
            .read(attendanceListNotifierProvider(userId).notifier)
            .startListening(
              startDate: startDate.value,
              endDate: endDate.value,
            );
      } catch (e) {
        if (context.mounted) {
          context.showSnackBar('Error: $e', isError: true);
        }
      }
    }

    Future<void> handleAdminCheckOut() async {
      try {
        final user = await userAsync;
        await ref
            .read(attendanceUpsertNotifierProvider(userId).notifier)
            .checkOut(userId, user.name);
        if (context.mounted) {
          context.showSnackBar('Checked out ${user.name} successfully');
        }

        // Refresh the data
        ref
            .read(attendanceListNotifierProvider(userId).notifier)
            .startListening(
              startDate: startDate.value,
              endDate: endDate.value,
            );
      } catch (e) {
        if (context.mounted) context.showSnackBar('Error: $e', isError: true);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<User>(
          future: userAsync,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const Text('Attendance History');
            }
            return const Text('User Attendance');
          },
        ),
        actions: const [
          ConnectivityStatus(),
          ThemeToggleButton(),
        ],
      ),
      body: Column(
        children: [
          // Admin Control Buttons
          FutureBuilder<User>(
            future: userAsync,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final user = snapshot.data!;
                return Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            user.profileImageUrl != null
                                ? CircleAvatar(
                                    radius: 24,
                                    backgroundImage:
                                        NetworkImage(user.profileImageUrl!),
                                  )
                                : const CircleAvatar(
                                    radius: 24,
                                    child: Icon(Icons.person),
                                  ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    user.email,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: attendanceState.hasCheckedInToday
                                  ? null
                                  : handleAdminCheckIn,
                              icon: const Icon(Icons.login),
                              label: const Text('Check In'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: attendanceState.hasCheckedInToday &&
                                      !attendanceState.hasCheckedOutToday
                                  ? handleAdminCheckOut
                                  : null,
                              icon: const Icon(Icons.logout),
                              label: const Text('Check Out'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          attendanceState.hasCheckedInToday
                              ? attendanceState.hasCheckedOutToday
                                  ? 'Already checked out today'
                                  : 'Checked in today'
                              : 'Not checked in today',
                          style: TextStyle(
                            color: attendanceState.hasCheckedInToday
                                ? attendanceState.hasCheckedOutToday
                                    ? Colors.blue
                                    : Colors.green
                                : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const Card(
                margin: EdgeInsets.all(16),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            },
          ),

          // Date Range Selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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

          // Attendance List
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final state = ref.watch(attendanceListNotifierProvider(userId));

                return RefreshIndicator(
                  onRefresh: () async {
                    if (isMounted()) {
                      Future.microtask(() {
                        ref
                            .read(
                                attendanceListNotifierProvider(userId).notifier)
                            .startListening(
                              startDate: startDate.value,
                              endDate: endDate.value,
                            );
                      });
                    }
                  },
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    slivers: [
                      if (state.attendance.isEmpty &&
                          !state.isLoading &&
                          state.error == null)
                        const SliverFillRemaining(
                          child: Center(
                            child: Text('No attendance records found'),
                          ),
                        ),
                      if (state.attendance.isNotEmpty)
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
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        attendance.type == 'check_in'
                                            ? 'IN'
                                            : 'OUT',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: attendance.type == 'check_in'
                                              ? Colors.green
                                              : Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            childCount: state.attendance.length +
                                (state.hasMore ? 1 : 0),
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
                                    if (isMounted()) {
                                      Future.microtask(() {
                                        ref
                                            .read(
                                                attendanceListNotifierProvider(
                                                        userId)
                                                    .notifier)
                                            .startListening(
                                              startDate: startDate.value,
                                              endDate: endDate.value,
                                            );
                                      });
                                    }
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

// Custom hook to track if the widget is mounted
bool Function() useIsMounted() {
  final isMounted = useRef(true);
  useEffect(() {
    isMounted.value = true;
    return () => isMounted.value = false;
  }, const []);
  return () => isMounted.value;
}
