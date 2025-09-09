import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/custom_textfield.dart';
import '../../../appbar/screen/appbar_screen.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: "Vikram Rajput");
    final emailController = TextEditingController(
      text: "vikramrajput@gmail.com",
    );
    final phoneController = TextEditingController(text: "+1 (555) 123-4567");
    final nidController = TextEditingController(text: "1234567981011");

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
                  const CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage("assets/images/profile.png"),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    nameController.text,
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    emailController.text,
                    style: getTextStyle(fontSize: 14, color: Colors.black54),
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

                  /// Name
                  CustomTextField(
                    label: "Name",
                    hintText: "Enter your full name",
                    hintTextStyle: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade500,
                    ),
                    textStyle: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    controller: nameController,
                  ),
                  const SizedBox(height: 12),

                  /// Email
                  CustomTextField(
                    label: "Email Address",
                    hintText: "Enter your email address",
                    hintTextStyle: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade500,
                    ),
                    textStyle: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    controller: emailController,
                  ),
                  const SizedBox(height: 12),

                  /// Phone
                  CustomTextField(
                    label: "Phone Number",
                    hintText: "Enter your phone number",
                    hintTextStyle: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade500,
                    ),
                    textStyle: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    controller: phoneController,
                  ),
                  const SizedBox(height: 12),

                  /// NID
                  CustomTextField(
                    label: "National Identity Number",
                    hintText: "Enter your NID number",
                    hintTextStyle: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade500,
                    ),
                    textStyle: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    controller: nidController,
                  ),
                  const SizedBox(height: 20),

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
