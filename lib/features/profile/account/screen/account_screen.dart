import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import 'package:quikle_vendor/core/utils/constants/image_path.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../../../routes/app_routes.dart';
import '../../../appbar/screen/appbar_screen.dart';
import '../../../home/controller/home_controller.dart';
import '../controller/account_controller.dart';
import '../widget/account_items.dart';
import '../widget/language_dialog.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late final AccountController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(AccountController());
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppbarScreen(title: "Account"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: 80,
        ),
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
                    () => CircleAvatar(
                      radius: 45,
                      backgroundImage: _getProfileImage(homeController),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    _controller.vendorDetails.value?.shopName ?? '',
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      _controller.vendorDetails.value?.locationName ?? '',
                      style: getTextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                  // Text(
                  //   "vikramrajput@gmail.com",
                  //   style: getTextStyle(fontSize: 14, color: Colors.black54),
                  // ),
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
                    _controller.signOut();
                  },
                },
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Get profile image from SharedPreferences photo URL or default asset
  ImageProvider _getProfileImage(HomeController controller) {
    // Priority 1: Photo URL from reactive HomeController
    if (controller.vendorPhotoUrl.value != null &&
        controller.vendorPhotoUrl.value!.isNotEmpty) {
      return NetworkImage(controller.vendorPhotoUrl.value!);
    }

    // Priority 2: Default asset image
    return AssetImage(ImagePath.shopImage);
  }
}
