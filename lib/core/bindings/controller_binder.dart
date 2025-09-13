import 'package:get/get.dart';
import 'package:quikle_vendor/features/splash/controllers/splash_controller.dart';

import '../../features/auth/controllers/auth_controller.dart';
import '../../features/auth/controllers/login_controller.dart';
import '../../features/auth/controllers/register_controller.dart';
import '../../features/auth/controllers/verification_controller.dart';
import '../../features/auth/controllers/welcome_controller.dart';
import '../../features/auth/data/services/auth_service.dart';
import '../../features/user/controllers/user_controller.dart';
import '../../features/user/data/services/user_service.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.put<UserService>(UserService(), permanent: true);
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<UserController>(UserController(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);

    // Controllers
    Get.put<SplashController>(SplashController(), permanent: true);
    Get.put<LoginController>(LoginController(), permanent: true);
    Get.put<RegisterController>(RegisterController(), permanent: true);
    Get.put<VerificationController>(VerificationController(), permanent: true);
    Get.lazyPut<WelcomeController>(() => WelcomeController(), fenix: true);
  }
}
