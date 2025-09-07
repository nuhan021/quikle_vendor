import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import 'package:quikle_vendor/routes/app_routes.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../appbar/screen/appbar_screen.dart';
import '../widget/profile_field.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppbarScreen(title: "My Profile"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Profile Header
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
                children: const [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage("assets/images/profile.png"),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Vikram Rajput",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "vikramrajput@gmail.com",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            /// Profile Info Card
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
                  /// Title + Edit
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "My Profile",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      CustomButton(
                        width: 50,
                        height: 26,
                        text: "Edit",
                        onPressed: () {
                          // TODO: edit profile action
                          Get.toNamed(AppRoute.editProfileScreen);
                        },
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 14,
                        borderRadius: 6,
                      ),
                    ],
                  ),
                  const Divider(height: 24, thickness: 0.8),

                  /// Profile Fields
                  const ProfileField(label: "Name", value: "Vikram Rajput"),
                  const ProfileField(
                    label: "Email Address",
                    value: "vikramrajput@gmail.com",
                  ),
                  const ProfileField(
                    label: "Phone Number",
                    value: "+1 (555) 123-4567",
                  ),
                  const ProfileField(
                    label: "National Identity Number",
                    value: "1234567981011",
                    showDivider: false,
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
