import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import 'package:quikle_vendor/features/vendor/models/vendor_model.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/custom_textfield.dart';
import '../../../appbar/screen/appbar_screen.dart';
import '../../my_profile/controller/my_profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MyProfileController>();
    final vendorData = StorageService.getVendorDetails();
    final vendorDetails = vendorData != null
        ? VendorDetailsModel.fromJson(vendorData)
        : null;
    final ownerNameController = TextEditingController(text: "Vikash Rajput");

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
                        CircleAvatar(
                          radius: 45,
                          backgroundImage:
                              controller.profileImagePath.value != null
                              ? FileImage(
                                  File(controller.profileImagePath.value!),
                                )
                              : const AssetImage("assets/images/profile.png")
                                    as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: controller.pickImage,
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
                    controller: ownerNameController,
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
                  CustomButton(
                    text: "Save Changes",
                    fontSize: 16,
                    onPressed: () {
                      // TODO: save profile logic
                      Get.back();
                    },
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    height: 50,
                    borderRadius: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
