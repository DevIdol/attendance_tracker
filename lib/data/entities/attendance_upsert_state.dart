import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/utils.dart';

part 'attendance_upsert_state.freezed.dart';

@freezed
class AttendanceUpsertState with _$AttendanceUpsertState {
  const factory AttendanceUpsertState({
    required String id,
    required String userId,
    required String type,
    @TimestampConverter() required DateTime timestamp,
    required bool isSynced,
    @Default(false) bool isLoading,
    String? error,
    @Default(false) bool hasCheckedInToday,
    @Default(false) bool hasCheckedOutToday,
  }) = _AttendanceUpsertState;
}
