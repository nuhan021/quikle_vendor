import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:quikle_vendor/core/utils/logging/logger.dart';

class FirebaseService {
  static Future<void> init() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(); // initializing firebase
    }
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    // iOS permissions
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    // ensure auto-initialization
    await messaging.setAutoInitEnabled(true);

    // listen for token refreshes
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      AppLoggerHelper.info("FCM Token refreshed: $newToken");
      // save or send the refreshed token to your server here
    });

    // get device token (try once, then retry quickly if null)
    String? token;
    try {
      token = await messaging.getToken();
      if (token == null) {
        await Future.delayed(Duration(seconds: 1));
        token = await messaging.getToken();
      }
    } catch (e, st) {
      AppLoggerHelper.info("Error retrieving FCM token: $e\n$st");
    }

    // developer can save the FCM Token to local database from here
    AppLoggerHelper.info("FCM Token(device): $token");
  }
}
