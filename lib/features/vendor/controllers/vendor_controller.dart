import 'package:get/get.dart';
import '../models/vendor_model.dart';

class VendorController extends GetxController {
  // Observable for vendor details
  final vendorDetails = Rx<VendorDetailsModel?>(null);

  /// Set vendor details from API response
  void setVendorDetails(Map<String, dynamic> vendorJson) {
    vendorDetails.value = VendorDetailsModel.fromJson(vendorJson);
  }

  /// Get vendor details
  VendorDetailsModel? getVendorDetails() => vendorDetails.value;

  /// Clear vendor details
  void clearVendorDetails() {
    vendorDetails.value = null;
  }
}
