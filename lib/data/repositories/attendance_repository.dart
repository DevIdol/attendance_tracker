import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/services/hive_service.dart';
import '../../core/utils/utils.dart';
import '../entities/entities.dart';
import 'notification_repository.dart';

abstract class AttendanceRepository {
  Future<void> checkIn(String userId);
  Future<void> checkOut(String userId, String checkInId);
  Stream<List<Attendance>> getUserAttendance(String userId,
      {DateTime? startDate,
      DateTime? endDate,
      int limit = 20,
      String? lastDocumentId});
  Stream<List<Attendance>> getAllAttendance(
      {DateTime? startDate,
      DateTime? endDate,
      int limit = 20,
      String? lastDocumentId});
  Future<bool> hasCheckedInToday(String userId);
  Future<bool> hasCheckedOutToday(String userId);
  Future<String?> getTodayCheckInId(String userId);
  Future<void> syncPendingAttendance();
}

class AttendanceRepositoryImpl implements AttendanceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Ref _ref;

  AttendanceRepositoryImpl(this._ref);

  @override
  Future<void> checkIn(String userId) async {
    try {
      logger.i('Attempting check-in for user: $userId');
      final hasCheckedIn = await hasCheckedInToday(userId);
      if (hasCheckedIn) throw Exception('Already checked in today.');
      final isConnected =
          await _ref.read(connectivityServiceProvider).isConnected();

      final attendance = Attendance(
        id: _firestore.collection('attendance').doc().id,
        userId: userId,
        type: 'check_in',
        timestamp: DateTime.now(),
        isSynced: isConnected,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _ref.read(hiveServiceProvider).saveAttendance(attendance);

      if (isConnected) {
        await _firestore
            .collection('attendance')
            .doc(attendance.id)
            .set(attendance.toJson());
        await _ref
            .read(hiveServiceProvider)
            .clearSyncedAttendance(attendance.id);

        try {
          final userDoc =
              await _firestore.collection('users').doc(userId).get();
          if (userDoc.exists) {
            final user = User.fromJson(userDoc.data()!);
            await _ref
                .read(notificationRepositoryProvider)
                .sendNotificationToAdmins(
                  'Check-In Notification',
                  '${user.name} checked in at ${DateFormat('hh:mm a').format(DateTime.now())}',
                  userId,
                  'check_in',
                );
          }
        } catch (e) {
          logger.e('Failed to send notification: $e');
        }
      }

      logger.i('Check-in successful for user: $userId, synced: $isConnected');
    } catch (e) {
      logger.e('Check-in failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> checkOut(String userId, String checkInId) async {
    try {
      logger.i('Attempting check-out for user: $userId');
      final isConnected =
          await _ref.read(connectivityServiceProvider).isConnected();

      final checkOutAttendance = Attendance(
        id: checkInId,
        userId: userId,
        type: 'check_out',
        timestamp: DateTime.now(),
        isSynced: isConnected,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _ref.read(hiveServiceProvider).saveAttendance(checkOutAttendance);

      if (isConnected) {
        await _firestore.collection('attendance').doc(checkInId).update({
          'type': 'check_out',
          'timestamp': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'isSynced': true,
        });

        await _ref.read(hiveServiceProvider).clearSyncedAttendance(checkInId);

        try {
          final userDoc =
              await _firestore.collection('users').doc(userId).get();
          if (userDoc.exists) {
            final user = User.fromJson(userDoc.data()!);
            await _ref
                .read(notificationRepositoryProvider)
                .sendNotificationToAdmins(
                  'Check-Out Notification',
                  '${user.name} checked out at ${DateFormat('hh:mm a').format(DateTime.now())}',
                  userId,
                  'check_out',
                );
          }
        } catch (e) {
          logger.e('Failed to send notification: $e');
        }
      }

      logger.i('Check-out successful for user: $userId, synced: $isConnected');
    } catch (e) {
      logger.e('Check-out failed: $e');
      rethrow;
    }
  }

  @override
  Future<bool> hasCheckedInToday(String userId) async {
    try {
      logger.i('Checking if user $userId has active check-in today');
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final checkInQuery = await _firestore
          .collection('attendance')
          .where('userId', isEqualTo: userId)
          .where('type', isEqualTo: 'check_in')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .orderBy('timestamp', descending: true)
          .get();

      final checkOutQuery = await _firestore
          .collection('attendance')
          .where('userId', isEqualTo: userId)
          .where('type', isEqualTo: 'check_out')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .orderBy('timestamp', descending: true)
          .get();

      final offlineAttendance =
          await _ref.read(hiveServiceProvider).getPendingAttendance();
      final offlineCheckIns = offlineAttendance
          .where((a) =>
              a.userId == userId &&
              a.type == 'check_in' &&
              a.timestamp.isAfter(startOfDay) &&
              a.timestamp.isBefore(endOfDay))
          .toList();
      final offlineCheckOuts = offlineAttendance
          .where((a) =>
              a.userId == userId &&
              a.type == 'check_out' &&
              a.timestamp.isAfter(startOfDay) &&
              a.timestamp.isBefore(endOfDay))
          .toList();

      final allCheckIns = [
        ...checkInQuery.docs.map((doc) => Attendance.fromJson(doc.data())),
        ...offlineCheckIns,
      ]..sort((a, b) => b.timestamp.compareTo(a.timestamp));

      final allCheckOuts = [
        ...checkOutQuery.docs.map((doc) => Attendance.fromJson(doc.data())),
        ...offlineCheckOuts,
      ]..sort((a, b) => b.timestamp.compareTo(a.timestamp));

      if (allCheckIns.isEmpty) {
        logger.i('User $userId has no check-ins today');
        return false;
      }

      final latestCheckIn = allCheckIns.first;
      final hasCheckOut = allCheckOuts.any((checkOut) =>
          checkOut.id == latestCheckIn.id &&
          checkOut.timestamp.isAfter(latestCheckIn.timestamp));

      logger.i('User $userId has active check-in: ${!hasCheckOut}');
      return !hasCheckOut;
    } catch (e) {
      logger.e('Failed to check check-in status: $e');
      rethrow;
    }
  }

  @override
  Future<bool> hasCheckedOutToday(String userId) async {
    try {
      logger.i('Checking if user $userId has checked out today');
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final checkInQuery = await _firestore
          .collection('attendance')
          .where('userId', isEqualTo: userId)
          .where('type', isEqualTo: 'check_in')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .orderBy('timestamp', descending: true)
          .get();

      final checkOutQuery = await _firestore
          .collection('attendance')
          .where('userId', isEqualTo: userId)
          .where('type', isEqualTo: 'check_out')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .orderBy('timestamp', descending: true)
          .get();

      final offlineAttendance =
          await _ref.read(hiveServiceProvider).getPendingAttendance();
      final offlineCheckIns = offlineAttendance
          .where((a) =>
              a.userId == userId &&
              a.type == 'check_in' &&
              a.timestamp.isAfter(startOfDay) &&
              a.timestamp.isBefore(endOfDay))
          .toList();
      final offlineCheckOuts = offlineAttendance
          .where((a) =>
              a.userId == userId &&
              a.type == 'check_out' &&
              a.timestamp.isAfter(startOfDay) &&
              a.timestamp.isBefore(endOfDay))
          .toList();

      final allCheckIns = [
        ...checkInQuery.docs.map((doc) => Attendance.fromJson(doc.data())),
        ...offlineCheckIns,
      ]..sort((a, b) => b.timestamp.compareTo(a.timestamp));

      final allCheckOuts = [
        ...checkOutQuery.docs.map((doc) => Attendance.fromJson(doc.data())),
        ...offlineCheckOuts,
      ]..sort((a, b) => b.timestamp.compareTo(a.timestamp));

      if (allCheckIns.isEmpty) {
        logger.i('User $userId has no check-ins, so no check-outs');
        return false;
      }

      final latestCheckIn = allCheckIns.first;
      final hasCheckOut = allCheckOuts.any((checkOut) =>
          checkOut.id == latestCheckIn.id &&
          checkOut.timestamp.isAfter(latestCheckIn.timestamp));

      logger.i('User $userId has checked out latest check-in: $hasCheckOut');
      return hasCheckOut;
    } catch (e) {
      logger.e('Failed to check check-out status: $e');
      rethrow;
    }
  }

  @override
  Future<String?> getTodayCheckInId(String userId) async {
    try {
      logger.i('Getting today\'s active check-in ID for user: $userId');
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final checkInQuery = await _firestore
          .collection('attendance')
          .where('userId', isEqualTo: userId)
          .where('type', isEqualTo: 'check_in')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      final offlineAttendance =
          await _ref.read(hiveServiceProvider).getPendingAttendance();
      final offlineCheckIns = offlineAttendance
          .where((a) =>
              a.userId == userId &&
              a.type == 'check_in' &&
              a.timestamp.isAfter(startOfDay) &&
              a.timestamp.isBefore(endOfDay))
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

      final allCheckIns = [
        ...checkInQuery.docs.map((doc) => Attendance.fromJson(doc.data())),
        ...offlineCheckIns,
      ]..sort((a, b) => b.timestamp.compareTo(a.timestamp));

      final checkOutQuery = await _firestore
          .collection('attendance')
          .where('userId', isEqualTo: userId)
          .where('type', isEqualTo: 'check_out')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .get();

      final offlineCheckOuts = offlineAttendance
          .where((a) =>
              a.userId == userId &&
              a.type == 'check_out' &&
              a.timestamp.isAfter(startOfDay) &&
              a.timestamp.isBefore(endOfDay))
          .toList();

      final allCheckOuts = [
        ...checkOutQuery.docs.map((doc) => Attendance.fromJson(doc.data())),
        ...offlineCheckOuts,
      ];

      if (allCheckIns.isEmpty) {
        logger.i('No check-ins found for user $userId today');
        return null;
      }

      final latestCheckIn = allCheckIns.first;
      final hasCheckOut = allCheckOuts.any((checkOut) =>
          checkOut.id == latestCheckIn.id &&
          checkOut.timestamp.isAfter(latestCheckIn.timestamp));

      if (hasCheckOut) {
        logger.i('Latest check-in for user $userId has been checked out');
        return null;
      }

      logger.i('Today\'s active check-in ID: ${latestCheckIn.id}');
      return latestCheckIn.id;
    } catch (e) {
      logger.e('Failed to get today\'s check-in ID: $e');
      rethrow;
    }
  }

  @override
  Stream<List<Attendance>> getUserAttendance(String userId,
      {DateTime? startDate,
      DateTime? endDate,
      int limit = 20,
      String? lastDocumentId}) async* {
    try {
      logger.i('Fetching attendance for user: $userId');

      Query<Map<String, dynamic>> query = _firestore
          .collection('attendance')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .limit(limit);

      if (startDate != null && endDate != null) {
        query = query
            .where('timestamp',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .where('timestamp',
                isLessThanOrEqualTo: Timestamp.fromDate(endDate));
      }

      if (lastDocumentId != null) {
        final lastDocSnapshot =
            await _firestore.collection('attendance').doc(lastDocumentId).get();
        if (lastDocSnapshot.exists) {
          query = query.startAfterDocument(lastDocSnapshot);
        }
      }

      await for (final snapshot in query.snapshots()) {
        final attendance = snapshot.docs.map((doc) {
          try {
            return Attendance.fromJson(doc.data());
          } catch (e) {
            logger.e('Error parsing attendance document ${doc.id}: $e');
            return Attendance(
              id: doc.id,
              userId: userId,
              type: 'check_in',
              timestamp: DateTime.now(),
              isSynced: true,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
          }
        }).toList();

        final offlineAttendance =
            await _ref.read(hiveServiceProvider).getPendingAttendance();
        final userOfflineAttendance =
            offlineAttendance.where((a) => a.userId == userId).toList();

        yield [...attendance, ...userOfflineAttendance];
      }
    } catch (e) {
      logger.e('Failed to fetch attendance: $e');
      rethrow;
    }
  }

  @override
  Stream<List<Attendance>> getAllAttendance(
      {DateTime? startDate,
      DateTime? endDate,
      int limit = 20,
      String? lastDocumentId}) async* {
    try {
      logger.i('Fetching all attendance records');

      Query<Map<String, dynamic>> query = _firestore
          .collection('attendance')
          .orderBy('timestamp', descending: true)
          .limit(limit);

      if (startDate != null && endDate != null) {
        query = query
            .where('timestamp',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .where('timestamp',
                isLessThanOrEqualTo: Timestamp.fromDate(endDate));
      }

      if (lastDocumentId != null) {
        final lastDocSnapshot =
            await _firestore.collection('attendance').doc(lastDocumentId).get();
        if (lastDocSnapshot.exists) {
          query = query.startAfterDocument(lastDocSnapshot);
        }
      }

      await for (final snapshot in query.snapshots()) {
        final attendance = snapshot.docs.map((doc) {
          try {
            return Attendance.fromJson(doc.data());
          } catch (e) {
            logger.e('Error parsing attendance document ${doc.id}: $e');
            return Attendance(
              id: doc.id,
              userId: 'unknown',
              type: 'check_in',
              timestamp: DateTime.now(),
              isSynced: true,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
          }
        }).toList();

        final offlineAttendance =
            await _ref.read(hiveServiceProvider).getPendingAttendance();

        yield [...attendance, ...offlineAttendance];
      }
    } catch (e) {
      logger.e('Failed to fetch all attendance: $e');
      rethrow;
    }
  }

  @override
  Future<void> syncPendingAttendance() async {
    try {
      logger.i('Syncing pending attendance records');
      final isConnected =
          await _ref.read(connectivityServiceProvider).isConnected();
      if (!isConnected) {
        logger.i('No connectivity, skipping sync');
        return;
      }

      final pendingAttendance =
          await _ref.read(hiveServiceProvider).getPendingAttendance();

      for (var attendance in pendingAttendance) {
        final syncedAttendance = attendance.copyWith(isSynced: true);
        await _ref.read(hiveServiceProvider).saveAttendance(syncedAttendance);

        if (attendance.type == 'check_in') {
          await _firestore
              .collection('attendance')
              .doc(attendance.id)
              .set(syncedAttendance.toJson());
        } else if (attendance.type == 'check_out') {
          await _firestore.collection('attendance').doc(attendance.id).update({
            'type': 'check_out',
            'timestamp': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
            'isSynced': true,
          });
        }

        await _ref
            .read(hiveServiceProvider)
            .clearSyncedAttendance(attendance.id);
      }

      logger.i('Synced ${pendingAttendance.length} pending attendance records');
    } catch (e) {
      logger.e('Failed to sync pending attendance: $e');
      rethrow;
    }
  }
}

final attendanceRepositoryProvider =
    Provider<AttendanceRepository>((ref) => AttendanceRepositoryImpl(ref));
