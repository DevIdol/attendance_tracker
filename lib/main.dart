import 'package:attendance_tracker/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'config/config.dart';
import 'core/utils/utils.dart';
import 'data/data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await GetStorage.init();
  await Hive.initFlutter();
  Hive.registerAdapter(AttendanceAdapter());
  await Hive.openBox<Attendance>('attendanceBox');

  final messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  await messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    logger.i('Received foreground message: ${message.messageId}');
    logger.i('Notification data: ${message.data}');
    if (message.notification != null) {
      logger
          .i('Message also contained a notification: ${message.notification}');
    }
  });

  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  logger
    ..i('Handling background message: ${message.messageId}')
    ..i('Notification data: ${message.data}');

  if (message.data.containsKey('type')) {
    logger
      ..i('Notification type: ${message.data['type']}')
      ..i('User ID: ${message.data['userId']}');
  }
}
