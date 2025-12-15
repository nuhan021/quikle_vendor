import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';

class SectionTitle extends StatelessWidget {
  final String text;

  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }
}

class PrescriptionNotesField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool enabled;

  const PrescriptionNotesField({
    super.key,
    required this.controller,
    required this.hint,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: AppColors.ebonyBlack, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: AppColors.ebonyBlack, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: AppColors.ebonyBlack, width: 1.5),
        ),
        contentPadding: EdgeInsets.all(12.w),
      ),
    );
  }
}

class VerificationWarning extends StatelessWidget {
  const VerificationWarning({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: AppColors.beakYellow.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info, color: AppColors.beakYellow, size: 18.sp),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              "Please verify the doctor's signature and date before marking as valid.",
              style: TextStyle(fontSize: 14.sp, color: AppColors.ebonyBlack),
            ),
          ),
        ],
      ),
    );
  }
}

class InitialLoader extends StatelessWidget {
  const InitialLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading prescription data...',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
