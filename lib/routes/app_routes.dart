import 'package:get/get.dart';
import 'package:quikle_vendor/features/navbar/screen/navbar_screen.dart';

import '../features/authentication/presentation/screens/login_screen.dart';
import '../features/earnings/screen/earnings_screen.dart';
import '../features/profile/edit_profile/screen/edit_profile_screen.dart';
import '../features/profile/my_profile/screen/my_profile_screen.dart';
import '../features/profile/notification_settings/screen/notification_settings_screen.dart'
    show NotificationSettingsScreen;
import '../features/profile/payment_method/screen/payment_method_screen.dart';

class AppRoute {
  static String loginScreen = "/loginScreen";
  static String navbarScreen = '/navbarScreen';
  static String myProfileScreen = '/myProfileScreen';
  static String editProfileScreen = '/editProfileScreen';
  static String earningsScreen = '/earningsScreen';
  static String paymentMethodScreen = '/paymentMethodScreen';
  static String notificationSettingsScreen = '/notificationSettingsScreen';

  static String getLoginScreen() => loginScreen;
  static String getNavbarScreen() => navbarScreen;
  static String getMyProfileScreen() => myProfileScreen;
  static String getEditProfileScreen() => editProfileScreen;
  static String getEarningsScreen() => earningsScreen;
  static String getPaymentMethodScreen() => paymentMethodScreen;
  static String getNotificationSettingsScreen() => notificationSettingsScreen;

  static List<GetPage> routes = [
    GetPage(name: loginScreen, page: () => HomeScreen()),
    GetPage(name: navbarScreen, page: () => NavbarScreen()),
    GetPage(name: myProfileScreen, page: () => MyProfileScreen()),
    GetPage(name: editProfileScreen, page: () => EditProfileScreen()),
    GetPage(name: earningsScreen, page: () => EarningsScreen()),
    GetPage(name: paymentMethodScreen, page: () => PaymentMethodScreen()),
    GetPage(
      name: notificationSettingsScreen,
      page: () => NotificationSettingsScreen(),
    ),
  ];
}
