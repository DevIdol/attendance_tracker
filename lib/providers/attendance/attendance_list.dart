import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/utils/utils.dart';
import '../../data/data.dart';
import '../../repositories/repositories.dart';
import 'attendance_list_state.dart';

part 'attendance_list.g.dart';

@Riverpod(keepAlive: true)
class AttendanceListNotifier extends _$AttendanceListNotifier {
  @override
  AttendanceListState build(String userId) {
    return const AttendanceListState();
  }

  void startListening({DateTime? startDate, DateTime? endDate}) {
    Future.microtask(() {
      final stream = ref
          .read(attendanceRepositoryProvider)
          .getUserAttendance(
            userId,
            startDate: startDate,
            endDate: endDate,
          )
          .handleError((error) {
        logger.e('Error in attendance stream: $error');
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to load attendance: $error',
        );
      });

      stream.listen((attendance) {
        state = state.copyWith(
          attendance: attendance,
          isLoading: false,
          hasMore: attendance.length == 20,
          lastDocumentId: attendance.isNotEmpty ? attendance.last.id : null,
          error: null,
        );
      }, onError: (e) {
        state = state.copyWith(isLoading: false, error: e.toString());
      });
    });
  }

  void loadMore(
      {DateTime? startDate, DateTime? endDate, String? lastDocumentId}) {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    Future.microtask(() {
      final stream = ref.read(attendanceRepositoryProvider).getUserAttendance(
            userId,
            startDate: startDate,
            endDate: endDate,
            lastDocumentId: lastDocumentId,
          );

      stream.listen((newAttendance) {
        state = state.copyWith(
          attendance: [...state.attendance, ...newAttendance],
          isLoading: false,
          hasMore: newAttendance.length == 20,
          lastDocumentId: newAttendance.isNotEmpty
              ? newAttendance.last.id
              : state.lastDocumentId,
        );
      }, onError: (e) {
        state = state.copyWith(
          isLoading: false,
          error: e.toString(),
        );
      });
    });
  }

  Stream<List<Attendance>> getUserAttendance(String userId,
      {DateTime? startDate,
      DateTime? endDate,
      int limit = 20,
      String? lastDocumentId}) {
    return ref.read(attendanceRepositoryProvider).getUserAttendance(
          userId,
          startDate: startDate,
          endDate: endDate,
          limit: limit,
          lastDocumentId: lastDocumentId,
        );
  }

  Stream<List<Attendance>> getAllAttendance(
      {DateTime? startDate,
      DateTime? endDate,
      int limit = 20,
      String? lastDocumentId}) {
    return ref.read(attendanceRepositoryProvider).getAllAttendance(
          startDate: startDate,
          endDate: endDate,
          limit: limit,
          lastDocumentId: lastDocumentId,
        );
  }
}
