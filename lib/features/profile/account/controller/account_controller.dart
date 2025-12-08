import 'package:get/get.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import 'package:quikle_vendor/routes/app_routes.dart';
import 'package:quikle_vendor/features/vendor/models/vendor_model.dart';
import '../../../user/controllers/user_controller.dart';

class AccountController extends GetxController {
  // Observable for vendor details
  final vendorDetails = Rx<VendorDetailsModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadVendorDetails();
  }

  void _loadVendorDetails() {
    final vendorData = StorageService.getVendorDetails();
    if (vendorData != null) {
      vendorDetails.value = VendorDetailsModel.fromJson(vendorData);
    }
  }

  Future<void> signOut() async {
    await StorageService.logoutUser();
    Get.find<UserController>().clearVendorDetails();
    vendorDetails.value = null;
    Get.offAllNamed(AppRoute.login);
  }
}
