import 'package:flutter/cupertino.dart';

import 'fcm_handler.dart';
import 'firebase_service.dart';
import 'notification_service.dart';

class AppNotificationInitializer {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await FirebaseService.init(); 
    await NotificationService.init(); 
    FCMHandler.configure(); 
    
  }
}
