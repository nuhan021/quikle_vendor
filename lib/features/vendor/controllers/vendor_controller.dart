import 'package:get/get.dart';
import '../models/vendor_model.dart';

class VendorController extends GetxController {
  final vendorDetails = Rx<VendorDetailsModel?>(null);

  void setVendorDetails(Map<String, dynamic> vendorJson) {
    vendorDetails.value = VendorDetailsModel.fromJson(vendorJson);
  }

  VendorDetailsModel? getVendorDetails() => vendorDetails.value;

  void clearVendorDetails() {
    vendorDetails.value = null;
  }
}
