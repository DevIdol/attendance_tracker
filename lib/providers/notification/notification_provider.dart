import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/constants.dart';
import '../../core/utils/utils.dart';
import '../../repositories/repositories.dart';
import '../providers.dart';

part 'notification_provider.g.dart';

@Riverpod(keepAlive: true)
class NotificationNotifier extends _$NotificationNotifier {
  @override
  String? build() {
    _initFcmToken();
    return null;
  }

  Future<void> _initFcmToken() async {
    try {
      final token =
          await ref.read(notificationRepositoryProvider).getFcmToken();
      if (token != null) {
        state = token;
        logger.i('FCM token initialized: $token');

        final user = ref.read(authNotifierProvider).value;
        if (user != null) {
          if (user.role == UserRole.admin) {
            await ref
                .read(notificationRepositoryProvider)
                .subscribeToTopic('admin');
            logger.i('Subscribed to admin topic');
          }

          await updateFcmToken(user.id);
        }
      }
    } catch (e) {
      logger.e('Error initializing FCM token: $e');
    }
  }

  Future<void> updateFcmToken(String userId) async {
    try {
      final token =
          await ref.read(notificationRepositoryProvider).getFcmToken();
      if (token != null && token != state) {
        await ref
            .read(authNotifierProvider.notifier)
            .updateFcmToken(userId, token);
        state = token;
        logger.i('FCM token updated for user: $userId');
      }
    } catch (e) {
      logger.e('Error updating FCM token: $e');
    }
  }

  Future<void> sendAdminNotification(
      String title, String body, String userId, String type) async {
    try {
      await ref.read(notificationRepositoryProvider).sendNotificationToAdmins(
            title,
            body,
            userId,
            type,
          );
      logger.i('Admin notification sent successfully');
    } catch (e) {
      logger.e('Error sending admin notification: $e');
      rethrow;
    }
  }
}
