import 'package:get/get.dart';
import 'package:quikle_vendor/features/vendor/models/vendor_model.dart';

class UserController extends GetxController {
  final vendorDetails = Rx<VendorDetailsModel?>(null);

  void setVendorDetails(Map<String, dynamic> vendorJson) {
    vendorDetails.value = VendorDetailsModel.fromJson(vendorJson);
  }

  VendorDetailsModel? getVendorDetails() => vendorDetails.value;

  void clearVendorDetails() {
    vendorDetails.value = null;
  }
}
