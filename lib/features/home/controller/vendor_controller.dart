import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VendorController extends GetxController {
  // Vendor status
  var isVendorOpen = true.obs;

  // Vendor information
  var vendorName = "Tandoori Tarang".obs;
  var vendorImage = "assets/images/profile.png".obs;
  var operatingHours = "Until 10:30 PM".obs;

  // Stats
  var totalOrders = "150".obs;
  var totalProducts = "25".obs;
  var totalEarnings = "\$1,250".obs;

  @override
  void onInit() {
    super.onInit();
    loadVendorData();
  }

  /// Toggle vendor open/closed status
  void toggleVendorStatus() {
    isVendorOpen.value = !isVendorOpen.value;

    // Show snackbar feedback
    Get.snackbar(
      "Status Updated",
      isVendorOpen.value
          ? "Restaurant is now open"
          : "Restaurant is now closed",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isVendorOpen.value
          ? const Color(0xFF4CAF50) // AppColors.success
          : const Color(0xFFF44336), // AppColors.error
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );

    // TODO: Call API to update vendor status
    _updateVendorStatusAPI();
  }

  /// Load vendor data from API
  Future<void> loadVendorData() async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));

      // Simulate API response
      vendorName.value = "Tandoori Tarang";
      operatingHours.value = "Until 10:30 PM";
      totalOrders.value = "150";
      totalProducts.value = "25";
      totalEarnings.value = "\$1,250";
      isVendorOpen.value = true;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to load vendor data: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFF44336),
        colorText: Colors.white,
      );
    }
  }

  /// Update vendor information
  Future<void> updateVendorInfo({
    String? name,
    String? hours,
    String? image,
  }) async {
    try {
      // TODO: Call API to update vendor info
      if (name != null) vendorName.value = name;
      if (hours != null) operatingHours.value = hours;
      if (image != null) vendorImage.value = image;

      Get.snackbar(
        "Success",
        "Vendor information updated successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF4CAF50),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update vendor info: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFF44336),
        colorText: Colors.white,
      );
    }
  }

  /// Private method to update vendor status via API
  Future<void> _updateVendorStatusAPI() async {
    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(milliseconds: 300));
      print("Vendor status updated: ${isVendorOpen.value ? 'Open' : 'Closed'}");
    } catch (e) {
      print("Failed to update vendor status: $e");
    }
  }
}
