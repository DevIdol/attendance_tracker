import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/utils/utils.dart';

part 'attendance.freezed.dart';
part 'attendance.g.dart';

@freezed
@HiveType(typeId: 0)
class Attendance with _$Attendance {
  const factory Attendance({
    @HiveField(0) required String id,
    @HiveField(1) required String userId,
    @HiveField(2) required String type,
    @HiveField(3) @TimestampConverter() required DateTime timestamp,
    @HiveField(4) required bool isSynced,
    @HiveField(5) @NullableTimestampConverter() DateTime? createdAt,
    @HiveField(6) @NullableTimestampConverter() DateTime? updatedAt,
  }) = _Attendance;

  factory Attendance.fromJson(Map<String, dynamic> json) =>
      _$AttendanceFromJson(json);
}
