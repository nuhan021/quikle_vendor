import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/custom_textfield.dart';
import '../../../appbar/screen/appbar_screen.dart';
import '../controller/edit_profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileController>(
      init: EditProfileController(),
      builder: (controller) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: const AppbarScreen(title: "Edit Profile"),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// Profile Image Card
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
                                controller.selectedImage.value != null
                                ? FileImage(controller.selectedImage.value!)
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

                    // Shop name and address fields under the avatar (minimal UI change)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomTextField(
                        label: "Shop Name",
                        hintText: "Enter shop name",
                        controller: controller.shopNameController,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomTextField(
                        label: "Shop Address",
                        hintText: "Enter shop address",
                        controller: controller.addressController,
                        // maxLines: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
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

                    CustomTextField(
                      label: "Owner Name",
                      hintText: "Enter owner name",
                      controller: controller.ownerNameController,
                    ),
                    const SizedBox(height: 12),

                    Text(
                      "Opening Hours",
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      label: "Time Range",
                      hintText: "Select opening and closing time",
                      controller: controller.openingHoursController,
                      readOnly: true,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: "Opening Time",
                            onPressed: () =>
                                controller.pickOpeningTime(context),
                            height: 44,
                            borderRadius: 10,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomButton(
                            text: "Closing Time",
                            onPressed: () =>
                                controller.pickClosingTime(context),
                            height: 44,
                            borderRadius: 10,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Obx(
                      () => CustomButton(
                        text: controller.isLoading.value
                            ? "Saving..."
                            : "Save Changes",
                        fontSize: 16,
                        onPressed: () {
                          // controller.saveChanges();
                          Get.back();
                        },
                        backgroundColor: Colors.black,
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
      ),
    );
  }
}
