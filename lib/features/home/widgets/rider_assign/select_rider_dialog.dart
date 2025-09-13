import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../controller/rider_assignment_controller.dart';

class SelectRiderDialog extends StatelessWidget {
  SelectRiderDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RiderAssignmentController>();

    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                () => Text(
                  'Select Rider for Order ${controller.orderId.value}',
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24),

              // Riders List
              Obx(
                () => Column(
                  children: controller.availableRiders.map((rider) {
                    return GestureDetector(
                      onTap: () => controller.selectRider(rider['id']!),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                controller.selectedRiderId.value == rider['id']
                                ? Color(0xFF111827)
                                : Color(0xFFE5E7EB),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      controller.selectedRiderId.value ==
                                          rider['id']
                                      ? Color(0xFF111827)
                                      : Color(0xFFD1D5DB),
                                  width: 2,
                                ),
                                color:
                                    controller.selectedRiderId.value ==
                                        rider['id']
                                    ? Color(0xFF111827)
                                    : Colors.transparent,
                              ),
                              child:
                                  controller.selectedRiderId.value ==
                                      rider['id']
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 12,
                                    )
                                  : null,
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    rider['name']!,
                                    style: getTextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF111827),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${rider['status']} - ${rider['distance']}',
                                    style: getTextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Cancel',
                      onPressed: controller.cancelDialog,
                      textColor: Colors.black,
                      backgroundColor: Colors.white,
                      borderColor: Colors.black,
                    ),
                  ),
                  SizedBox(width: 16),

                  Expanded(
                    child: Obx(
                      () => GestureDetector(
                        onTap: controller.selectedRiderId.value.isNotEmpty
                            ? controller.confirmAssignment
                            : null,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: controller.selectedRiderId.value.isNotEmpty
                                ? Color(0xFF111827)
                                : Color(0xFFE5E7EB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Confirm Assignment',
                            style: getTextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: controller.selectedRiderId.value.isNotEmpty
                                  ? Colors.white
                                  : Color(0xFF9CA3AF),
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
