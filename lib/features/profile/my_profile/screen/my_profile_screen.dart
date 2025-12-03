import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/common/widgets/custom_button.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import 'package:quikle_vendor/features/profile/my_profile/widget/contactInfoCard.dart';
import 'package:quikle_vendor/routes/app_routes.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../appbar/screen/appbar_screen.dart';
import '../controller/my_profile_controller.dart';

class MyProfileScreen extends StatelessWidget {
  final bool fromKycFlow;

  const MyProfileScreen({super.key, this.fromKycFlow = false});

  @override
  Widget build(BuildContext context) {
    log("fromKycFlow: $fromKycFlow");
    return GetBuilder<MyProfileController>(
      init: MyProfileController(),
      builder: (controller) => Scaffold(
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
                      () => CircleAvatar(
                        radius: 45,
                        backgroundImage: controller.selectedImage.value != null
                            ? FileImage(controller.selectedImage.value!)
                            : const AssetImage("assets/images/profile.png")
                                  as ImageProvider,
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
                        style: getTextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              /// Profile Info Card
              // const BasicInfoCard(),
              const SizedBox(height: 20),

              /// Contact Info
              const ContactInfoCard(),
              const SizedBox(height: 20),

              /// Opening Hours Display
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
                      "Opening Hours",
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Text(
                    //   (vendorData != null && vendorData['opening_hours'] != null)
                    //       ? vendorData['opening_hours'] as String
                    //       : 'Not set',
                    //   style: getTextStyle(fontSize: 14, color: Colors.black87),
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              if (fromKycFlow) ...[
                const SizedBox(height: 20),
                CustomButton(
                  text: "Update",
                  onPressed: () {
                    Get.offAllNamed(AppRoute.navbarScreen);
                  },
                  height: 48,
                  width: double.infinity,
                  borderRadius: 10,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 15,
                ),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
