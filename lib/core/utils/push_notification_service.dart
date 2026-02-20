import 'package:flutter/material.dart';

/// Push Notification Service
///
/// To enable real push notifications:
/// 1. Uncomment firebase_core, firebase_messaging, flutter_local_notifications in pubspec.yaml
/// 2. Add google-services.json to android/app/
/// 3. Add GoogleService-Info.plist to ios/Runner/
/// 4. Run: flutterfire configure
class PushNotificationService {
  static Future<void> initialize() async {
    debugPrint('Push notifications not configured.');
  }

  static Future<void> subscribeToTopic(String topic) async {}
  static Future<void> unsubscribeFromTopic(String topic) async {}
}
