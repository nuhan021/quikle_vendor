import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/common/widgets/custom_button.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import 'package:quikle_vendor/features/order_management/controller/order_management_controller.dart';

class OrderActionButtonsWidget extends StatelessWidget {
  final String orderId;
  final String status;
  final bool requiresPrescription;

  const OrderActionButtonsWidget({
    super.key,
    required this.orderId,
    required this.status,
    required this.requiresPrescription,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderManagementController>();

    /// 🟡 NEW Orders
    if (status == 'new') {
      if (requiresPrescription) {
        // Review button if prescription required
        return CustomButton(
          text: 'Review',
          onPressed: () => controller.reviewOrder(orderId),
          height: 50,
          backgroundColor: const Color(0xFF111827),
          textColor: Colors.white,
          fontWeight: FontWeight.w600,
        );
      }

      // Accept + Reject buttons
      return Row(
        children: [
          Expanded(
            child: CustomButton(
              text: 'Reject',
              onPressed: () => controller.rejectOrder(orderId),
              height: 50,
              backgroundColor: Colors.white,
              textColor: AppColors.error,
              borderColor: AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CustomButton(
              text: 'Accept',
              onPressed: () => controller.acceptOrder(orderId),
              height: 50,
              backgroundColor: const Color(0xFF111827),
              textColor: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    /// 🟢 ACCEPTED Orders
    if (status == 'accepted') {
      return CustomButton(
        text: 'Mark as Prepared',
        onPressed: () => controller.markAsPrepared(orderId),
        height: 50,
        backgroundColor: const Color(0xFF111827),
        textColor: Colors.white,
        fontWeight: FontWeight.w600,
      );
    }

    /// 🟠 IN-PROGRESS Orders
    if (status == 'in-progress') {
      return CustomButton(
        text: 'Mark as Dispatched',
        onPressed: () => controller.markAsDispatched(orderId),
        height: 50,
        backgroundColor: const Color(0xFF111827),
        textColor: Colors.white,
        fontWeight: FontWeight.w600,
      );
    }

    /// ⚪ COMPLETED Orders
    if (status == 'completed') {
      return CustomButton(
        text: 'View Details',
        onPressed: () => controller.viewDetails(orderId),
        height: 50,
        backgroundColor: const Color(0xFFE5E7EB),
        textColor: const Color(0xFF374151),
        fontWeight: FontWeight.w600,
      );
    }

    return const SizedBox.shrink();
  }
}
