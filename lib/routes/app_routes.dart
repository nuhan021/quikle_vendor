import 'package:get/get.dart';
import 'package:quikle_vendor/features/cupons/screen/cupon_screen.dart';
import 'package:quikle_vendor/features/home/screen/home_screen.dart';
import 'package:quikle_vendor/features/kyc_approval/screen/kyc_approval_screen.dart';
import 'package:quikle_vendor/features/kyc_verification/screen/kyc_verification_screen.dart';
import 'package:quikle_vendor/features/navbar/screen/navbar_screen.dart';
import 'package:quikle_vendor/features/order_management/screen/completed_order_details_screen.dart';
import 'package:quikle_vendor/features/product_management/screen/edit_product_screen.dart';
import 'package:quikle_vendor/features/splash/presentation/screens/splash_screen.dart';
import 'package:quikle_vendor/features/vendor_selection/screen/vendor_selection_screen.dart'
    show VendorSelectionScreen;

import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/resgiter_screen.dart';
import '../features/auth/presentation/screens/verification_screen.dart';
import '../features/auth/presentation/screens/welcome_screen.dart';
import '../features/earnings/screen/earnings_screen.dart';
import '../features/order_management/screen/order_management_screen.dart';
import '../features/product_management/screen/products_screen.dart';
import '../features/profile/edit_profile/screen/edit_profile_screen.dart';
import '../features/profile/help_and_support/screen/help_and_support_screen.dart';
import '../features/profile/my_profile/screen/my_profile_screen.dart';
import '../features/profile/notification_settings/screen/notification_settings_screen.dart'
    show NotificationSettingsScreen;
import '../features/profile/payment_method/screen/payment_method_screen.dart';

class AppRoute {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String verify = '/verify';
  static const String welcome = '/welcome';
  static String vendorSelectionScreen = '/vendorSelectionScreen';
  static String kycVerificationScreen = '/kycVerificationScreen';
  static String kycApprovalScreen = '/kycApprovalScreen';
  static String homeScreen = "/homeScreen";
  static String navbarScreen = '/navbarScreen';
  static String myProfileScreen = '/myProfileScreen';
  static String editProfileScreen = '/editProfileScreen';
  static String earningsScreen = '/earningsScreen';
  static String paymentMethodScreen = '/paymentMethodScreen';
  static String notificationSettingsScreen = '/notificationSettingsScreen';
  static String helpAndSupportScreen = '/helpAndSupportScreen';
  static String orderManagementScreen = '/orderManagementScreen';
  static String completedOrderDetailsScreen = '/completedOrderDetailsScreen';
  static String productManagementScreen = '/productManagementScreen';
  static String productEditScreen = '/productEditScreen';
  static String cuponsScreen = '/cuponsScreen';

  static String getSplashScreen() => splash;
  static String getLoginScreen() => login;
  static String getRegister() => register;
  static String getVerify() => verify;
  static String getVendorSelectionScreen() => vendorSelectionScreen;
  static String getKycVerificationScreen() => kycVerificationScreen;
  static String getKycApprovalScreen() => kycApprovalScreen;
  static String getNavbarScreen() => navbarScreen;
  static String getMyProfileScreen() => myProfileScreen;
  static String getEditProfileScreen() => editProfileScreen;
  static String getEarningsScreen() => earningsScreen;
  static String getPaymentMethodScreen() => paymentMethodScreen;
  static String getNotificationSettingsScreen() => notificationSettingsScreen;
  static String getHelpAndSupportScreen() => helpAndSupportScreen;
  static String getOrderManagementScreen() => orderManagementScreen;
  static String getCompletedOrderDetailsScreen() => completedOrderDetailsScreen;
  static String getCuponScreen() => cuponsScreen;

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: register, page: () => RegisterScreen()),
    GetPage(name: verify, page: () => const VerificationScreen()),
    GetPage(name: welcome, page: () => const WelcomeScreen()),
    GetPage(name: vendorSelectionScreen, page: () => VendorSelectionScreen()),
    GetPage(name: kycVerificationScreen, page: () => KycVerificationScreen()),
    GetPage(name: kycApprovalScreen, page: () => KycApprovalScreen()),
    GetPage(name: homeScreen, page: () => HomeScreen()),
    GetPage(name: navbarScreen, page: () => NavbarScreen()),
    GetPage(name: myProfileScreen, page: () => MyProfileScreen()),
    GetPage(name: editProfileScreen, page: () => EditProfileScreen()),
    GetPage(name: earningsScreen, page: () => EarningsScreen()),
    GetPage(name: paymentMethodScreen, page: () => PaymentMethodScreen()),
    GetPage(
      name: notificationSettingsScreen,
      page: () => NotificationSettingsScreen(),
    ),
    GetPage(name: helpAndSupportScreen, page: () => HelpAndSupportScreen()),
    GetPage(name: orderManagementScreen, page: () => OrderManagementScreen()),
    GetPage(
      name: completedOrderDetailsScreen,
      page: () => CompletedOrderDetailsScreen(),
    ),
    GetPage(name: productManagementScreen, page: () => ProductsScreen()),
    GetPage(name: productEditScreen, page: () => EditProductScreen()),
    GetPage(name: cuponsScreen, page: () => CuponScreen()),
  ];
}
