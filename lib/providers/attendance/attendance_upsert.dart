import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/services/services.dart';
import '../../core/utils/utils.dart';
import '../../repositories/repositories.dart';
import 'attendance_upsert_state.dart';

part 'attendance_upsert.g.dart';

@Riverpod(keepAlive: true)
class AttendanceUpsertNotifier extends _$AttendanceUpsertNotifier {
  @override
  AttendanceUpsertState build(String userId) {
    Future.microtask(() {
      _syncPendingAttendance();
      refreshHasCheckedInToday();
    });

    return AttendanceUpsertState(
      id: '',
      userId: userId,
      type: '',
      timestamp: DateTime.now(),
      isSynced: false,
      isLoading: false,
      hasCheckedInToday: false,
      hasCheckedOutToday: false,
    );
  }

  Future<void> _syncPendingAttendance() async {
    try {
      await ref.read(attendanceRepositoryProvider).syncPendingAttendance();
      await refreshHasCheckedInToday();
      await refreshHasCheckedOutToday();
    } catch (e) {
      logger.e('Failed to sync pending attendance: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> refreshHasCheckedInToday() async {
    try {
      final hasCheckedIn = await ref
          .read(attendanceRepositoryProvider)
          .hasCheckedInToday(state.userId);
      state = state.copyWith(hasCheckedInToday: hasCheckedIn);
    } catch (e) {
      logger.e('Failed to refresh check-in status: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> refreshHasCheckedOutToday() async {
    try {
      final hasCheckedOut = await ref
          .read(attendanceRepositoryProvider)
          .hasCheckedOutToday(state.userId);
      state = state.copyWith(hasCheckedOutToday: hasCheckedOut);
    } catch (e) {
      logger.e('Failed to refresh check-out status: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> checkIn(String userId, String userName) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final isConnected =
          await ref.read(connectivityServiceProvider).isConnected();
      await ref.read(attendanceRepositoryProvider).checkIn(userId);
      state = state.copyWith(
        isLoading: false,
        hasCheckedInToday: true,
        hasCheckedOutToday: false,
        id: '',
        type: 'check_in',
        timestamp: DateTime.now(),
        isSynced: isConnected,
        error: null,
      );
    } catch (e) {
      logger.e('Check-in error: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> checkOut(String userId, String userName) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final isConnected =
          await ref.read(connectivityServiceProvider).isConnected();
      final checkInId = await ref
          .read(attendanceRepositoryProvider)
          .getTodayCheckInId(userId);
      if (checkInId == null) {
        throw Exception('No active check-in found for today');
      }

      await ref.read(attendanceRepositoryProvider).checkOut(userId, checkInId);
      state = state.copyWith(
        isLoading: false,
        hasCheckedInToday: false,
        hasCheckedOutToday: true,
        id: '',
        type: 'check_out',
        timestamp: DateTime.now(),
        isSynced: isConnected,
        error: null,
      );

      await refreshHasCheckedInToday();
      await refreshHasCheckedOutToday();
    } catch (e) {
      logger.e('Check-out error: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }
}
