import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class VendorSelectionController extends GetxController {
  var selectedVendor = "".obs;

  void selectVendor(String vendorType) {
    selectedVendor.value = vendorType;
  }

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
