import 'package:get/get.dart';

class NotificationSettingsController extends GetxController {
  /// Toggles
  var orderNotifications = true.obs;
  var pushNotifications = true.obs;
  var sound = true.obs;
  var vibration = true.obs;

  /// Toggle functions
  void toggleOrder(bool value) => orderNotifications.value = value;
  void togglePush(bool value) => pushNotifications.value = value;
  void toggleSound(bool value) => sound.value = value;
  void toggleVibration(bool value) => vibration.value = value;
}
