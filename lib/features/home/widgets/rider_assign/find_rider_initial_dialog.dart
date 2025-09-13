import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/common/widgets/custom_button.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../controller/rider_assignment_controller.dart';

class FindRiderInitialDialog extends StatelessWidget {
  FindRiderInitialDialog({super.key});

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
                () => Text(
                  'Find Nearest Rider for Order\n${controller.orderId.value}',
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Click the button below to find available riders near the pickup location.',
                style: getTextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Find Riders',
                      onPressed: controller.findRiders,
                    ),
                  ),
                  SizedBox(width: 16),

                  Expanded(
                    child: CustomButton(
                      text: 'Cancel',
                      onPressed: controller.cancelDialog,
                      textColor: Colors.black,
                      backgroundColor: Colors.white,
                      borderColor: Colors.black,
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
