import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../core/constants/constants.dart';
import '../core/utils/utils.dart';
import '../data/data.dart';

abstract class AuthRepository {
  Future<User?> signIn(String email, String password);
  Future<void> signOut();
  Future<User> register(String name, String email, String password,
      {String? profileImageUrl, String? fcmToken});
  Future<void> updateFcmToken(String userId, String fcmToken);
  Future<void> updateUserLocation(String userId, GeoPoint location);
  Stream<firebase_auth.User?> get authStateChanges;
}

class AuthRepositoryImpl implements AuthRepository {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<User?> signIn(String email, String password) async {
    try {
      logger.i('Attempting sign-in for email: $email');
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userDoc =
          await _firestore.collection('users').doc(credential.user!.uid).get();

      if (!userDoc.exists) {
        logger.w('User data not found for: ${credential.user!.uid}');
        throw Exception('User data not found');
      }

      final userData = userDoc.data();
      if (userData == null) {
        logger.w(
            'User document exists but data is null for: ${credential.user!.uid}');
        throw Exception('User data is null');
      }

      final user = User.fromJson(userData);
      logger.i('Sign-in successful for user: ${user.id}');
      return user;
    } catch (e) {
      logger.e('Sign-in failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      logger.i('Signing out user');
      await _auth.signOut();
      logger.i('Sign-out successful');
    } catch (e) {
      logger.e('Sign-out failed: $e');
      rethrow;
    }
  }

  @override
  Future<User> register(String name, String email, String password,
      {String? profileImageUrl, String? fcmToken}) async {
    try {
      logger.i('Registering user: $email');
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = User(
        id: credential.user!.uid,
        email: email,
        name: name,
        role: UserRole.user,
        profileImageUrl: profileImageUrl,
        fcmTokens: fcmToken != null ? [fcmToken] : [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(user.id).set(user.toJson());

      logger.i('Registration successful for user: ${user.id}');
      return user;
    } catch (e) {
      logger.e('Registration failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateFcmToken(String userId, String fcmToken) async {
    try {
      logger.i('Updating FCM token for user: $userId');
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        logger.w('User not found: $userId');
        throw Exception('User not found');
      }

      final userData = userDoc.data();
      if (userData == null) {
        logger.w('User document exists but data is null for: $userId');
        throw Exception('User data is null');
      }

      final user = User.fromJson(userData);
      final updatedTokens = List<String>.from(user.fcmTokens);

      if (!updatedTokens.contains(fcmToken)) {
        updatedTokens.add(fcmToken);
        await _firestore.collection('users').doc(userId).update({
          'fcmTokens': updatedTokens,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        logger.i('FCM token updated for user: $userId');
      }
    } catch (e) {
      logger.e('Failed to update FCM token: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateUserLocation(String userId, GeoPoint location) async {
    try {
      logger.i('Updating location for user: $userId');
      await _firestore.collection('users').doc(userId).update({
        'location': location,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      logger.i('Location updated for user: $userId');
    } catch (e) {
      logger.e('Failed to update location: $e');
      rethrow;
    }
  }

  @override
  Stream<firebase_auth.User?> get authStateChanges => _auth.authStateChanges();
}

final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepositoryImpl());
