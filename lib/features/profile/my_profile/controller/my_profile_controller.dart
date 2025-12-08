import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quikle_vendor/features/vendor/controllers/vendor_controller.dart';
import 'package:quikle_vendor/core/utils/helpers/snackbar_helper.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
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
  final shopName = "Tandoori Tarang".obs;
  final address = "House 34, Road 12, Dhanmondi, Dhaka".obs;

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

        // Update observables
        shopName.value = vendorDetails.shopName;
        address.value = vendorDetails.locationName ?? address.value;
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
