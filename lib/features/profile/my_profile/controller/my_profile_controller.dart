import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import 'package:quikle_vendor/features/vendor/models/vendor_model.dart';
import 'package:quikle_vendor/features/profile/edit_profile/services/edit_profile_services.dart';
import 'package:quikle_vendor/core/utils/logging/logger.dart';

class MyProfileController extends GetxController {
  // Observables for edit mode
  final isBasicInfoEditing = false.obs;
  final isContactInfoEditing = false.obs;
  final isBusinessDetailsEditing = false.obs;

  // Profile image
  final profileImagePath = Rx<String?>(null);

  // Update profile loading state
  final isUpdatingProfile = false.obs;

  // Observable display values
  final shopName = "Tandoori Tarang".obs;
  final address = "House 34, Road 12, Dhanmondi, Dhaka".obs;
  final ownerNameDisplay = "".obs;
  final openingHoursDisplay = "9:00 AM - 8:00 PM".obs;
  final vendorTypeDisplay = "".obs;
  final accountStatusDisplay = "Active".obs;
  final phoneNumberDisplay = "".obs;
  final nidNumberDisplay = "".obs;

  // Vendor Details Observable
  late VendorDetailsModel vendorDetails;

  // Text Controllers - Basic Info
  late TextEditingController shopNameController;
  final ownerNameController = TextEditingController(text: "Vikash Rajput");
  late TextEditingController accountStatusController;
  final servicesController = TextEditingController(
    text: "Describe services offered",
  );

  // Text Controllers - Contact Info
  final contactPersonController = TextEditingController(text: "Vikram Rajput");
  late TextEditingController phoneController;
  late TextEditingController addressController;
  final openingHoursController = TextEditingController(
    text: "9:00 AM - 8:00 PM",
  );
  final openingTimeController = TextEditingController(text: "9:00 AM");
  final closingTimeController = TextEditingController(text: "8:00 PM");

  // Text Controllers - Business Details
  final panelLicenseController = TextEditingController(text: "Not Provided");
  late TextEditingController tinNumberController;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _loadVendorDetails();
  }

  @override
  void onReady() {
    super.onReady();
    _loadVendorDetails();
  }

  /// Refresh vendor details (public method)
  void refreshVendorDetails() {
    // Reset profile image path to force reload
    profileImagePath.value = null;
    _loadVendorDetails();
  }

  /// Load vendor details from StorageService (public for refresh)
  void _loadVendorDetails() {
    try {
      final vendorData = StorageService.getVendorDetails();
      final details = vendorData != null
          ? VendorDetailsModel.fromJson(vendorData)
          : null;

      if (details != null) {
        vendorDetails = details;

        // Initialize controllers with vendor data
        shopNameController = TextEditingController(
          text: vendorDetails.shopName,
        );
        phoneController = TextEditingController(text: vendorDetails.phone);
        addressController = TextEditingController(
          text: vendorDetails.locationName ?? address.value,
        );
        accountStatusController = TextEditingController(
          text: vendorDetails.isActive ? "Active" : "Inactive",
        );
        tinNumberController = TextEditingController(text: vendorDetails.nid);

        // Set owner name from storage service
        if (vendorDetails.ownerName != null &&
            vendorDetails.ownerName!.isNotEmpty) {
          ownerNameController.text = vendorDetails.ownerName!;
        }

        // Set opening hours from storage service
        final openingHours = _formatOpeningHours(
          vendorDetails.openTime,
          vendorDetails.closeTime,
        );
        if (openingHours.isNotEmpty) {
          openingHoursController.text = openingHours;
        }

        // Set individual opening and closing times
        if (vendorDetails.openTime != null &&
            vendorDetails.openTime!.isNotEmpty) {
          openingTimeController.text = vendorDetails.openTime!;
        }
        if (vendorDetails.closeTime != null &&
            vendorDetails.closeTime!.isNotEmpty) {
          closingTimeController.text = vendorDetails.closeTime!;
        }

        // Update observables for UI display
        shopName.value = vendorDetails.shopName;
        address.value = vendorDetails.locationName ?? address.value;
        ownerNameDisplay.value = vendorDetails.ownerName ?? "";
        openingHoursDisplay.value = _formatOpeningHours(
          vendorDetails.openTime,
          vendorDetails.closeTime,
        );
        vendorTypeDisplay.value = vendorDetails.type.toString();
        accountStatusDisplay.value = vendorDetails.isActive
            ? "Active"
            : "Inactive";
        phoneNumberDisplay.value = vendorDetails.phone;
        nidNumberDisplay.value = vendorDetails.nid;

        // Load profile image path from storage if available
        final imagePath = vendorData?['profile_image_path'] as String?;
        AppLoggerHelper.debug('Checking image path from storage: $imagePath');
        if (imagePath != null && imagePath.isNotEmpty) {
          final imageFile = File(imagePath);
          final fileExists = imageFile.existsSync();
          AppLoggerHelper.debug('Image file exists: $fileExists at $imagePath');
          if (fileExists) {
            profileImagePath.value = imagePath;
            AppLoggerHelper.info('Profile image loaded: $imagePath');
          } else {
            AppLoggerHelper.warning('Image file not found at: $imagePath');
          }
        } else {
          AppLoggerHelper.debug('No image path in storage');
        }
      } else {
        // Use default values if no vendor details
        shopNameController = TextEditingController(text: "Tandoori Tarang");
        phoneController = TextEditingController(text: "+963-172-345678");
        addressController = TextEditingController(
          text: "House 34, Road 12, Dhanmondi, Dhaka",
        );
        accountStatusController = TextEditingController(text: "Active");
        tinNumberController = TextEditingController(text: "+963-172-345678");
      }
    } catch (e) {
      // Fallback to default values
      shopNameController = TextEditingController(text: "Tandoori Tarang");
      phoneController = TextEditingController(text: "+963-172-345678");
      addressController = TextEditingController(
        text: "House 34, Road 12, Dhanmondi, Dhaka",
      );
      accountStatusController = TextEditingController(text: "Active");
      tinNumberController = TextEditingController(text: "+963-172-345678");
    }
  }

  /// Format opening and closing times into a readable string
  String _formatOpeningHours(String? openTime, String? closeTime) {
    if (openTime == null || closeTime == null) {
      return "9:00 AM - 8:00 PM"; // Default fallback
    }
    return "$openTime - $closeTime";
  }

  void toggleBasicInfoEdit() {
    isBasicInfoEditing.value = !isBasicInfoEditing.value;
  }

  void toggleContactInfoEdit() {
    isContactInfoEditing.value = !isContactInfoEditing.value;
  }

  void toggleBusinessDetailsEdit() {
    isBusinessDetailsEditing.value = !isBusinessDetailsEditing.value;
  }

  void saveBasicInfo() {
    // TODO: Implement save logic
    shopName.value = shopNameController.text;
    isBasicInfoEditing.value = false;
  }

  void saveContactInfo() {
    // TODO: Implement save logic
    address.value = addressController.text;
    isContactInfoEditing.value = false;
  }

  void saveBusinessDetails() {
    // TODO: Implement save logic
    isBusinessDetailsEditing.value = false;
  }

  Future<void> pickImage([ImageSource source = ImageSource.gallery]) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (image != null) {
        profileImagePath.value = image.path;
        AppLoggerHelper.info('✅ Profile image selected: ${image.path}');
        // TODO: Upload image to server
      }
    } catch (e) {}
  }

  Future<void> pickOpeningTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final formattedTime = pickedTime.format(context);
      openingTimeController.text = formattedTime;
      _updateOpeningHours();
    }
  }

  Future<void> pickClosingTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final formattedTime = pickedTime.format(context);
      closingTimeController.text = formattedTime;
      _updateOpeningHours();
    }
  }

  void _updateOpeningHours() {
    if (openingTimeController.text.isNotEmpty &&
        closingTimeController.text.isNotEmpty) {
      openingHoursController.text =
          "${openingTimeController.text} - ${closingTimeController.text}";
    }
  }

  /// Convert 12-hour format time to 24-hour format (HH:mm)
  String _convertTo24HourFormat(String time12h) {
    try {
      // Parse the 12-hour format time (e.g., "12:23 PM" or "9:15 AM")
      final parts = time12h.trim().split(' ');
      if (parts.length != 2) return time12h;

      final timePart = parts[0]; // "12:23"
      final period = parts[1].toUpperCase(); // "PM" or "AM"

      final timeParts = timePart.split(':');
      if (timeParts.length != 2) return time12h;

      var hour = int.parse(timeParts[0]);
      final minute = timeParts[1];

      // Convert to 24-hour format
      if (period == 'PM' && hour != 12) {
        hour += 12;
      } else if (period == 'AM' && hour == 12) {
        hour = 0;
      }

      // Return in HH:mm format
      return '${hour.toString().padLeft(2, '0')}:$minute';
    } catch (e) {
      AppLoggerHelper.error('Error converting time format: $e');
      return time12h;
    }
  }

  /// Update vendor profile via PUT API
  Future<void> updateProfile() async {
    AppLoggerHelper.debug('🔄 Starting profile update...');

    // Validation
    if (ownerNameController.text.isEmpty) {
      AppLoggerHelper.info('⚠️ Owner name is required');
      return;
    }
    if (openingTimeController.text.isEmpty ||
        closingTimeController.text.isEmpty) {
      AppLoggerHelper.info('⚠️ Opening and closing times are required');
      return;
    }

    try {
      isUpdatingProfile.value = true;

      // Convert times to 24-hour format
      final openTime24 = _convertTo24HourFormat(openingTimeController.text);
      final closeTime24 = _convertTo24HourFormat(closingTimeController.text);

      AppLoggerHelper.debug(
        'Time conversion: ${openingTimeController.text} → $openTime24',
      );
      AppLoggerHelper.debug(
        'Time conversion: ${closingTimeController.text} → $closeTime24',
      );

      final service = EditProfileServices();
      final response = await service.updateVendorProfile(
        ownerName: ownerNameController.text,
        openTime: openTime24,
        closeTime: closeTime24,
        profileImage: profileImagePath.value != null
            ? File(profileImagePath.value!)
            : null,
      );

      if (response.isSuccess) {
        AppLoggerHelper.info('✅ Profile updated successfully');

        // Update local storage with new data
        final vendorData = StorageService.getVendorDetails();
        if (vendorData != null) {
          vendorData['owner_name'] = ownerNameController.text;
          vendorData['open_time'] = openingTimeController.text;
          vendorData['close_time'] = closingTimeController.text;
          await StorageService.saveVendorDetails(vendorData);
        }

        // Reload vendor details
        _loadVendorDetails();

        Get.back();
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        AppLoggerHelper.error(
          '❌ Profile update failed: ${response.errorMessage}',
        );
        Get.snackbar(
          'Error',
          response.errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      AppLoggerHelper.error('❌ Error during profile update: $e');
      Get.snackbar(
        'Error',
        'An error occurred while updating profile',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpdatingProfile.value = false;
    }
  }

  @override
  void onClose() {
    shopNameController.dispose();
    ownerNameController.dispose();
    accountStatusController.dispose();
    servicesController.dispose();
    contactPersonController.dispose();
    phoneController.dispose();
    addressController.dispose();
    openingHoursController.dispose();
    openingTimeController.dispose();
    closingTimeController.dispose();
    panelLicenseController.dispose();
    tinNumberController.dispose();
    super.onClose();
  }
}
