import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/common/widgets/custom_button.dart';
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
      // View Order button - navigate to order details screen with action buttons
      return CustomButton(
        text: 'View Order',
        onPressed: () => controller.navigateToOrderDetails(orderId),
        height: 50,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        borderColor: Colors.black,
        fontWeight: FontWeight.w600,
      );
    }

    if (status == 'confirmed') {
      return Obx(() {
        final isDisabled = controller.disabledButtons.contains(orderId);
        return CustomButton(
          text: 'Mark as Prepared',
          onPressed: isDisabled
              ? () {}
              : () => controller.markAsPrepared(orderId),
          height: 50,
          backgroundColor: isDisabled
              ? const Color(0xFFD1D5DB)
              : const Color(0xFF111827),
          textColor: Colors.white,
          fontWeight: FontWeight.w600,
        );
      });
    }

    /// 🟠 IN-PROGRESS Orders
    if (status == 'in-progress') {
      return Obx(() {
        final isDisabled = controller.disabledButtons.contains(orderId);
        return CustomButton(
          text: 'Mark as Shipped',
          onPressed: isDisabled
              ? () {}
              : () => controller.markAsShipped(orderId),
          height: 50,
          backgroundColor: isDisabled
              ? const Color(0xFFD1D5DB)
              : const Color(0xFF111827),
          textColor: Colors.white,
          fontWeight: FontWeight.w600,
        );
      });
    }

    /// ⚪ COMPLETED Orders
    if (status == 'completed') {
      return CustomButton(
        text: 'View Details',
        onPressed: () => controller.viewDetails(orderId),
        height: 50,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontWeight: FontWeight.w600,
      );
    }

    return const SizedBox.shrink();
  }
}
