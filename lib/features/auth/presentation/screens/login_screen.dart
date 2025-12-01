import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/common/widgets/custom_button.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/enums.dart';
import '../../controllers/login_controller.dart';
import '../widgets/common_widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Material(
        color: Colors.black,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 64.h),
                CommonWidgets.appLogo(),
                SizedBox(height: 16.h),
                SizedBox(
                  width: 209.w,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Welcome ',
                          style: getTextStyle(
                            font: CustomFonts.obviously,
                            color: AppColors.beakYellow,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w500,
                            lineHeight: 1.20,
                          ),
                        ),
                        TextSpan(
                          text: 'Back!',
                          style: getTextStyle(
                            font: CustomFonts.obviously,
                            color: AppColors.eggshellWhite,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 64.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Phone Number',
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      color: AppColors.eggshellWhite,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                CommonWidgets.customTextField(
                  controller: controller.phoneController,
                  hintText: 'Enter Your Phone Number',
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 24.h),
                Obx(
                  () => CustomButton(
                    text: controller.isLoading.value
                        ? 'Logging In...'
                        : 'Log In',
                    onPressed: controller.onTapLogin,
                    isLoading: controller.isLoading.value,
                    backgroundColor: AppColors.beakYellow,
                    textColor: AppColors.ebonyBlack,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    height: 48.h,
                    style: getTextStyle(
                      font: CustomFonts.manrope,
                      color: AppColors.ebonyBlack,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 352.w,
                  child: Text(
                    "Don't have an account?",
                    textAlign: TextAlign.center,
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      color: AppColors.eggshellWhite,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                CommonWidgets.secondaryButton(
                  text: 'Create An Account',
                  onTap: controller.onTapCreateAccount,
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
