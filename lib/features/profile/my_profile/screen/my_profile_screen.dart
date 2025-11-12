import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import 'package:quikle_vendor/features/profile/my_profile/widget/basic_information_widget.dart';
import 'package:quikle_vendor/features/profile/my_profile/widget/business_details_widget.dart';
import 'package:quikle_vendor/features/profile/my_profile/widget/contactInfoCard.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../appbar/screen/appbar_screen.dart';
import '../controller/my_profile_controller.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyProfileController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppbarScreen(title: "My Profile"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Profile Header with editable image
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
                  Obx(
                    () => Text(
                      controller.businessName.value,
                      style: getTextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(
                    () => Text(
                      controller.address.value,
                      style: getTextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            /// Profile Info Card
            const BasicInfoCard(),
            const SizedBox(height: 20),

            /// Contact Info
            const ContactInfoCard(),
            const SizedBox(height: 20),

            // Business Details Card
            const BusinessDetailsCard(),
          ],
        ),
      ),
    );
  }
}
