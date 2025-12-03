import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quikle_vendor/core/utils/helpers/snackbar_helper.dart';
import 'package:quikle_vendor/features/user/controllers/user_controller.dart';
import '../model/edit_profile_model.dart';

class EditProfileController extends GetxController {
  // Profile Model
  final profileModel = Rx<EditProfileModel?>(null);

  // Text Controllers
  late final TextEditingController shopNameController;
  late final TextEditingController ownerNameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController addressController;
  late final TextEditingController openingHoursController;
  late final TextEditingController businessTypeController;
  late final TextEditingController descriptionController;

  // Image Picker
  final ImagePicker _picker = ImagePicker();
  final selectedImage = Rx<File?>(null);

  // Time Range
  final openingTime = Rx<TimeOfDay?>(null);
  final closingTime = Rx<TimeOfDay?>(null);

  // Loading state
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initControllers();
    _loadVendorDetails();
  }

  void _initControllers() {
    shopNameController = TextEditingController();
    ownerNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
    openingHoursController = TextEditingController(text: "9:00 AM - 8:00 PM");
    businessTypeController = TextEditingController();
    descriptionController = TextEditingController();
  }

  void _loadVendorDetails() {
    try {
      final userController = Get.find<UserController>();
      final vd = userController.getVendorDetails();
      if (vd != null) {
        // Load into model from VendorDetailsModel
        profileModel.value = EditProfileModel(
          shopName: vd.shopName,
          ownerName: vd.ownerName ?? '',
          email: vd.email,
          phone: vd.phone,
          address: vd.locationName ?? '',
          openingHours: _formatOpeningHours(vd.openTime, vd.closeTime),
          photoPath: vd.photo,
          businessType: vd.type,
          description: null, // Not in VendorDetailsModel
        );

        // Populate controllers from model
        final model = profileModel.value;
        if (model != null) {
          shopNameController.text = model.shopName ?? '';
          ownerNameController.text = model.ownerName ?? '';
          emailController.text = model.email ?? '';
          phoneController.text = model.phone ?? '';
          addressController.text = model.address ?? '';
          openingHoursController.text =
              model.openingHours ?? '9:00 AM - 8:00 PM';
          businessTypeController.text = model.businessType ?? '';
          descriptionController.text = model.description ?? '';

          // Load image
          if (model.photoPath != null && model.photoPath!.isNotEmpty) {
            final f = File(model.photoPath!);
            if (f.existsSync()) selectedImage.value = f;
          }
        }
      }
    } catch (e) {
      print('Error loading vendor details: $e');
    }
  }

  Future<void> pickImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (picked != null) {
        selectedImage.value = File(picked.path);
      }
    } catch (e) {
      SnackBarHelper.error('Failed to pick image');
    }
  }

  Future<void> pickOpeningTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: openingTime.value ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      openingTime.value = picked;
      _updateOpeningHoursText();
    }
  }

  Future<void> pickClosingTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: closingTime.value ?? const TimeOfDay(hour: 20, minute: 0),
    );
    if (picked != null) {
      closingTime.value = picked;
      _updateOpeningHoursText();
    }
  }

  void _updateOpeningHoursText() {
    final o = openingTime.value;
    final c = closingTime.value;
    if (o != null && c != null) {
      openingHoursController.text = _formatRange(o, c);
    }
  }

  String? _formatOpeningHours(String? openTime, String? closeTime) {
    if (openTime != null && closeTime != null) {
      return "$openTime - $closeTime";
    }
    return null;
  }

  String _formatRange(TimeOfDay open, TimeOfDay close) {
    String fmt(TimeOfDay t) {
      final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
      final m = t.minute.toString().padLeft(2, '0');
      final ap = t.period == DayPeriod.am ? 'AM' : 'PM';
      return "$h:$m $ap";
    }

    return "${fmt(open)} - ${fmt(close)}";
  }

  Future<void> saveChanges() async {
    try {
      isLoading.value = true;

      // Create updated model from form data
      final updatedModel = EditProfileModel(
        shopName: shopNameController.text.trim(),
        ownerName: ownerNameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        openingHours: openingHoursController.text.trim(),
        photoPath: selectedImage.value?.path,
        businessType: businessTypeController.text.trim(),
        description: descriptionController.text.trim(),
      );

      // Get UserController and update vendor details
      final userController = Get.find<UserController>();
      final currentVendor = userController.getVendorDetails();

      if (currentVendor != null) {
        // Update the vendor model with new values
        final updatedVendorJson = {
          ...currentVendor.toJson(),
          'shop_name': updatedModel.shopName,
          'owner_name': updatedModel.ownerName,
          'email': updatedModel.email,
          'phone': updatedModel.phone,
          'location_name': updatedModel.address,
          'type': updatedModel.businessType,
        };

        // Update controller
        userController.setVendorDetails(updatedVendorJson);
      }

      // Update local model
      profileModel.value = updatedModel;

      SnackBarHelper.success('Profile updated successfully');
      Get.back();
    } catch (e, stackTrace) {
      print('Error saving profile: $e');
      print('Stack trace: $stackTrace');
      SnackBarHelper.error('Failed to save profile');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    shopNameController.dispose();
    ownerNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    openingHoursController.dispose();
    businessTypeController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
