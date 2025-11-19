import 'package:flutter/material.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../list/order_status_badge_widget.dart';

class OrderDetailsHeaderWidget extends StatelessWidget {
  final String orderId;
  final String status;
  final List<String> tags;
  final String estimatedDelivery;

  const OrderDetailsHeaderWidget({
    super.key,
    required this.orderId,
    required this.status,
    required this.tags,
    required this.estimatedDelivery,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Order ID
          Text(
            'Order $orderId',
            style: getTextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 16),

          /// 🔹 Tags / Status Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags
                .map((tag) => OrderStatusBadgeWidget(tag: tag, status: status))
                .toList(),
          ),
          const SizedBox(height: 16),

          /// 🔹 Estimated Delivery
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Estimated Delivery Time: ",
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                ),
                TextSpan(
                  text: estimatedDelivery,
                  style: getTextStyle(
                    fontSize: 16,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
