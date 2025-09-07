import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../appbar/screen/appbar_screen.dart';
import '../controller/notification_settings_controller.dart';
import '../widget/notification_tile.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationSettingsController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: const AppbarScreen(title: "Notification Settings"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => Column(
            children: [
              NotificationTile(
                title: "Order Notifications",
                subtitle: "New orders, cancellations, status updates",
                value: controller.orderNotifications.value,
                onChanged: controller.toggleOrder,
              ),
              NotificationTile(
                title: "Push Notifications",
                subtitle: "System updates, promotional offers",
                value: controller.pushNotifications.value,
                onChanged: controller.togglePush,
              ),
              NotificationTile(
                title: "Sound",
                value: controller.sound.value,
                onChanged: controller.toggleSound,
              ),
              NotificationTile(
                title: "Vibration",
                value: controller.vibration.value,
                onChanged: controller.toggleVibration,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
