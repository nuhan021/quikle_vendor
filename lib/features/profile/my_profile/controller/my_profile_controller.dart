import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MyProfileController extends GetxController {
  // Observables for edit mode
  final isBasicInfoEditing = false.obs;
  final isContactInfoEditing = false.obs;
  final isBusinessDetailsEditing = false.obs;

  // Profile image
  final profileImagePath = Rx<String?>(null);

  // Observable display values
  final businessName = "Tandoori Tarang".obs;
  final address = "House 34, Road 12, Dhanmondi, Dhaka".obs;

  // Text Controllers - Basic Info
  final businessNameController = TextEditingController(text: "Tandoori Tarang");
  final ownerNameController = TextEditingController(text: "Vikash Rajput");
  final accountStatusController = TextEditingController(text: "Active");
  final servicesController = TextEditingController(
    text: "Describe services offered",
  );

  // Text Controllers - Contact Info
  final contactPersonController = TextEditingController(text: "Vikram Rajput");
  final phoneController = TextEditingController(text: "+963-172-345678");
  final addressController = TextEditingController(
    text: "House 34, Road 12, Dhanmondi, Dhaka",
  );
  final openingHoursController = TextEditingController(
    text: "9:00 AM - 8:00 PM",
  );

  // Text Controllers - Business Details
  final panelLicenseController = TextEditingController(text: "Not Provided");
  final tinNumberController = TextEditingController(text: "+963-172-345678");

  final ImagePicker _picker = ImagePicker();

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
    businessName.value = businessNameController.text;
    isBasicInfoEditing.value = false;
    Get.snackbar('Success', 'Basic information saved successfully');
  }

  void saveContactInfo() {
    // TODO: Implement save logic
    address.value = addressController.text;
    isContactInfoEditing.value = false;
    Get.snackbar('Success', 'Contact information saved successfully');
  }

  void saveBusinessDetails() {
    // TODO: Implement save logic
    isBusinessDetailsEditing.value = false;
    Get.snackbar('Success', 'Business details saved successfully');
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (image != null) {
        profileImagePath.value = image.path;
        // TODO: Upload image to server
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image');
    }
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
