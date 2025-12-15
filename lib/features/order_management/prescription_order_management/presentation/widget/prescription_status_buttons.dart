import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import 'package:quikle_vendor/core/common/widgets/custom_button.dart';
import 'package:quikle_vendor/features/order_management/prescription_order_management/models/prescription_model.dart';
import '../../controller/prescription_controller.dart';

class PrescriptionStatusButtons extends StatefulWidget {
  final PrescriptionModel prescription;

  const PrescriptionStatusButtons({super.key, required this.prescription});

  @override
  State<PrescriptionStatusButtons> createState() =>
      _PrescriptionStatusButtonsState();
}

class _PrescriptionStatusButtonsState extends State<PrescriptionStatusButtons> {
  String? _actionInProgress;

  PrescriptionController get _prescriptionController =>
      Get.find<PrescriptionController>();

  bool get _isInvalidActionActive =>
      _actionInProgress == 'invalidating' || _actionInProgress == 'invalidated';

  bool get _isValidActionActive =>
      _actionInProgress == 'validating' || _actionInProgress == 'validated';

  @override
  Widget build(BuildContext context) {
    final rawStatus = widget.prescription.status ?? '';
    final currentStatus = rawStatus
        .toLowerCase()
        .replaceAll(' ', '')
        .replaceAll('_', '');

    print(
      '🔍 Prescription Status - Raw: "$rawStatus" | Normalized: "$currentStatus"',
    );

    if (currentStatus == 'medicineready' ||
        currentStatus.contains('medicine') && currentStatus.contains('ready')) {
      print('✅ Hiding buttons - Medicine is ready (prescription status)');
      return const SizedBox.shrink();
    }

    if (currentStatus == 'valid') {
      return CustomButton(
        text: 'Validated',
        onPressed: () {},
        height: 48.h,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        borderRadius: 12,
      );
    }

    if (currentStatus == 'invalid') {
      return CustomButton(
        text: 'Invalid',
        onPressed: () {},
        height: 48.h,
        backgroundColor: Colors.white,
        textColor: const Color(0xFFF44336),
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        borderRadius: 12,
        borderColor: const Color(0xFFF44336),
      );
    }

    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: _actionInProgress == 'invalidating'
                ? 'Invalidating...'
                : _actionInProgress == 'invalidated'
                ? 'Invalidated'
                : 'Invalid',
            onPressed: () {
              if (_actionInProgress != null) return;
              setState(() => _actionInProgress = 'invalidating');

              _prescriptionController
                  .changePrescriptionStatus(
                    widget.prescription.id ?? 0,
                    'invalid',
                    widget.prescription.userId ?? 0,
                  )
                  .then((_) {
                    setState(() => _actionInProgress = 'invalidated');
                    Future.delayed(const Duration(milliseconds: 500), Get.back);
                  });
            },
            height: 48.h,
            backgroundColor: _isInvalidActionActive
                ? const Color(0xFFF44336)
                : Colors.white,
            textColor: _isInvalidActionActive
                ? Colors.white
                : const Color(0xFFF44336),
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            borderRadius: 12,
            borderColor: const Color(0xFFF44336),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: CustomButton(
            text: _actionInProgress == 'validating'
                ? 'Validating...'
                : _actionInProgress == 'validated'
                ? 'Validated'
                : 'Valid',
            onPressed: () {
              if (_actionInProgress != null) return;
              setState(() => _actionInProgress = 'validating');

              _prescriptionController
                  .changePrescriptionStatus(
                    widget.prescription.id ?? 0,
                    'valid',
                    widget.prescription.userId ?? 0,
                  )
                  .then((_) {
                    setState(() => _actionInProgress = 'validated');
                    Future.delayed(const Duration(milliseconds: 500), Get.back);
                  });
            },
            height: 48.h,
            backgroundColor: _isValidActionActive
                ? AppColors.ebonyBlack.withOpacity(0.5)
                : AppColors.ebonyBlack,
            textColor: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            borderRadius: 12,
          ),
        ),
      ],
    );
  }
}
