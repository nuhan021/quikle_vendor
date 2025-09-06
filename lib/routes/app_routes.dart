import 'package:get/get.dart';
import 'package:quikle_vendor/features/navbar/screen/navbar_screen.dart';

import '../features/authentication/presentation/screens/login_screen.dart';

class AppRoute {
  static String loginScreen = "/loginScreen";
  static String navbarScreen = '/navbarScreen';

  static String getLoginScreen() => loginScreen;
  static String getNavbarScreen() => navbarScreen;

  static List<GetPage> routes = [
    GetPage(name: loginScreen, page: () => HomeScreen()),
    GetPage(name: navbarScreen, page: () => NavbarScreen()),
  ];
}
