import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import 'package:quikle_vendor/core/utils/widgets/network_image_with_fallback.dart';
import 'package:quikle_vendor/features/vendor/models/vendor_model.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/custom_textfield.dart';
import '../../../appbar/screen/appbar_screen.dart';
import '../controller/edit_profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  final bool fromKycFlow;
  const EditProfileScreen({super.key, this.fromKycFlow = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());
    final vendorData = StorageService.getVendorDetails();
    final vendorDetails = vendorData != null
        ? VendorDetailsModel.fromJson(vendorData)
        : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppbarScreen(title: "Edit Profile"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Profile Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Obx(
                    () => Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(45),
                          child: SizedBox(
                            width: 90,
                            height: 90,
                            child: _buildProfileImage(controller),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () =>
                                _showImagePickerOptions(context, controller),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    vendorDetails?.shopName ?? '',
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      vendorDetails?.locationName ?? '',
                      textAlign: TextAlign.center,
                      style: getTextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            /// Form Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Edit Profile",
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Owner Name
                  CustomTextField(
                    label: "Owner Name",
                    hintText: "Enter owner name",
                    controller: controller.ownerNameController,
                  ),
                  const SizedBox(height: 12),

                  // /// Owner Name
                  // CustomTextField(
                  //   label: "NID Number",
                  //   hintText: "Enter NID number",
                  //   // controller: nidNumberController,
                  // ),
                  // const SizedBox(height: 12),
                  // CustomTextField(
                  //   label: "Phone Number",
                  //   hintText: "Enter Phone number",
                  //   // controller: nidNumberController,
                  // ),
                  // const SizedBox(height: 12),

                  /// Opening & Closing Time (combined display)
                  AbsorbPointer(
                    child: CustomTextField(
                      label: "Opening & Closing Time",
                      hintText: "Select opening & closing time",
                      controller: controller.openingHoursController,
                      // suffixIcon: const Icon(
                      //   Icons.access_time,
                      //   color: Colors.grey,
                      // ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Time Picker Actions
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: "Set Opening",
                          fontSize: 14,
                          height: 44,
                          borderRadius: 8,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          onPressed: () => controller.pickOpeningTime(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomButton(
                          text: "Set Closing",
                          fontSize: 14,
                          height: 44,
                          borderRadius: 8,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          onPressed: () => controller.pickClosingTime(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  /// Save Button
                  Obx(
                    () => CustomButton(
                      text: controller.isUpdatingProfile.value
                          ? "Saving..."
                          : "Save Changes",
                      fontSize: 16,
                      onPressed: controller.isUpdatingProfile.value
                          ? () {}
                          : () => controller.updateProfile(fromKycFlow),
                      backgroundColor: controller.isUpdatingProfile.value
                          ? Colors.grey
                          : Colors.black,
                      textColor: Colors.white,
                      height: 50,
                      borderRadius: 8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show image picker options (Camera or Gallery)
  static void _showImagePickerOptions(
    BuildContext context,
    EditProfileController controller,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Pick Profile Image',
              style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                controller.pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                controller.pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Build profile image widget with fallback
  Widget _buildProfileImage(EditProfileController controller) {
    // Priority 1: Local file image (recently picked)
    if (controller.profileImagePath.value != null) {
      return Image.file(
        File(controller.profileImagePath.value!),
        fit: BoxFit.cover,
      );
    }

    // Priority 2: Photo URL from SharedPreferences (API response)
    final vendorData = StorageService.getVendorDetails();
    if (vendorData != null && vendorData['photo'] != null) {
      final photoUrl = vendorData['photo'] as String;
      if (photoUrl.isNotEmpty) {
        return NetworkImageWithFallback(
          photoUrl,
          fallback: "assets/images/profile.png",
          fit: BoxFit.cover,
        );
      }
    }

    // Priority 3: Default asset image
    return Image.asset("assets/images/profile.png", fit: BoxFit.cover);
  }
}
