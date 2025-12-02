import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/enums.dart';
import '../../controllers/welcome_controller.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<WelcomeController>();
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome To ',
              style: getTextStyle(
                font: CustomFonts.obviously,
                color: AppColors.eggshellWhite,
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
              ),
            ),

            Text(
              'Quikle',
              style: getTextStyle(
                font: CustomFonts.obviously,
                color: AppColors.beakYellow,
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
