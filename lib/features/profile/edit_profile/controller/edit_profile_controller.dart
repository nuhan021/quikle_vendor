import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import 'package:quikle_vendor/features/auth/data/services/auth_service.dart';
import 'package:quikle_vendor/features/vendor/models/vendor_model.dart';
import 'package:quikle_vendor/features/profile/edit_profile/services/edit_profile_services.dart';
import 'package:quikle_vendor/features/profile/my_profile/controller/my_profile_controller.dart';
import 'package:quikle_vendor/core/utils/logging/logger.dart';
import 'package:quikle_vendor/routes/app_routes.dart';
import 'package:quikle_vendor/features/home/controller/home_controller.dart';

class EditProfileController extends GetxController {
  // Profile image
  final profileImagePath = Rx<String?>(null);

  // Update profile loading state
  final isUpdatingProfile = false.obs;

  // Vendor Details Observable
  late VendorDetailsModel vendorDetails;

  // Text Controllers
  late TextEditingController ownerNameController;
  late TextEditingController openingHoursController;
  late TextEditingController openingTimeController;
  late TextEditingController closingTimeController;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _loadVendorDetails();
  }

  /// Load vendor details from StorageService
  void _loadVendorDetails() {
    try {
      final vendorData = StorageService.getVendorDetails();
      final details = vendorData != null
          ? VendorDetailsModel.fromJson(vendorData)
          : null;

      if (details != null) {
        vendorDetails = details;

        // Initialize controllers with vendor data
        ownerNameController = TextEditingController(
          text: vendorDetails.ownerName ?? "Vikash Rajput",
        );

        openingHoursController = TextEditingController(
          text: _formatOpeningHours(
            vendorDetails.openTime,
            vendorDetails.closeTime,
          ),
        );

        openingTimeController = TextEditingController(
          text: vendorDetails.openTime ?? "9:00 AM",
        );

        closingTimeController = TextEditingController(
          text: vendorDetails.closeTime ?? "8:00 PM",
        );
      } else {
        // Use default values if no vendor details
        ownerNameController = TextEditingController(text: "Vikash Rajput");
        openingHoursController = TextEditingController(
          text: "9:00 AM - 8:00 PM",
        );
        openingTimeController = TextEditingController(text: "9:00 AM");
        closingTimeController = TextEditingController(text: "8:00 PM");
      }
    } catch (e) {
      // Fallback to default values
      ownerNameController = TextEditingController(text: "Vikash Rajput");
      openingHoursController = TextEditingController(text: "9:00 AM - 8:00 PM");
      openingTimeController = TextEditingController(text: "9:00 AM");
      closingTimeController = TextEditingController(text: "8:00 PM");
    }
  }

  /// Format opening and closing times into a readable string
  String _formatOpeningHours(String? openTime, String? closeTime) {
    if (openTime == null || closeTime == null) {
      return "9:00 AM - 8:00 PM"; // Default fallback
    }
    return "$openTime - $closeTime";
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
        // Copy image to app documents directory for persistence
        final savedPath = await _saveImageToAppDocuments(image);
        profileImagePath.value = savedPath;
        AppLoggerHelper.info('✅ Profile image selected and saved: $savedPath');
      }
    } catch (e) {
      AppLoggerHelper.error('Error picking image: $e');
    }
  }

  /// Save image to app documents directory for persistence
  Future<String?> _saveImageToAppDocuments(XFile image) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      AppLoggerHelper.debug('App docs dir: ${appDocDir.path}');
      final profileImageDir = Directory('${appDocDir.path}/profile_images');

      // Create directory if it doesn't exist
      if (!await profileImageDir.exists()) {
        await profileImageDir.create(recursive: true);
        AppLoggerHelper.debug('Created profile_images directory');
      }

      // Create a unique filename
      final fileName =
          'profile_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImagePath = '${profileImageDir.path}/$fileName';

      // Copy the file to app documents
      final imageFile = File(image.path);
      AppLoggerHelper.debug('Copying from: ${image.path}');
      AppLoggerHelper.debug('Copying to: $savedImagePath');
      final savedFile = await imageFile.copy(savedImagePath);

      final exists = await savedFile.exists();
      AppLoggerHelper.info(
        'Image saved to: ${savedFile.path} (exists: $exists)',
      );
      return savedFile.path;
    } catch (e) {
      AppLoggerHelper.error('Error saving image to documents: $e');
      return null;
    }
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
  Future<void> updateProfile(bool fromKycFlow) async {
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

        // Update local storage with new data (using 24-hour format)
        final vendorData = StorageService.getVendorDetails();
        if (vendorData != null) {
          vendorData['owner_name'] = ownerNameController.text;
          vendorData['open_time'] = openTime24;
          vendorData['close_time'] = closeTime24;

          // Extract photo URL from API response if available
          if (response.responseData is Map) {
            final apiResponse = response.responseData as Map;
            if (apiResponse['vendor_profile'] != null) {
              final vendorProfile = apiResponse['vendor_profile'] as Map;
              if (vendorProfile['photo'] != null) {
                AppLoggerHelper.debug(
                  'Saving photo URL from API: ${vendorProfile['photo']}',
                );
                vendorData['photo'] = vendorProfile['photo'];
              }
            }
          }

          // Save profile image path if one was selected
          if (profileImagePath.value != null) {
            AppLoggerHelper.debug(
              'Saving image path to storage: ${profileImagePath.value}',
            );
            vendorData['profile_image_path'] = profileImagePath.value;
          } else {
            AppLoggerHelper.debug('No image path to save');
          }
          await StorageService.saveVendorDetails(vendorData);
          AppLoggerHelper.debug('Vendor data saved to storage');

          // Trigger home controller to reload vendor data
          try {
            final homeController = Get.find<HomeController>();
            homeController.loadVendorData();
          } catch (e) {
            AppLoggerHelper.debug('HomeController not found, skipping refresh');
          }
        }

        // Reload vendor details
        _loadVendorDetails();

        // Also refresh MyProfileController if it exists
        try {
          final myProfileController = Get.find<MyProfileController>();
          myProfileController.refreshVendorDetails();
          // Also sync the profile image path if one was selected
          if (profileImagePath.value != null) {
            myProfileController.profileImagePath.value = profileImagePath.value;
          }
        } catch (e) {
          AppLoggerHelper.debug(
            'MyProfileController not found, will refresh on screen navigation',
          );
        }

        if (fromKycFlow) {
          final auth = Get.find<AuthService>();
          final vendorDetailsResponse = await auth.getVendorDetails();

          final vendorData =
              vendorDetailsResponse.responseData as Map<String, dynamic>;

          await StorageService.saveVendorDetails(vendorData['vendor_profile']);
          AppLoggerHelper.debug('Vendor details after update : $vendorData');
          Get.offAllNamed(AppRoute.navbarScreen);
        } else {
          Get.back();
        }
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
    ownerNameController.dispose();
    openingHoursController.dispose();
    openingTimeController.dispose();
    closingTimeController.dispose();
    super.onClose();
  }
}
