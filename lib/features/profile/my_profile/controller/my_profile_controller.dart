import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quikle_vendor/core/utils/helpers/snackbar_helper.dart';
import 'package:quikle_vendor/features/user/controllers/user_controller.dart';
import '../model/my_profile_model.dart';

class MyProfileController extends GetxController {
  // Profile Model
  final profileModel = Rx<MyProfileModel?>(null);

  // Observables for edit mode
  final isBasicInfoEditing = false.obs;
  final isContactInfoEditing = false.obs;
  final isBusinessDetailsEditing = false.obs;

  // Profile image
  final profileImagePath = Rx<String?>(null);
  final selectedImage = Rx<File?>(null);

  // Observable display values
  final businessName = "Tandoori Tarang".obs;
  final address = "House 34, Road 12, Dhanmondi, Dhaka".obs;

  // Text Controllers - Basic Info
  late TextEditingController businessNameController;
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

  // Text Controllers - Business Details
  final panelLicenseController = TextEditingController(text: "Not Provided");
  late TextEditingController tinNumberController;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _loadVendorDetails();
  }

  /// Load vendor details from UserController
  void _loadVendorDetails() {
    try {
      final userController = Get.find<UserController>();
      final details = userController.getVendorDetails();

      if (details != null) {
        // Create model from vendor details
        profileModel.value = MyProfileModel.fromVendorDetails(details.toJson());
        final model = profileModel.value!;

        // Initialize controllers with model data
        businessNameController = TextEditingController(text: model.shopName);
        phoneController = TextEditingController(text: model.phone);
        addressController = TextEditingController(text: model.address);
        accountStatusController = TextEditingController(
          text: model.accountStatus,
        );
        tinNumberController = TextEditingController(text: model.tinNumber);
        ownerNameController.text = model.ownerName;
        servicesController.text = model.servicesOffered;
        contactPersonController.text = model.contactPerson;
        openingHoursController.text = model.openingHours;
        panelLicenseController.text = model.panelLicense;

        // Update observables
        businessName.value = model.shopName;
        address.value = model.address;

        // Load image if exists
        if (model.photo != null && model.photo!.isNotEmpty) {
          profileImagePath.value = model.photo;
          final file = File(model.photo!);
          if (file.existsSync()) {
            selectedImage.value = file;
          }
        }
      } else {
        _setDefaultValues();
      }
    } catch (e) {
      print('Error loading vendor details: $e');
      _setDefaultValues();
    }
  }

  void _setDefaultValues() {
    profileModel.value = MyProfileModel(
      shopName: 'Tandoori Tarang',
      ownerName: 'Vikash Rajput',
      email: '',
      phone: '+963-172-345678',
      address: 'House 34, Road 12, Dhanmondi, Dhaka',
      accountStatus: 'Active',
      servicesOffered: 'Describe services offered',
      contactPerson: 'Vikram Rajput',
      openingHours: '9:00 AM - 8:00 PM',
      panelLicense: 'Not Provided',
      tinNumber: '+963-172-345678',
      isActive: true,
    );

    final model = profileModel.value!;
    businessNameController = TextEditingController(text: model.shopName);
    phoneController = TextEditingController(text: model.phone);
    addressController = TextEditingController(text: model.address);
    accountStatusController = TextEditingController(text: model.accountStatus);
    tinNumberController = TextEditingController(text: model.tinNumber);
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
    try {
      if (profileModel.value != null) {
        // Update model
        profileModel.value = profileModel.value!.copyWith(
          shopName: businessNameController.text,
          ownerName: ownerNameController.text,
        );

        // Update UserController
        final userController = Get.find<UserController>();
        final currentVendor = userController.getVendorDetails();
        if (currentVendor != null) {
          final updatedJson = {
            ...currentVendor.toJson(),
            'shop_name': businessNameController.text.trim(),
            'owner_name': ownerNameController.text.trim(),
          };
          userController.setVendorDetails(updatedJson);
        }

        businessName.value = businessNameController.text;
        isBasicInfoEditing.value = false;
        SnackBarHelper.success('Basic information saved successfully');
      }
    } catch (e) {
      print('Error saving basic info: $e');
      SnackBarHelper.error('Failed to save basic information');
    }
  }

  void saveContactInfo() {
    try {
      if (profileModel.value != null) {
        // Update model
        profileModel.value = profileModel.value!.copyWith(
          phone: phoneController.text,
          address: addressController.text,
          contactPerson: contactPersonController.text,
          openingHours: openingHoursController.text,
        );

        // Update UserController
        final userController = Get.find<UserController>();
        final currentVendor = userController.getVendorDetails();
        if (currentVendor != null) {
          final updatedJson = {
            ...currentVendor.toJson(),
            'phone': phoneController.text.trim(),
            'location_name': addressController.text.trim(),
          };
          userController.setVendorDetails(updatedJson);
        }

        address.value = addressController.text;
        isContactInfoEditing.value = false;
        SnackBarHelper.success('Contact information saved successfully');
      }
    } catch (e) {
      print('Error saving contact info: $e');
      SnackBarHelper.error('Failed to save contact information');
    }
  }

  void saveBusinessDetails() {
    try {
      if (profileModel.value != null) {
        // Update model
        profileModel.value = profileModel.value!.copyWith(
          tinNumber: tinNumberController.text,
          panelLicense: panelLicenseController.text,
        );

        // Update UserController
        final userController = Get.find<UserController>();
        final currentVendor = userController.getVendorDetails();
        if (currentVendor != null) {
          final updatedJson = {
            ...currentVendor.toJson(),
            'nid': tinNumberController.text.trim(),
          };
          userController.setVendorDetails(updatedJson);
        }

        isBusinessDetailsEditing.value = false;
        SnackBarHelper.success('Business details saved successfully');
      }
    } catch (e) {
      print('Error saving business details: $e');
      SnackBarHelper.error('Failed to save business details');
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
        profileImagePath.value = picked.path;

        // Update model
        if (profileModel.value != null) {
          profileModel.value = profileModel.value!.copyWith(photo: picked.path);
        }

        SnackBarHelper.success('Profile image updated');
      }
    } catch (e) {
      SnackBarHelper.error('Failed to pick image');
    }
  }

  void refreshProfile() {
    _loadVendorDetails();
  }

  @override
  void onClose() {
    businessNameController.dispose();
    ownerNameController.dispose();
    accountStatusController.dispose();
    servicesController.dispose();
    contactPersonController.dispose();
    phoneController.dispose();
    addressController.dispose();
    openingHoursController.dispose();
    panelLicenseController.dispose();
    tinNumberController.dispose();
    super.onClose();
  }
}
