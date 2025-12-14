// ------------ CARD WIDGET ------------
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quikle_vendor/core/common/widgets/custom_button.dart';
import 'package:quikle_vendor/features/order_management/prescription_order_management/models/prescription_model.dart';
import 'package:quikle_vendor/features/order_management/prescription_order_management/controller/prescription_controller.dart';
import 'package:quikle_vendor/features/order_management/prescription_order_management/presentation/screens/prescription_details_screen.dart';

class PrescriptionCardWidget extends StatelessWidget {
  final PrescriptionModel item;

  const PrescriptionCardWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get the controller
        final controller = Get.find<PrescriptionController>();
        // Only change to underReview if status is uploaded
        if (item.status?.toLowerCase() == 'uploaded') {
          controller.changePrescriptionStatus(
            item.id ?? 0,
            'underReview',
            item.userId ?? 0,
          );
        } else {
          Get.snackbar(
            'Status Locked',
            'Only uploaded prescriptions can be reviewed',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
        // Navigate to details screen and pass the prescription ID
        Get.to(
          () => const PrescriptionDetailsScreen(),
          arguments: {'prescriptionId': item.id},
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with ID and Status Tag
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ID #${item.id}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                ),
                // Status Badge - Top Right
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(_getDisplayStatus()).background,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    _getStatusLabel(_getDisplayStatus()),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(_getDisplayStatus()).textColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // User Name with Icon and Date/Time - Horizontal Alignment
            Row(
              children: [
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFF111827),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person, color: Colors.white, size: 12.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    item.userName ?? 'Unknown User',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF111827),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  _formatDate(item.uploadedAt),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // View Details Button
            CustomButton(
              text: 'View Details',
              onPressed: () {
                Get.to(() => const PrescriptionDetailsScreen());

                final controller = Get.find<PrescriptionController>();

                // Call the status change method
                controller.changePrescriptionStatus(
                  item.id ?? 0,
                  item.status ?? 'pending',
                  item.userId ?? 0,
                );
              },
              height: 48.h,
              backgroundColor: const Color(0xFF111827),
              textColor: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              borderRadius: 8.r,
            ),
          ],
        ),
      ),
    );
  }

  // Format date to readable format
  String _formatDate(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) {
      return 'No date';
    }
    try {
      final parsedDate = DateTime.parse(dateTime);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final dateToCompare = DateTime(
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,
      );

      // Check if it's today
      if (dateToCompare == today) {
        return 'Today ${DateFormat('hh:mm a').format(parsedDate)}';
      }
      // Check if it's yesterday
      else if (dateToCompare == yesterday) {
        return 'Yesterday ${DateFormat('hh:mm a').format(parsedDate)}';
      }
      // Otherwise show date
      else {
        return DateFormat('MMM dd, yyyy hh:mm a').format(parsedDate);
      }
    } catch (e) {
      return dateTime;
    }
  }

  // Get the display status - use prescription model status
  String _getDisplayStatus() {
    // Always use the prescription status from the model
    return item.status ?? 'pending';
  }

  // Helper method for status color
  _StatusStyle _getStatusColor(String status) {
    final statusLower = status.toLowerCase().trim();
    switch (statusLower) {
      case 'underreview':
      case 'under_review':
      case 'under review':
        return _StatusStyle(const Color(0xFFFFF2D8), const Color(0xFFF9A825));
      case 'valid':
        return _StatusStyle(const Color(0xFFE4F7EA), const Color(0xFF2E7D32));
      case 'invalid':
        return _StatusStyle(const Color(0xFFFFEBEE), const Color(0xFFD32F2F));
      case 'medicinesready':
      case 'medicines_ready':
      case 'medicines ready':
        return _StatusStyle(const Color(0xFFE4F7EA), const Color(0xFF2E7D32));
      default:
        return _StatusStyle(
          Colors.grey[200] ?? const Color(0xFFE0E0E0),
          Colors.grey[700] ?? const Color(0xFF424242),
        );
    }
  }

  // Helper method for status label
  String _getStatusLabel(String status) {
    final statusLower = status.toLowerCase().trim();
    switch (statusLower) {
      case 'underreview':
      case 'under_review':
      case 'under review':
        return 'Under Review';
      case 'valid':
        return 'Valid';
      case 'invalid':
        return 'Invalid';
      case 'medicinesready':
      case 'medicines_ready':
      case 'medicines ready':
        return 'Medicines Ready';
      default:
        // Return the original status if no match found
        return status;
    }
  }
}

// Helper class for status styling
class _StatusStyle {
  final Color background;
  final Color textColor;

  _StatusStyle(this.background, this.textColor);
}
