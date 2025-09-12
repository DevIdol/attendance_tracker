import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/data.dart';
import '../utils/utils.dart';

abstract class HiveService {
  Future<void> saveAttendance(Attendance attendance);
  Future<List<Attendance>> getPendingAttendance();
  Future<void> clearSyncedAttendance(String attendanceId);
}

class HiveServiceImpl implements HiveService {
  static const String _attendanceBoxName = 'attendanceBox';

  @override
  Future<void> saveAttendance(Attendance attendance) async {
    try {
      final box = Hive.box<Attendance>(_attendanceBoxName);
      await box.put(attendance.id, attendance);
      logger.i('Saved attendance to Hive: ${attendance.id}');
    } catch (e) {
      logger.e('Failed to save attendance to Hive: $e');
      rethrow;
    }
  }

  @override
  Future<List<Attendance>> getPendingAttendance() async {
    try {
      final box = Hive.box<Attendance>(_attendanceBoxName);
      final pending =
          box.values.where((attendance) => !attendance.isSynced).toList();
      logger.i(
          'Retrieved ${pending.length} pending attendance records from Hive');
      return pending;
    } catch (e) {
      logger.e('Failed to retrieve pending attendance from Hive: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearSyncedAttendance(String attendanceId) async {
    try {
      final box = Hive.box<Attendance>(_attendanceBoxName);
      await box.delete(attendanceId);
      logger.i('Cleared synced attendance from Hive: $attendanceId');
    } catch (e) {
      logger.e('Failed to clear synced attendance from Hive: $e');
      rethrow;
    }
  }
}

final hiveServiceProvider = Provider<HiveService>((ref) => HiveServiceImpl());
