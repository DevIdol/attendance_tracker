import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../core/utils/utils.dart';
import '../data/data.dart';

abstract class UserRepository {
  Stream<List<User>> getUsers(
      {String? searchQuery, int limit = 20, String? lastDocumentId});
  Future<User> getUserById(String userId);
  Future<void> updateUser(User user);
}

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<User>> getUsers(
      {String? searchQuery, int limit = 20, String? lastDocumentId}) {
    try {
      logger.i(
          'Fetching users with searchQuery: $searchQuery, limit: $limit, lastDocumentId: $lastDocumentId');

      Query<Map<String, dynamic>> query = _firestore
          .collection('users')
          .where('role', isNotEqualTo: 'admin')
          .orderBy('name')
          .limit(limit);

      if (searchQuery != null && searchQuery.isNotEmpty) {
        final searchLower = searchQuery.toLowerCase();
        return query.snapshots().map((snapshot) {
          final allUsers =
              snapshot.docs.map((doc) => User.fromJson(doc.data())).toList();
          final filteredUsers = allUsers.where((user) {
            final nameMatch = user.name.toLowerCase().contains(searchLower);
            final emailMatch = user.email.toLowerCase().contains(searchLower);
            return nameMatch || emailMatch;
          }).toList();

          logger.i('Fetched ${filteredUsers.length} users after filtering');
          return filteredUsers;
        });
      }
      if (lastDocumentId != null) {
        final lastDocFuture =
            _firestore.collection('users').doc(lastDocumentId).get();
        return lastDocFuture.asStream().asyncExpand((lastDocSnapshot) {
          if (!lastDocSnapshot.exists) {
            logger.w('Last document not found: $lastDocumentId');
            return Stream.value([]);
          }
          query = query.startAfterDocument(lastDocSnapshot);
          return query.snapshots().map((snapshot) {
            final users =
                snapshot.docs.map((doc) => User.fromJson(doc.data())).toList();
            logger.i('Fetched ${users.length} users');
            return users;
          });
        });
      }

      return query.snapshots().map((snapshot) {
        final users =
            snapshot.docs.map((doc) => User.fromJson(doc.data())).toList();
        logger.i('Fetched ${users.length} users');
        return users;
      });
    } catch (e) {
      logger.e('Failed to fetch users: $e');
      rethrow;
    }
  }

  @override
  Future<User> getUserById(String userId) async {
    try {
      logger.i('Fetching user: $userId');
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) throw Exception('User not found');
      final user = User.fromJson(doc.data()!);
      logger.i('User fetched: $userId');
      return user;
    } catch (e) {
      logger.e('Failed to fetch user: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateUser(User user) async {
    try {
      logger.i('Updating user: ${user.id}');
      await _firestore.collection('users').doc(user.id).update(user.toJson());
      logger.i('User updated: ${user.id}');
    } catch (e) {
      logger.e('Failed to update user: $e');
      rethrow;
    }
  }
}

final userRepositoryProvider =
    Provider<UserRepository>((ref) => UserRepositoryImpl());
