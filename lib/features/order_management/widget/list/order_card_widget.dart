import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/features/order_management/controller/order_management_controller.dart';
import '../../../../core/common/styles/global_text_style.dart';
import 'order_status_badge_widget.dart';
import 'order_action_buttons_widget.dart';

class OrderCardWidget extends StatelessWidget {
  final String orderId;
  final String customerName;
  final String timeAgo;
  final String deliveryTime;
  final List<String> tags;
  final String status;
  final bool isUrgent;
  final bool requiresPrescription;

  const OrderCardWidget({
    super.key,
    required this.orderId,
    required this.customerName,
    required this.timeAgo,
    required this.deliveryTime,
    required this.tags,
    required this.status,
    required this.isUrgent,
    required this.requiresPrescription,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderManagementController>();
    return GestureDetector(
      onTap: () => controller.navigateToOrderDetails(orderId),
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  orderId,
                  style: getTextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                Text(
                  timeAgo,
                  style: getTextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Status Badges
            // Wrap(
            //   spacing: 8,
            //   runSpacing: 8,
            //   children: tags
            //       .map(
            //         (tag) => OrderStatusBadgeWidget(tag: tag, status: status),
            //       )
            //       .toList(),
            // ),
            // SizedBox(height: 16),

            // Customer Info
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Color(0xFF111827),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person, color: Colors.white, size: 12),
                ),
                SizedBox(width: 12),
                Text(
                  customerName,
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Delivery Time
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Color(0xFF111827),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.access_time, color: Colors.white, size: 12),
                ),
                SizedBox(width: 12),
                Text(
                  deliveryTime,
                  style: getTextStyle(fontSize: 16, color: Color(0xFF111827)),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Action Buttons
            OrderActionButtonsWidget(
              orderId: orderId,
              status: status,
              requiresPrescription: requiresPrescription,
            ),
          ],
        ),
      ),
    );
  }
}
