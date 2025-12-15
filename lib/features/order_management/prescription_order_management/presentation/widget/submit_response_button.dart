import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import 'package:quikle_vendor/core/common/widgets/custom_button.dart';
import '../../controller/prescription_controller.dart';

class SubmitResponseButton extends StatelessWidget {
  final List<String> selectedProductIds;
  final Map<String, int> productQuantities;
  final Map<String, String> productBrands;
  final Map<String, String> productDosages;
  final Map<String, String> productNotes;
  final TextEditingController prescriptionNotesController;

  const SubmitResponseButton({
    super.key,
    required this.selectedProductIds,
    required this.productQuantities,
    required this.productBrands,
    required this.productDosages,
    required this.productNotes,
    required this.prescriptionNotesController,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: GetBuilder<PrescriptionController>(
        builder: (controller) {
          final prescriptionId = Get.arguments?['prescriptionId'] as int?;
          if (prescriptionId == null || controller.prescriptions.isEmpty) {
            return const SizedBox.shrink();
          }

          final prescription = controller.prescriptions.firstWhere(
            (p) => p.id == prescriptionId,
            orElse: () => controller.prescriptions.first,
          );

          final currentStatus = (prescription.status?.toLowerCase() ?? '')
              .replaceAll(' ', '')
              .replaceAll('_', '');
          final isMedicineReady = currentStatus == 'medicineready';
          final isInvalid = currentStatus == 'invalid';

          if (isInvalid || isMedicineReady) {
            return const SizedBox.shrink();
          }

          return Container(
            color: const Color(0xFFF6F7F8),
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
            child: CustomButton(
              text: isMedicineReady ? 'Submitted' : 'Submit Response',
              onPressed: isMedicineReady
                  ? () {}
                  : () => _submitResponse(controller, prescriptionId),
              height: 48.h,
              borderRadius: 14,
              backgroundColor: isMedicineReady
                  ? Colors.grey
                  : AppColors.primary,
              textColor: Colors.white,
              fontSize: 14.sp,
            ),
          );
        },
      ),
    );
  }

  Future<void> _submitResponse(
    PrescriptionController controller,
    int prescriptionId,
  ) async {
    if (selectedProductIds.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please select at least one medicine',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final medicines = <Map<String, dynamic>>[];
    for (int i = 0; i < selectedProductIds.length; i++) {
      final productId = selectedProductIds[i];
      medicines.add({
        'item_id': int.tryParse(productId) ?? 0,
        'brand': productBrands[productId] ?? '',
        'dosage': productDosages[productId] ?? '',
        'quantity': productQuantities[productId] ?? 1,
        'notes': productNotes[productId] ?? '',
      });
    }

    final success = await controller.submitVendorResponse(
      prescriptionId: prescriptionId,
      medicines: medicines,
      prescriptionNotes: prescriptionNotesController.text,
    );

    if (success) {
      Future.delayed(const Duration(milliseconds: 800), () {
        Get.back();
      });
    }
  }
}
