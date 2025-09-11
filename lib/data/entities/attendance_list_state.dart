import 'package:freezed_annotation/freezed_annotation.dart';

import 'attendance.dart';

part 'attendance_list_state.freezed.dart';

@freezed
class AttendanceListState with _$AttendanceListState {
  const factory AttendanceListState({
    @Default([]) List<Attendance> attendance,
    @Default(false) bool isLoading,
    String? error,
    @Default(true) bool hasMore,
    String? lastDocumentId,
  }) = _AttendanceListState;
}
