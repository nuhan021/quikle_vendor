import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/enums.dart';
import '../../../../core/utils/constants/image_path.dart';

class CommonWidgets {
  static Widget appLogo() {
    return Container(
      width: 64.w,
      height: 64.w,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImagePath.logo),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  static Widget customTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 52.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: errorText != null ? Colors.red : const Color(0xFF7C7C7C),
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          alignment: Alignment.centerLeft,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            style: getTextStyle(
              font: CustomFonts.inter,
              color: AppColors.eggshellWhite,
            ),
            cursorColor: const Color(0xFFF8F8F8),
            decoration: InputDecoration(
              isCollapsed: true,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: hintText,
              hintStyle: getTextStyle(
                font: CustomFonts.inter,
                color: AppColors.featherGrey,
              ),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Text(
              errorText,
              style: getTextStyle(
                font: CustomFonts.inter,
                color: Colors.red,
                fontSize: 12.sp,
              ),
            ),
          ),
      ],
    );
  }

  static Widget primaryButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 48.h,
        // padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
        decoration: ShapeDecoration(
          color: const Color(0xFFFFC200),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: getTextStyle(
                  font: CustomFonts.manrope,
                  color: AppColors.ebonyBlack,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget secondaryButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50.h,
        // padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white.withOpacity(0.05),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1.w, color: const Color(0xFFF8F8F8)),
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: getTextStyle(
                font: CustomFonts.inter,
                color: const Color(0xFFFFC200),
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
