import 'package:get/get.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import 'package:quikle_vendor/routes/app_routes.dart';
import '../../../user/controllers/user_controller.dart';

class AccountController extends GetxController {
  Future<void> signOut() async {
    await StorageService.logoutUser();
    Get.find<UserController>().clearVendorDetails();
    Get.offAllNamed(AppRoute.login);
  }
}
