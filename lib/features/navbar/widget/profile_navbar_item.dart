import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common/styles/global_text_style.dart';
import '../../../core/utils/constants/colors.dart';
import '../../../core/utils/widgets/network_image_with_fallback.dart';
import '../../../features/home/controller/home_controller.dart';
import '../../../features/profile/my_profile/controller/my_profile_controller.dart';

class ProfileNavbarItem extends StatelessWidget {
  final String imagePath;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const ProfileNavbarItem({
    super.key,
    required this.imagePath,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GetX<HomeController>(
            builder: (homeController) => ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 28,
                height: 28,
                child: _buildProfileImage(homeController),
              ),
            ),
          ),
          const SizedBox(height: 4),
          GetX<HomeController>(
            builder: (homeController) => Text(
              homeController.vendorOwnerName.value ?? label,
              style: getTextStyle(
                color: selected ? AppColors.primary : Colors.white,
              ),
            ),
          ),
        ],
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
        fallback: imagePath,
        fit: BoxFit.cover,
      );
    }

    // Priority 3: Default asset image
    return Image.asset(imagePath, fit: BoxFit.cover);
  }
}
