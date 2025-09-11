import 'package:attendance_tracker/core/utils/logger.dart';
import 'package:attendance_tracker/data/entities/user.dart';
import 'package:attendance_tracker/data/repositories/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/constants.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<User?> build() {
    _checkCurrentUser();
    return const AsyncValue.loading();
  }

  Future<void> _checkCurrentUser() async {
    try {
      final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        logger.i('Found cached user: ${currentUser.uid}');
        await _fetchUserData(currentUser.uid);
      } else {
        logger.i('No cached user found');
        state = const AsyncValue.data(null);
      }
    } catch (e) {
      logger.e('Error checking current user: $e');
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> _fetchUserData(String uid) async {
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          try {
            final user = User.fromJson(userData);
            state = AsyncValue.data(user);
            logger.i('User data fetched from cache: ${user.id}');
          } catch (e) {
            logger.e('Error parsing user data: $e');

            final user = User(
              id: uid,
              email: userData['email'] ?? 'unknown@email.com',
              name: userData['name'] ?? 'Unknown User',
              role: UserRole.values.firstWhere(
                (role) => role.toString() == 'UserRole.${userData['role']}',
                orElse: () => UserRole.user,
              ),
              profileImageUrl: userData['profileImageUrl'],
              fcmTokens: List<String>.from(userData['fcmTokens'] ?? []),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              location: userData['location'],
            );
            state = AsyncValue.data(user);
            logger.i('Created default user from partial data: ${user.id}');
          }
        } else {
          logger.w('User document exists but data is null for: $uid');
          state = const AsyncValue.data(null);
          await firebase_auth.FirebaseAuth.instance.signOut();
        }
      } else {
        logger.w('User document not found for: $uid');
        state = const AsyncValue.data(null);
        await firebase_auth.FirebaseAuth.instance.signOut();
      }
    } catch (e) {
      logger.e('Error fetching user data: $e');
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void startAuthListener() {
    final authRepo = ref.read(authRepositoryProvider);

    authRepo.authStateChanges.listen((firebaseUser) async {
      if (firebaseUser == null) {
        state = const AsyncValue.data(null);
        logger.i('No authenticated user');
      } else {
        try {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(firebaseUser.uid)
              .get();

          if (userDoc.exists) {
            final userData = userDoc.data();
            if (userData != null) {
              try {
                final user = User.fromJson(userData);
                state = AsyncValue.data(user);
                logger.i('User authenticated: ${firebaseUser.uid}');
              } catch (e) {
                logger.e('Error parsing user data: $e');

                final user = User(
                  id: firebaseUser.uid,
                  email: userData['email'] ??
                      firebaseUser.email ??
                      'unknown@email.com',
                  name: userData['name'] ??
                      firebaseUser.displayName ??
                      'Unknown User',
                  role: UserRole.values.firstWhere(
                    (role) => role.toString() == 'UserRole.${userData['role']}',
                    orElse: () => UserRole.user,
                  ),
                  profileImageUrl: userData['profileImageUrl'],
                  fcmTokens: List<String>.from(userData['fcmTokens'] ?? []),
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  location: userData['location'],
                );
                state = AsyncValue.data(user);
                logger.i('Created default user from partial data: ${user.id}');
              }
            } else {
              logger.w(
                  'User document exists but data is null for: ${firebaseUser.uid}');
              state = const AsyncValue.data(null);
              await firebase_auth.FirebaseAuth.instance.signOut();
            }
          } else {
            logger.w('User document not found for: ${firebaseUser.uid}');
            state = const AsyncValue.data(null);
            await firebase_auth.FirebaseAuth.instance.signOut();
          }
        } catch (e) {
          logger.e('Error fetching user data: $e');
          state = AsyncValue.error(e, StackTrace.current);
        }
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user =
          await ref.read(authRepositoryProvider).signIn(email, password);
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      logger.e('Sign-in error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await ref.read(authRepositoryProvider).signOut();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      logger.e('Sign-out error: $e');
      rethrow;
    }
  }

  Future<void> register(String name, String email, String password,
      {String? profileImageUrl, String? fcmToken}) async {
    state = const AsyncValue.loading();
    try {
      final user = await ref.read(authRepositoryProvider).register(
            name,
            email,
            password,
            profileImageUrl: profileImageUrl,
            fcmToken: fcmToken,
          );
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      logger.e('Registration error: $e');
      rethrow;
    }
  }

  Future<void> updateFcmToken(String userId, String fcmToken) async {
    try {
      await ref.read(authRepositoryProvider).updateFcmToken(userId, fcmToken);
    } catch (e) {
      logger.e('Error updating FCM token: $e');
      rethrow;
    }
  }

  Future<void> updateUserLocation(String userId, GeoPoint location) async {
    try {
      await ref
          .read(authRepositoryProvider)
          .updateUserLocation(userId, location);
    } catch (e) {
      logger.e('Error updating user location: $e');
      rethrow;
    }
  }
}
