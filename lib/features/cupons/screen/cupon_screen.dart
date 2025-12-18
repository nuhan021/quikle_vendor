import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_vendor/core/common/widgets/custom_button.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import 'package:quikle_vendor/features/appbar/screen/appbar_screen.dart';
import 'package:quikle_vendor/features/cupons/controllers/cupon_controller.dart';
import 'package:quikle_vendor/features/cupons/models/cupon_model.dart';
import 'package:quikle_vendor/features/cupons/widgets/coupon_modal_widget.dart';

class CuponScreen extends StatelessWidget {
  CuponScreen({super.key});

  final CouponController c = Get.put(CouponController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F6),
      appBar: AppbarScreen(title: "Cupons"),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => c.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.ebonyBlack,
                      ),
                    )
                  : c.coupons.isEmpty
                  ? Center(
                      child: Text(
                        'No coupons yet.\n You need to verify your shop to create coupons.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                      itemCount: c.coupons.length,
                      itemBuilder: (_, index) {
                        final coupon = c.coupons[index];
                        return _buildCouponCard(coupon);
                      },
                    ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
            child: CustomButton(
              text: 'Create New Coupon',
              onPressed: () {
                c.openCreateForm();
                _showCouponModal();
              },
              backgroundColor: AppColors.ebonyBlack,
              textColor: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              borderRadius: 12.r,
              height: 48.h,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponCard(CouponModel coupon) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      elevation: 0.5,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // left content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    coupon.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  // Description
                  Text(
                    coupon.description,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Coupon Code
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Text(
                      'Code: ${coupon.code}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ebonyBlack,
                      ),
                    ),
                  ),
                  if (coupon.createdAt != null) ...[
                    SizedBox(height: 6.h),
                    // Created time
                    // Text(
                    //   _formatCreatedTime(coupon.createdAt!),
                    //   style: TextStyle(
                    //     fontSize: 11.sp,
                    //     fontWeight: FontWeight.w400,
                    //     color: const Color(0xFF9CA3AF),
                    //   ),
                    // ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 16.w),
            // right - discount and actions
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Discount percentage
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${coupon.discount}%',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Discount',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                // Edit and Delete icons
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        size: 20.sp,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        c.openEditForm(coupon);
                        _showCouponModal();
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        size: 20.sp,
                        color: Colors.black54,
                      ),
                      onPressed: () => _showDeleteConfirmationDialog(coupon),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCouponModal() {
    Get.dialog(CouponModalWidget(controller: c));
  }

  void _showDeleteConfirmationDialog(CouponModel coupon) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Warning icon
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
                child: Icon(
                  Icons.warning_rounded,
                  size: 32.sp,
                  color: AppColors.error,
                ),
              ),
              SizedBox(height: 20.h),
              // Title
              Text(
                'Delete Coupon',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ebonyBlack,
                ),
              ),
              SizedBox(height: 12.h),
              // Message
              Text(
                'Are you sure you want to delete this coupon?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              // Coupon title
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              //   decoration: BoxDecoration(
              //     color: AppColors.backgroundLight,
              //     borderRadius: BorderRadius.circular(8.r),
              //     border: Border.all(color: AppColors.surfaceLight),
              //   ),
              //   child: Text(
              //     '"${coupon.title}"',
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //       fontSize: 13.sp,
              //       fontWeight: FontWeight.w600,
              //       color: AppColors.ebonyBlack,
              //     ),
              //   ),
              // ),
              SizedBox(height: 16.h),
              // Warning text
              Text(
                'This action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.error,
                ),
              ),
              SizedBox(height: 28.h),
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Cancel',
                      onPressed: () => Get.back(),
                      backgroundColor: Colors.transparent,
                      textColor: AppColors.ebonyBlack,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      borderRadius: 10.r,
                      height: 45.h,
                      borderColor: AppColors.ebonyBlack,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: CustomButton(
                      text: 'Delete',
                      onPressed: () {
                        c.deleteCoupon(coupon.id);
                        Get.back();
                      },
                      backgroundColor: AppColors.ebonyBlack,
                      textColor: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      borderRadius: 10.r,
                      height: 45.h,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
