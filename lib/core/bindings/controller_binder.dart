import 'package:get/get.dart';
import 'package:quikle_vendor/features/splash/controllers/splash_controller.dart';
import '../../features/auth/controllers/welcome_controller.dart';
import '../../features/auth/data/services/auth_service.dart';
import '../../features/vendor/controllers/vendor_controller.dart';
import '../../features/vendor/services/vendor_service.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    // Services - permanent, stays for app lifetime
    Get.put<UserService>(UserService(), permanent: true);
    Get.put<AuthService>(AuthService(), permanent: true);
    // Get.put<UserController>(UserController(), permanent: true);

    // Controllers - permanent
    Get.put<SplashController>(SplashController(), permanent: true);

    // Note: Auth Controllers (Login, Register, Verification) are NOT initialized here
    // They will be created on-demand when their screens are accessed
    // This allows them to be properly disposed when leaving those screens

    Get.lazyPut<WelcomeController>(() => WelcomeController(), fenix: true);
  }
}
