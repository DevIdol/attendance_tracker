import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../core/utils/utils.dart';
import '../../data/repositories/repositories.dart';
import 'attendance_provider.dart';
import 'auth_provider.dart';

part 'connectivity_provider.g.dart';

@Riverpod(keepAlive: true)
class ConnectivityNotifier extends _$ConnectivityNotifier {
  bool _isInitialized = false;

  @override
  bool build() {
    if (!_isInitialized) {
      _isInitialized = true;
      final service = ref.read(connectivityServiceProvider);
      service.onConnectivityChanged
          .debounceTime(const Duration(milliseconds: 500))
          .listen((List<ConnectivityResult> results) {
        final isConnected = service.hasConnection(results);
        if (state != isConnected) {
          state = isConnected;
          logger.i('Connectivity changed: $isConnected');
          if (isConnected) {
            _syncAllPendingAttendance();
            _refreshAttendanceLists();
          }
        }
      });

      _initializeConnectivity();
    }
    return true;
  }

  Future<void> _initializeConnectivity() async {
    try {
      final isConnected =
          await ref.read(connectivityServiceProvider).isConnected();
      if (state != isConnected) {
        state = isConnected;
        logger.i('Initial connectivity status: $isConnected');
        if (isConnected) {
          _syncAllPendingAttendance();
          _refreshAttendanceLists();
        }
      }
    } catch (e) {
      logger.e('Error initializing connectivity: $e');
      state = false;
    }
  }

  Future<void> _syncAllPendingAttendance() async {
    try {
      final attendanceRepo = ref.read(attendanceRepositoryProvider);
      await attendanceRepo.syncPendingAttendance();
      final user = ref.read(authNotifierProvider).value;
      if (user != null) {
        await ref
            .read(attendanceUpsertNotifierProvider(user.id).notifier)
            .refreshHasCheckedInToday();
      }
      logger.i('Pending attendance synced automatically');
    } catch (e) {
      logger.e('Error syncing pending attendance: $e');
    }
  }

  void _refreshAttendanceLists() {
    final user = ref.read(authNotifierProvider).value;
    if (user != null) {
      ref
          .read(attendanceListNotifierProvider(user.id).notifier)
          .startListening();
    }
    ref.read(attendanceListNotifierProvider('').notifier).startListening();
  }
}
