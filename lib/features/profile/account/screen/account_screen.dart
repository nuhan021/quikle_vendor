import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../../../routes/app_routes.dart';
import '../../../appbar/screen/appbar_screen.dart';
import '../widget/account_items.dart';
import '../widget/language_dialog.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppbarScreen(title: "Account"),
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
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage("assets/images/profile.png"),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Vikram Rajput",
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "vikramrajput@gmail.com",
                    style: getTextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            /// Account Items
            AccountItems(
              iconSize: 24,
              items: [
                {
                  "icon": SvgPicture.asset(IconPath.profile),
                  "text": "My Profile",
                  "onTap": () {
                    Get.toNamed(AppRoute.myProfileScreen);
                  },
                },
                {
                  "icon": SvgPicture.asset(IconPath.payment),
                  "text": "Payment Method",
                  "onTap": () {
                    Get.toNamed(AppRoute.paymentMethodScreen);
                  },
                },
                {
                  "icon": SvgPicture.asset(IconPath.notification),
                  "text": "Notification Settings",
                  "onTap": () {
                    Get.toNamed(AppRoute.notificationSettingsScreen);
                  },
                },
                {
                  "icon": SvgPicture.asset(IconPath.language),
                  "text": "Language Settings",
                  "onTap": () async {
                    String currentLanguage =
                        "English"; // you can keep this in a controller

                    final selected = await showDialog<String>(
                      context: context,
                      builder: (_) => LanguageDialog(
                        selectedLanguage: currentLanguage,
                        languages: ["English", "Bangla", "Hindi"],
                        onLanguageChanged: (value) {
                          currentLanguage = value;
                        },
                      ),
                    );

                    if (selected != null) {
                      // TODO: save selected language globally
                      print("Selected Language: $selected");
                    }
                  },
                },
                {
                  "icon": SvgPicture.asset(IconPath.support),
                  "text": "Help & Support",
                  "onTap": () {
                    Get.toNamed(AppRoute.helpAndSupportScreen);
                  },
                },
                {
                  "icon": SvgPicture.asset(IconPath.logout),
                  "text": "Sign out",
                  "textColor": Colors.red,
                  "onTap": () {
                    // TODO: sign out logic
                  },
                },
              ],
            ),
          ],
        ),
      ),
    );
  }
}
