import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_vendor/core/common/widgets/custom_button.dart';
import 'package:quikle_vendor/core/common/widgets/custom_textfield.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import 'package:quikle_vendor/features/cupons/controllers/cupon_controller.dart';
import 'package:quikle_vendor/features/product_management/controllers/products_controller.dart';

class CouponModalWidget extends StatelessWidget {
  final CouponController controller;

  const CouponModalWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: GetBuilder<CouponController>(
          builder: (controller) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  textAlign: TextAlign.center,
                  controller.editingId.value == null
                      ? 'Create New Coupon'
                      : 'Edit Coupon',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20.h),
                // Title field
                Text(
                  'Title',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                TextField(
                  onChanged: (value) => controller.titleCtrl.value = value,
                  controller: TextEditingController(
                    text: controller.titleCtrl.value,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Big Sale',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(
                        color: AppColors.ebonyBlack,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(
                        color: AppColors.ebonyBlack,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(
                        color: AppColors.ebonyBlack,
                        width: 1,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                // Description field
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                TextField(
                  onChanged: (value) =>
                      controller.descriptionCtrl.value = value,
                  controller: TextEditingController(
                    text: controller.descriptionCtrl.value,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Discount up to 50%',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(
                        color: AppColors.ebonyBlack,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(
                        color: AppColors.ebonyBlack,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(
                        color: AppColors.ebonyBlack,
                        width: 1,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 16.h),
                // Discount field
                Text(
                  'Discount (%)',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                TextField(
                  onChanged: (value) => controller.discountCtrl.value = value,
                  controller: TextEditingController(
                    text: controller.discountCtrl.value,
                  ),
                  decoration: InputDecoration(
                    hintText: '20',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(
                        color: AppColors.ebonyBlack,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(
                        color: AppColors.ebonyBlack,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(
                        color: AppColors.ebonyBlack,
                        width: 1,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.h),
                // Product Selection field (optional)
                Text(
                  'Choose Products (Optional)',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Leave empty to apply coupon to all products',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showProductSelectionDialog(context, controller);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 14.h,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.ebonyBlack),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  controller.selectedProductNames.isEmpty
                                      ? 'Choose products'
                                      : '${controller.selectedProductNames.length} selected',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color:
                                        controller.selectedProductNames.isEmpty
                                        ? Colors.grey
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: const Color(0xFF9CA3AF),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (controller.selectedProductNames.isNotEmpty) ...[
                        SizedBox(height: 8.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: controller.selectedProductNames
                              .map(
                                (name) => Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(6.r),
                                    border: Border.all(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.ebonyBlack,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                // Error message display
                Obx(
                  () => controller.hasError.value
                      ? Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.5),
                            ),
                          ),
                          child: Text(
                            controller.errorMessage.value,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                            ),
                          ),
                        )
                      : SizedBox(height: 0),
                ),
                SizedBox(height: 24.h),
                // Save button
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Cancel',
                        onPressed: () => Get.back(),
                        backgroundColor: Colors.transparent,
                        textColor: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        borderRadius: 10.r,
                        height: 45.h,
                        borderColor: Colors.black,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Obx(
                        () => CustomButton(
                          text: controller.isSaving.value
                              ? 'saving...'
                              : 'Save',
                          onPressed: () {
                            if (!controller.isSaving.value) {
                              controller.saveCoupon();
                            }
                          },
                          backgroundColor: AppColors.ebonyBlack,
                          textColor: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          borderRadius: 10.r,
                          height: 45.h,
                          isLoading: controller.isSaving.value,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showProductSelectionDialog(
    BuildContext context,
    CouponController controller,
  ) {
    final ProductsController productsController =
        Get.find<ProductsController>();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Container(
            padding: EdgeInsets.all(16.w),
            constraints: BoxConstraints(maxHeight: 400.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Products',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 16.h),
                // Search Field
                CustomTextField(
                  label: '',
                  hintText: 'Search products...',
                  onChanged: (value) {
                    controller.productSearchText.value = value;
                  },
                ),
                SizedBox(height: 12.h),
                // Products List
                Expanded(
                  child: Obx(() {
                    final filtered = productsController.products
                        .where(
                          (product) => product.title.toLowerCase().contains(
                            controller.productSearchText.value.toLowerCase(),
                          ),
                        )
                        .toList();

                    return ListView(
                      children: filtered.isEmpty
                          ? [
                              Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(16.w),
                                child: Center(
                                  child: Text(
                                    'No products found',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: const Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ),
                              ),
                            ]
                          : filtered
                                .map(
                                  (product) => GestureDetector(
                                    onTap: () {
                                      final productId = product.id.toString();
                                      final productName = product.title;

                                      if (controller.selectedProductIds
                                          .contains(productId)) {
                                        controller.selectedProductIds.remove(
                                          productId,
                                        );
                                        controller.selectedProductNames.remove(
                                          productName,
                                        );
                                      } else {
                                        controller.selectedProductIds.add(
                                          productId,
                                        );
                                        controller.selectedProductNames.add(
                                          productName,
                                        );
                                      }

                                      // Update productIdCtrl with comma-separated IDs
                                      controller.productIdCtrl.value =
                                          controller.selectedProductIds.join(
                                            ',',
                                          );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12.h,
                                        horizontal: 12.w,
                                      ),
                                      margin: EdgeInsets.only(bottom: 4.h),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          6.r,
                                        ),
                                        border: Border.all(
                                          color:
                                              controller.selectedProductIds
                                                  .contains(
                                                    product.id.toString(),
                                                  )
                                              ? Colors.black.withValues(
                                                  alpha: 0.5,
                                                )
                                              : const Color(0xFFE5E7EB),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            controller.selectedProductIds
                                                    .contains(
                                                      product.id.toString(),
                                                    )
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color:
                                                controller.selectedProductIds
                                                    .contains(
                                                      product.id.toString(),
                                                    )
                                                ? AppColors.primary
                                                : const Color(0xFF9CA3AF),
                                          ),
                                          SizedBox(width: 10.w),
                                          Expanded(
                                            child: Text(
                                              product.title,
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight:
                                                    controller
                                                        .selectedProductIds
                                                        .contains(
                                                          product.id.toString(),
                                                        )
                                                    ? FontWeight.w600
                                                    : FontWeight.w400,
                                                color: const Color(0xFF111827),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                    );
                  }),
                ),
                SizedBox(height: 12.h),
                // Done Button
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Done',
                        onPressed: () => Navigator.pop(context),
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
        );
      },
    ).then((_) {
      controller.productSearchText.value = '';
    });
  }
}
