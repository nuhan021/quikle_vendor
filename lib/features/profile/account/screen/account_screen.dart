import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import 'package:quikle_vendor/core/utils/constants/image_path.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../../../core/utils/widgets/network_image_with_fallback.dart';
import '../../../../routes/app_routes.dart';
import '../../../appbar/screen/appbar_screen.dart';
import '../../../home/controller/home_controller.dart';
import '../../my_profile/controller/my_profile_controller.dart';
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
                  GetX<MyProfileController>(
                    init: MyProfileController(),
                    builder: (profileController) {
                      final homeController = Get.find<HomeController>();

                      return CircularPercentIndicator(
                        radius: 55.0,
                        lineWidth: 5.0,
                        animation: true,
                        animationDuration: 1000,
                        percent:
                            profileController
                                .profileCompletionPercentage
                                .value /
                            100,
                        center: ClipRRect(
                          borderRadius: BorderRadius.circular(45),
                          child: SizedBox(
                            width: 90,
                            height: 90,
                            child: _buildProfileImage(homeController),
                          ),
                        ),
                        footer: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '${profileController.profileCompletionPercentage.value.toStringAsFixed(0)}% Complete',
                            style: getTextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor:
                            profileController
                                    .profileCompletionPercentage
                                    .value ==
                                100
                            ? Colors.green
                            : profileController
                                      .profileCompletionPercentage
                                      .value >=
                                  70
                            ? AppColors.beakYellow
                            : profileController
                                      .profileCompletionPercentage
                                      .value >=
                                  40
                            ? Colors.orange
                            : Colors.red,
                        backgroundColor: Colors.grey.shade200,
                      );
                    },
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
                      _controller.vendorDetails.value?.locationName != null &&
                              _controller
                                  .vendorDetails
                                  .value!
                                  .locationName!
                                  .isNotEmpty
                          ? _controller.vendorDetails.value!.locationName!
                          : 'Add your business location',
                      style: getTextStyle(
                        fontSize: 14.sp,
                        color:
                            _controller.vendorDetails.value?.locationName !=
                                    null &&
                                _controller
                                    .vendorDetails
                                    .value!
                                    .locationName!
                                    .isNotEmpty
                            ? Colors.black54
                            : Colors.grey,
                      ),
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

  /// Build profile image widget with fallback
  Widget _buildProfileImage(HomeController controller) {
    // Priority 1: Check if MyProfileController has a local file (recently picked)
    try {
      final myProfileController = Get.find<MyProfileController>();
      if (myProfileController.profileImagePath.value != null) {
        return Image.file(
          File(myProfileController.profileImagePath.value!),
          fit: BoxFit.cover,
          width: 90,
          height: 90,
        );
      }
    } catch (e) {
      // MyProfileController not found, continue to next priority
    }

    // Priority 2: Photo URL from reactive HomeController
    if (controller.vendorPhotoUrl.value != null &&
        controller.vendorPhotoUrl.value!.isNotEmpty) {
      // Add timestamp to bust cache - use controller's timestamp for consistency
      final timestamp = controller.imageUpdateTimestamp.value;
      final imageUrl = controller.vendorPhotoUrl.value!.contains('?')
          ? '${controller.vendorPhotoUrl.value!}&t=$timestamp'
          : '${controller.vendorPhotoUrl.value!}?t=$timestamp';
      return NetworkImageWithFallback(
        imageUrl,
        fallback: ImagePath.logo,
        fit: BoxFit.cover,
        width: 90,
        height: 90,
      );
    }

    // Priority 3: Default asset image
    return Image.asset(
      ImagePath.logo,
      fit: BoxFit.cover,
      width: 90,
      height: 90,
    );
  }
}
