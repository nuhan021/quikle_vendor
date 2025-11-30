import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quikle_vendor/core/utils/helpers/snackbar_helper.dart';
import 'package:quikle_vendor/features/user/controllers/user_controller.dart';
import 'package:quikle_vendor/features/vendor/models/vendor_model.dart';

class MyProfileController extends GetxController {
  // Observables for edit mode
  final isBasicInfoEditing = false.obs;
  final isContactInfoEditing = false.obs;
  final isBusinessDetailsEditing = false.obs;

  // Profile image
  final profileImagePath = Rx<String?>(null);

  // Vendor Details Observable
  late VendorDetailsModel vendorDetails;

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
        vendorDetails = details;

        // Initialize controllers with vendor data
        businessNameController = TextEditingController(
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

        // Update observables
        businessName.value = vendorDetails.shopName;
        address.value = vendorDetails.locationName ?? address.value;
      } else {
        // Use default values if no vendor details
        businessNameController = TextEditingController(text: "Tandoori Tarang");
        phoneController = TextEditingController(text: "+963-172-345678");
        addressController = TextEditingController(
          text: "House 34, Road 12, Dhanmondi, Dhaka",
        );
        accountStatusController = TextEditingController(text: "Active");
        tinNumberController = TextEditingController(text: "+963-172-345678");
      }
    } catch (e) {
      // Fallback to default values
      businessNameController = TextEditingController(text: "Tandoori Tarang");
      phoneController = TextEditingController(text: "+963-172-345678");
      addressController = TextEditingController(
        text: "House 34, Road 12, Dhanmondi, Dhaka",
      );
      accountStatusController = TextEditingController(text: "Active");
      tinNumberController = TextEditingController(text: "+963-172-345678");
    }
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
    businessName.value = businessNameController.text;
    isBasicInfoEditing.value = false;
    SnackBarHelper.success('Basic information saved successfully');
  }

  void saveContactInfo() {
    // TODO: Implement save logic
    address.value = addressController.text;
    isContactInfoEditing.value = false;
    SnackBarHelper.success('Contact information saved successfully');
  }

  void saveBusinessDetails() {
    // TODO: Implement save logic
    isBusinessDetailsEditing.value = false;
    SnackBarHelper.success('Business details saved successfully');
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
      SnackBarHelper.error('Failed to pick image');
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
