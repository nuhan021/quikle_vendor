import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import 'package:quikle_vendor/core/common/widgets/custom_button.dart';
import '../../../../product_management/controllers/products_controller.dart';

void showProductSelectionDialog(
  BuildContext context,
  List<String> selectedProductIds,
  List<String> selectedProductNames,
  VoidCallback onStateChanged,
) {
  final productsController = Get.find<ProductsController>();
  String tempSearchText = '';

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          final filtered = productsController.products
              .where(
                (product) => product.title.toLowerCase().contains(
                  tempSearchText.toLowerCase(),
                ),
              )
              .toList();

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
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    onChanged: (value) =>
                        setDialogState(() => tempSearchText = value),
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      border: _dialogBorder,
                      enabledBorder: _dialogBorder,
                      focusedBorder: _dialogBorder,
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.h,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Text(
                              'No products found',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF9CA3AF),
                              ),
                            ),
                          )
                        : ListView(
                            children: filtered.map((product) {
                              final productId = product.id.toString();
                              final productName = product.title;
                              final isSelected = selectedProductIds.contains(
                                productId,
                              );

                              return GestureDetector(
                                onTap: () {
                                  if (isSelected) {
                                    selectedProductIds.remove(productId);
                                    selectedProductNames.remove(productName);
                                  } else {
                                    selectedProductIds.add(productId);
                                    selectedProductNames.add(productName);
                                  }
                                  setDialogState(() {});
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 12.h,
                                    horizontal: 12.w,
                                  ),
                                  margin: EdgeInsets.only(bottom: 4.h),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(6.r),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.black.withValues(alpha: 0.5)
                                          : const Color(0xFFE5E7EB),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isSelected
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                        color: isSelected
                                            ? AppColors.primary
                                            : const Color(0xFF9CA3AF),
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: Text(
                                          productName,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.w400,
                                            color: const Color(0xFF111827),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                  SizedBox(height: 12.h),
                  CustomButton(
                    text: 'Done',
                    onPressed: () {
                      Navigator.pop(context);
                      onStateChanged();
                    },
                    backgroundColor: AppColors.ebonyBlack,
                    textColor: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    borderRadius: 10.r,
                    height: 45.h,
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

OutlineInputBorder get _dialogBorder => OutlineInputBorder(
  borderRadius: BorderRadius.circular(8.r),
  borderSide: const BorderSide(color: AppColors.ebonyBlack, width: 1),
);
