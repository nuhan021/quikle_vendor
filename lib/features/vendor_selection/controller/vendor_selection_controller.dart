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
      Get.snackbar("Warning", "Please select a vendor type first");
      return;
    }

    // TODO: Send selected vendor type to API or save locally
    // Example:
    // await ApiService.saveVendorType(selectedVendor.value);

    Get.offAllNamed(AppRoute.kycVerificationScreen);

    Get.snackbar(
      "Success",
      "You joined as ${selectedVendor.value}!",
      snackPosition: SnackPosition.BOTTOM,
    );

    // TODO: Navigate to respective dashboard
    // if (selectedVendor.value == "Food Vendor") {
    //   Get.offNamed(AppRoute.foodDashboard);
    // } else {
    //   Get.offNamed(AppRoute.medicineDashboard);
    // }
  }
}
