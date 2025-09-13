import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/common/widgets/custom_button.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../controller/rider_assignment_controller.dart';

class RiderAssignedSuccessDialog extends StatelessWidget {
  RiderAssignedSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RiderAssignmentController>();

    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                () => RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Order ${controller.orderId.value} assigned to\n',
                        style: getTextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),

                      TextSpan(
                        text: '${controller.assignedRiderName.value}!',
                        style: getTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40),

              CustomButton(
                text: 'Done',
                onPressed: controller.completeAssignment,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
