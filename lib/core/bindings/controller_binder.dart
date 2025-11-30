import 'package:get/get.dart';
import 'package:quikle_vendor/features/splash/controllers/splash_controller.dart';
import '../../features/auth/controllers/welcome_controller.dart';
import '../../features/auth/data/services/auth_service.dart';
import '../../features/vendor/services/vendor_service.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put<UserService>(UserService(), permanent: true);
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<SplashController>(SplashController(), permanent: true);
    Get.lazyPut<WelcomeController>(() => WelcomeController(), fenix: true);
  }
}
