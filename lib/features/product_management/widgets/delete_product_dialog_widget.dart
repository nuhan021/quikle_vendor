import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/common/styles/global_text_style.dart';
import '../controllers/products_controller.dart';

class DeleteProductDialogWidget extends StatelessWidget {
  DeleteProductDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>();

    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          margin: EdgeInsets.all(20.h),
          padding: EdgeInsets.all(32.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.h),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Do You Want To ',
                      style: getTextStyle(
                        fontSize: 18.h,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                    TextSpan(
                      text: 'Delete',
                      style: getTextStyle(
                        fontSize: 18.h,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                    TextSpan(
                      text: '\nThe Product ?',
                      style: getTextStyle(
                        fontSize: 18.h,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'Products will be removed from your inventory permanently if you delete',
                style: getTextStyle(fontSize: 14.h, color: Color(0xFF6B7280)),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: controller.hideDeleteConfirmation,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: Color(0xFF111827),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          'No',
                          style: getTextStyle(
                            fontSize: 14.h,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF111827),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.h),
                  Expanded(
                    child: Obx(
                      () => GestureDetector(
                        onTap: controller.isDeleting.value
                            ? null
                            : controller.deleteProduct,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          decoration: BoxDecoration(
                            color: controller.isDeleting.value
                                ? Color(0xFF111827).withOpacity(0.6)
                                : Color(0xFF111827),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            controller.isDeleting.value ? 'Yes...' : 'Yes',
                            style: getTextStyle(
                              fontSize: 14.h,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
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
