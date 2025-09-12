import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/utils/utils.dart';
import '../../../data/data.dart';
import '../../../providers/providers.dart';
import '../../widgets/widgets.dart';

class AdminDashboardScreen extends HookConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final usersAsync = ref.watch(userListNotifierProvider);
    final attendanceStream = ref
        .watch(attendanceListNotifierProvider('').notifier)
        .getAllAttendance(startDate: startOfDay);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(userListNotifierProvider.notifier).fetchUsers();
      });
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: const [
          ConnectivityStatus(),
          ThemeToggleButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            usersAsync.when(
              data: (state) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Total Users',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${state.users.length}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              loading: () => const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (e, _) {
                logger.e('Error fetching users: $e');
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Error: $e'),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            StreamBuilder<List<Attendance>>(
              stream: attendanceStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  logger.e('Error fetching attendance: ${snapshot.error}');
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  );
                }
                final attendance = snapshot.data ?? [];
                final checkIns =
                    attendance.where((a) => a.type == 'check_in').length;
                final checkOuts =
                    attendance.where((a) => a.type == 'check_out').length;

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          "Today's Attendance",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Text('Check-ins'),
                                Text(
                                  '$checkIns',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Text('Check-outs'),
                                Text(
                                  '$checkOuts',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'View Users',
              onPressed: () {
                logger.i('Navigating to user list');
                context.push('/admin/users');
              },
            ),
          ],
        ),
      ),
    );
  }
}
