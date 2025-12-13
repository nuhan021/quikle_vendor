// ------------ CARD WIDGET ------------
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/features/order_management/prescription_order_management/models/prescription_model.dart';
import 'package:quikle_vendor/features/order_management/prescription_order_management/presentation/screens/prescription_details_screen.dart';

class PrescriptionCardWidget extends StatelessWidget {
  final Prescription item;

  const PrescriptionCardWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const PrescriptionDetailsScreen());
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8.r,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Name
            Text(
              item.userName,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.h),
            // Status pill and right arrow
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(item.status).background,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    _getStatusLabel(item.status),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: _getStatusColor(item.status).textColor,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[400], size: 24.r),
              ],
            ),
            SizedBox(height: 12.h),
            // Date
            Text(
              item.uploadedAt,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for status color
  _StatusStyle _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return _StatusStyle(const Color(0xFFFFF2D8), const Color(0xFFF9A825));
      case 'approved':
        return _StatusStyle(const Color(0xFFE4F7EA), const Color(0xFF2E7D32));
      case 'clarification':
        return _StatusStyle(const Color(0xFFFFEBEE), const Color(0xFFD32F2F));
      case 'rejected':
        return _StatusStyle(const Color(0xFFFFEBEE), const Color(0xFFD32F2F));
      default:
        return _StatusStyle(
          Colors.grey[200] ?? const Color(0xFFE0E0E0),
          Colors.grey[700] ?? const Color(0xFF424242),
        );
    }
  }

  // Helper method for status label
  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending Review';
      case 'approved':
        return 'Approved';
      case 'clarification':
        return 'Needs Clarification';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }
}

// Helper class for status styling
class _StatusStyle {
  final Color background;
  final Color textColor;

  _StatusStyle(this.background, this.textColor);
}
