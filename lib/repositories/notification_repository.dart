import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

import '../core/utils/utils.dart';

abstract class NotificationRepository {
  Future<String?> getFcmToken();
  Future<void> sendNotificationToAdmins(
      String title, String body, String userId, String type);
  Future<void> subscribeToTopic(String topic);
  Future<void> unsubscribeFromTopic(String topic);
}

class NotificationRepositoryImpl implements NotificationRepository {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static const String _fcmEndpoint = 'https://fcm.googleapis.com/fcm/send';
  static const String _serverKey = 'FCM_SERVER_KEY';

  @override
  Future<String?> getFcmToken() async {
    try {
      logger.i('Fetching FCM token');
      final token = await _messaging.getToken();
      logger.i('FCM token fetched: $token');
      return token;
    } catch (e) {
      logger.e('Failed to fetch FCM token: $e');
      return null;
    }
  }

  @override
  Future<void> sendNotificationToAdmins(
      String title, String body, String userId, String type) async {
    try {
      logger.i('Sending notification to admins for user: $userId, type: $type');

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'key=$_serverKey',
      };

      final payload = {
        'notification': {
          'title': title,
          'body': body,
          'sound': 'default',
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        },
        'data': {
          'userId': userId,
          'type': type,
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'route': type == 'check_in' ? '/admin/users' : '/admin/dashboard',
        },
        'to': '/topics/admin',
        'priority': 'high',
      };

      final response = await http.post(
        Uri.parse(_fcmEndpoint),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        logger.i('Notification sent successfully to admin topic');
      } else {
        logger.e(
            'Failed to send notification: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to send notification: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error sending notification: $e');
      rethrow;
    }
  }

  @override
  Future<void> subscribeToTopic(String topic) async {
    try {
      logger.i('Subscribing to topic: $topic');
      await _messaging.subscribeToTopic(topic);
      logger.i('Subscribed to topic: $topic');
    } catch (e) {
      logger.e('Failed to subscribe to topic: $e');
      rethrow;
    }
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      logger.i('Unsubscribing from topic: $topic');
      await _messaging.unsubscribeFromTopic(topic);
      logger.i('Unsubscribed from topic: $topic');
    } catch (e) {
      logger.e('Failed to unsubscribe from topic: $e');
      rethrow;
    }
  }
}

final notificationRepositoryProvider =
    Provider<NotificationRepository>((ref) => NotificationRepositoryImpl());
