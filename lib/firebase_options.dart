// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

import 'config/config.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static FirebaseOptions get android {
    if (AppConfig.isProd) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyA5sd3lT-Kbcwo2NmHAjeCR2IN5bEDjXxM',
        appId: '1:998549465498:android:c80b0d19c3356ec5a5b223',
        messagingSenderId: '998549465498',
        projectId: 'attendance-tracker-78c4d',
        storageBucket: 'attendance-tracker-78c4d.firebasestorage.app',
      );
    } else if (AppConfig.isStaging) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyA5sd3lT-Kbcwo2NmHAjeCR2IN5bEDjXxM',
        appId: '1:998549465498:android:c80b0d19c3356ec5a5b223',
        messagingSenderId: '998549465498',
        projectId: 'attendance-tracker-78c4d',
        storageBucket: 'attendance-tracker-78c4d.firebasestorage.app',
      );
    } else {
      return const FirebaseOptions(
        apiKey: 'AIzaSyA5sd3lT-Kbcwo2NmHAjeCR2IN5bEDjXxM',
        appId: '1:998549465498:android:c80b0d19c3356ec5a5b223',
        messagingSenderId: '998549465498',
        projectId: 'attendance-tracker-78c4d',
        storageBucket: 'attendance-tracker-78c4d.firebasestorage.app',
      );
    }
  }

  static FirebaseOptions get ios {
    if (AppConfig.isProd) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyBBfBiMjclKankXLVzvtiyKdgeVcjMlSx8',
        appId: '1:998549465498:ios:f952f015a3777dcba5b223',
        messagingSenderId: '998549465498',
        projectId: 'attendance-tracker-78c4d',
        storageBucket: 'attendance-tracker-78c4d.firebasestorage.app',
        iosBundleId: 'com.hst.attendanceTracker',
      );
    } else if (AppConfig.isStaging) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyBBfBiMjclKankXLVzvtiyKdgeVcjMlSx8',
        appId: '1:998549465498:ios:f952f015a3777dcba5b223',
        messagingSenderId: '998549465498',
        projectId: 'attendance-tracker-78c4d',
        storageBucket: 'attendance-tracker-78c4d.firebasestorage.app',
        iosBundleId: 'com.hst.attendanceTracker',
      );
    } else {
      return const FirebaseOptions(
        apiKey: 'AIzaSyBBfBiMjclKankXLVzvtiyKdgeVcjMlSx8',
        appId: '1:998549465498:ios:f952f015a3777dcba5b223',
        messagingSenderId: '998549465498',
        projectId: 'attendance-tracker-78c4d',
        storageBucket: 'attendance-tracker-78c4d.firebasestorage.app',
        iosBundleId: 'com.hst.attendanceTracker',
      );
    }
  }
}
