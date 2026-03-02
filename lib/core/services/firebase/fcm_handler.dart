import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_service.dart';

class FCMHandler {
  static void configure() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final imageUrl =
          message.notification?.android?.imageUrl ??
          message.notification?.apple?.imageUrl;

      NotificationService.sendLocalNotification(
        title: message.notification?.title ?? '',
        body: message.notification?.body ?? '',
        payload: message.data['screen'] ?? '',
        imageUrl: imageUrl,
      );
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final screen = message.data['screen'];
      if (screen != null) {
      }
    });
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp();
    if (message.notification != null) {
      await NotificationService.sendLocalNotification(
        title: message.notification?.title ?? '',
        body: message.notification?.body ?? '',
        payload: message.data['screen'] ?? '',
      );
    }
  }
}
