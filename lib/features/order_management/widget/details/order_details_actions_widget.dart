import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../controller/order_management_controller.dart';

class OrderDetailsActionsWidget extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const OrderDetailsActionsWidget({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderManagementController>();
    final String status = orderData['status'];
    final bool requiresPrescription = orderData['requiresPrescription'];
    final String orderId = orderData['id'];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // View Prescription Button (if prescription required)
          if (requiresPrescription) ...[
            CustomButton(
              text: 'View Prescription',
              onPressed: () => controller.viewPrescription(orderId),
              backgroundColor: AppColors.backgroundLight,
              textColor: AppColors.backgroundDark,
              borderColor: AppColors.textSecondary,
            ),
            SizedBox(height: 10),
          ],

          // Action Buttons based on status
          if (status == 'new') ...[
            if (requiresPrescription) ...[
              CustomButton(
                text: 'Review',
                onPressed: () => controller.reviewOrder(orderId),
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Reject',
                      onPressed: () => controller.rejectOrder(orderId),
                      backgroundColor: Colors.white,
                      textColor: AppColors.error,
                      borderColor: AppColors.error,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: 'Accept',
                      onPressed: () => controller.acceptOrder(orderId),
                    ),
                  ),
                ],
              ),
            ],
          ] else if (status == 'accepted') ...[
            CustomButton(
              text: 'Mark as Prepared',
              onPressed: () => controller.markAsPrepared(orderId),
            ),
          ] else if (status == 'in-progress') ...[
            CustomButton(
              text: 'Mark as Dispatched',
              onPressed: () => controller.markAsDispatched(orderId),
            ),
          ],
        ],
      ),
    );
  }
}
