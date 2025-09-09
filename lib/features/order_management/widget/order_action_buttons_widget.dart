import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/features/order_management/controller/order_management_controller.dart';

import '../../../core/common/styles/global_text_style.dart';

class OrderActionButtonsWidget extends StatelessWidget {
  final String orderId;
  final bool requiresPrescription;

  const OrderActionButtonsWidget({
    super.key,
    required this.orderId,
    required this.requiresPrescription,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderManagementController>();

    if (requiresPrescription) {
      return GestureDetector(
        onTap: () => controller.reviewOrder(orderId),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Color(0xFF111827),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Review',
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => controller.rejectOrder(orderId),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xFFDC2626), width: 2),
              ),
              child: Text(
                'Reject',
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFDC2626),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => controller.acceptOrder(orderId),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Color(0xFF111827),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Accept',
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
