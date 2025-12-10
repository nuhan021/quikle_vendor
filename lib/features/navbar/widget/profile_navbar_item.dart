import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common/styles/global_text_style.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/constants/colors.dart';
import '../../../features/home/controller/home_controller.dart';

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
    final homeController = Get.find<HomeController>();

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => CircleAvatar(
              radius: 14,
              backgroundImage: _getProfileImage(homeController),
            ),
          ),
          const SizedBox(height: 4),
          Obx(
            () => Text(
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

  /// Get profile image from photo URL or default asset
  ImageProvider _getProfileImage(HomeController controller) {
    // Priority 1: Photo URL from reactive HomeController
    if (controller.vendorPhotoUrl.value != null &&
        controller.vendorPhotoUrl.value!.isNotEmpty) {
      return NetworkImage(controller.vendorPhotoUrl.value!);
    }

    // Priority 2: Default asset image
    return AssetImage(imagePath);
  }
}
