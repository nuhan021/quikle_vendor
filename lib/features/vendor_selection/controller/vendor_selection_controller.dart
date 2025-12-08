import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class VendorSelectionController extends GetxController {
  /// Selected vendor type
  var selectedVendor = "".obs;

  /// Select vendor
  void selectVendor(String vendorType) {
    selectedVendor.value = vendorType;
  }

  /// Submit selected vendor
  void submitSelection() {
    if (selectedVendor.isEmpty) {
      return;
    }

    Get.offAllNamed(
      AppRoute.kycVerificationScreen,
      arguments: {"vendorType": selectedVendor.value},
    );
  }
}
