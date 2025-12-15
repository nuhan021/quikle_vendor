import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import 'package:quikle_vendor/core/utils/constants/image_path.dart';
import 'package:quikle_vendor/features/vendor/models/vendor_model.dart';
import '../../../core/common/styles/global_text_style.dart';
import '../../../core/utils/constants/icon_path.dart';
import '../controller/home_controller.dart';

class RestaurantHeaderWidget extends StatelessWidget {
  RestaurantHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final vendorData = StorageService.getVendorDetails();
    final vendorDetails = vendorData != null
        ? VendorDetailsModel.fromJson(vendorData)
        : null;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Obx(
            () => Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: _buildRestaurantImage(controller),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vendorDetails?.shopName ?? 'Tandoori Tarang',
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Obx(
                      () => controller.isShopOpen.value
                          ? Image.asset(IconPath.active, width: 10, height: 10)
                          : SizedBox(),
                    ),
                    SizedBox(width: 4),
                    Obx(
                      () => Text(
                        controller.isShopOpen.value ? 'Open' : 'Closed',
                        style: getTextStyle(
                          fontSize: 14,
                          color: controller.isShopOpen.value
                              ? AppColors.success
                              : AppColors.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Obx(
                      () => Text(
                        _formatTo12Hour(
                          controller.vendorCloseTime.value ??
                              vendorDetails?.closeTime ??
                              '19:00',
                        ),
                        style: getTextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Obx(
            () => Transform.scale(
              scale: 0.76,
              child: Switch(
                value: controller.isShopOpen.value,
                onChanged: (value) => controller.toggleShopStatus(),
                thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.textWhite;
                  }
                  return AppColors.textWhite;
                }),
                trackColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Color.fromRGBO(3, 197, 32, 0.775);
                  }
                  return Color.fromRGBO(0, 0, 0, 1);
                }),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTo12Hour(String? rawTime) {
    if (rawTime == null || rawTime.trim().isEmpty) return '--';

    final value = rawTime.trim();
    final lower = value.toLowerCase();

    // If the backend already sends AM/PM, normalize casing and spacing.
    if (lower.contains('am') || lower.contains('pm')) {
      final match = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(value);
      if (match != null) {
        final hour = match.group(1)!.padLeft(2, '0');
        final minute = match.group(2)!.padLeft(2, '0');
        final suffix = lower.contains('pm') ? 'PM' : 'AM';
        return '$hour:$minute $suffix';
      }
      return value.toUpperCase();
    }

    // Parse 24-hour input like 19:00 or 08:30:15
    final match = RegExp(r'^(\d{1,2}):(\d{2})(?::\d{2})?$').firstMatch(value);
    if (match == null) return value; // Unknown format; return as-is.

    final hour24 = int.tryParse(match.group(1) ?? '') ?? 0;
    final minute = int.tryParse(match.group(2) ?? '') ?? 0;

    final isPm = hour24 >= 12;
    var hour12 = hour24 % 12;
    if (hour12 == 0) hour12 = 12;

    final hourStr = hour12.toString().padLeft(2, '0');
    final minuteStr = minute.toString().padLeft(2, '0');

    return '$hourStr:$minuteStr ${isPm ? 'PM' : 'AM'}';
  }

  /// Build restaurant image from photo URL or default asset
  Widget _buildRestaurantImage(HomeController controller) {
    // Priority 1: Photo URL from reactive HomeController
    if (controller.vendorPhotoUrl.value != null &&
        controller.vendorPhotoUrl.value!.isNotEmpty) {
      return Image.network(
        controller.vendorPhotoUrl.value!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(ImagePath.shopImage, fit: BoxFit.cover);
        },
      );
    }

    // Fallback to default asset image
    return Image.asset(ImagePath.shopImage, fit: BoxFit.cover);
  }
}
