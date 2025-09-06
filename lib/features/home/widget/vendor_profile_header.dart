import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/constants/colors.dart';
import '../controller/vendor_controller.dart';

class VendorProfileHeader extends StatelessWidget {
  final String? vendorName;
  final String? lastSeen;
  final String? profileImage;

  const VendorProfileHeader({
    super.key,
    this.vendorName,
    this.lastSeen,
    this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VendorController>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          /// Profile Avatar
          Obx(
            () => Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(
                  profileImage ?? controller.vendorImage.value,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Icon(
                        Icons.restaurant,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          /// Vendor Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    vendorName ?? controller.vendorName.value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: controller.isVendorOpen.value
                              ? AppColors.success
                              : AppColors.error,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        controller.isVendorOpen.value ? "Open" : "Closed",
                        style: TextStyle(
                          fontSize: 12,
                          color: controller.isVendorOpen.value
                              ? AppColors.success
                              : AppColors.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        lastSeen ?? controller.operatingHours.value,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// Toggle Switch
          Obx(
            () => Transform.scale(
              scale: 0.8,
              child: Switch(
                value: controller.isVendorOpen.value,
                onChanged: (value) {
                  controller.toggleVendorStatus();
                },
                activeColor: AppColors.success,
                inactiveThumbColor: AppColors.error,
                inactiveTrackColor: AppColors.error.withOpacity(0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
