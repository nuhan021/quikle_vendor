import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common/styles/global_text_style.dart';
import '../../../core/utils/constants/colors.dart';
import '../../../core/utils/widgets/network_image_with_fallback.dart';
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
            () => ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 28,
                height: 28,
                child: _buildProfileImage(homeController),
              ),
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

  /// Build profile image widget with fallback
  Widget _buildProfileImage(HomeController controller) {
    // Priority 1: Photo URL from reactive HomeController
    if (controller.vendorPhotoUrl.value != null &&
        controller.vendorPhotoUrl.value!.isNotEmpty) {
      return NetworkImageWithFallback(
        controller.vendorPhotoUrl.value!,
        fallback: imagePath,
        fit: BoxFit.cover,
      );
    }

    // Priority 2: Default asset image
    return Image.asset(imagePath, fit: BoxFit.cover);
  }
}
