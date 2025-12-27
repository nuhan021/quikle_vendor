import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/enums.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../controllers/verification_controller.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerificationController());
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Center(
            child: SizedBox(
              width: 392.w,
              height: 852.h,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 392.w,
                      height: 852.h,
                      alignment: Alignment.center,
                      child: Container(
                        width: 708.w,
                        height: 1047.h,
                        decoration: const ShapeDecoration(
                          color: Colors.black,
                          shape: OvalBorder(),
                        ),
                      ),
                    ),
                  ),

                  // ===== Top bar: back button + title =====
                  Positioned(
                    left: 16.w,
                    top: 24.5.h,
                    child: SizedBox(
                      width: 360.w,
                      child: Stack(
                        children: [
                          // Back button (left)
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Container(
                              width: 24.w,
                              height: 24.w,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                size: 18.sp,
                                color: const Color(0xFFF8F8F8),
                              ),
                            ),
                          ),
                          // Title (centered)
                          Center(
                            child: Text(
                              'Verification',
                              style: getTextStyle(
                                font: CustomFonts.obviously,
                                color: const Color(0xFFF8F8F8),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ===== Header block (logo + texts) =====
                  Positioned(
                    left: 20.w,
                    top: 202.h,
                    child: SizedBox(
                      width: 352.w,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 63,
                            height: 64,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFFFC200),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 8,
                                  top: 8,
                                  child: Container(
                                    width: 47,
                                    height: 48,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(ImagePath.verifyIcon),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Stack(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),
                          // Enter Code
                          SizedBox(
                            width: 352.w,
                            child: Text(
                              'Enter Code',
                              textAlign: TextAlign.center,
                              style: getTextStyle(
                                font: CustomFonts.obviously,
                                color: AppColors.eggshellWhite,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          SizedBox(height: 8.h),

                          SizedBox(
                            width: 352.w,
                            child: Text(
                              "We've sent a 6-digit code to",
                              textAlign: TextAlign.center,
                              style: getTextStyle(
                                font: CustomFonts.inter,
                                color: AppColors.featherGrey,
                              ),
                            ),
                          ),

                          SizedBox(height: 8.h),

                          SizedBox(
                            width: 352.w,
                            child: Text(
                              controller.phone,
                              textAlign: TextAlign.center,
                              style: getTextStyle(
                                font: CustomFonts.inter,
                                color: AppColors.beakYellow,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ===== OTP + Verify + Resend block =====
                  Positioned(
                    left: 20.w,
                    top: 495.h,
                    child: SizedBox(
                      width: 352.w,
                      // height: 155.h,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // OTP row (6 boxes) – first 2 yellow per Figma, others grey
                          Obx(
                            () => PinCodeTextField(
                              controller: controller.pinController,
                              errorAnimationController:
                                  controller.errorAnimationController,

                              appContext: context,
                              length: 6,
                              onChanged: (value) {
                                for (int i = 0; i < 6; i++) {
                                  controller.otpDigits[i] = i < value.length
                                      ? value[i]
                                      : '';
                                }
                                if (value.isNotEmpty) {
                                  controller.hasError.value = false;
                                }
                              },
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(8.r),
                                fieldHeight: 52.h,
                                fieldWidth: 48.67.w,
                                activeFillColor: Colors.transparent,
                                inactiveFillColor: Colors.transparent,
                                selectedFillColor: Colors.transparent,
                                activeColor: controller.hasError.value
                                    ? Colors.redAccent
                                    : const Color(0xFFFFC200),
                                inactiveColor: controller.hasError.value
                                    ? Colors.redAccent
                                    : const Color(0xFF7C7C7C),
                                selectedColor: controller.hasError.value
                                    ? Colors.redAccent
                                    : const Color(0xFFFFC200),
                                errorBorderColor: Colors.redAccent,
                              ),
                              textStyle: TextStyle(
                                color: AppColors.eggshellWhite,
                                fontSize: 18.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                              keyboardType: TextInputType.number,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                          ),

                          SizedBox(height: 16.h),
                          Obx(
                            () => CustomButton(
                              text: controller.isVerifying.value
                                  ? 'Verifying…'
                                  : 'Verify Code',
                              onPressed: controller.isLogin
                                  ? controller.onTapVerifyLogin
                                  : controller.onTapVerifySignup,
                              isLoading: controller.isVerifying.value,
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

                          SizedBox(height: 16.h),

                          // Resend text (Container -> RichText)
                          SizedBox(
                            width: 352.w,
                            child: Obx(() {
                              final canResend = controller.canResend;
                              final seconds = controller.secondsLeft.value;
                              return GestureDetector(
                                onTap: canResend
                                    ? controller.onTapResend
                                    : null,
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Resend code in ',
                                        style: getTextStyle(
                                          font: CustomFonts.inter,
                                          color: AppColors.featherGrey,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      TextSpan(
                                        text: canResend
                                            ? 'now'
                                            : '${seconds.toString().padLeft(2, '0')}s',
                                        style: TextStyle(
                                          color: const Color(0xFFFFC200),
                                          fontSize: 14.sp,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          height: 1.50,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
