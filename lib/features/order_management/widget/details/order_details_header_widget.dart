import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../list/order_status_badge_widget.dart';

class OrderDetailsHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const OrderDetailsHeaderWidget({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order ${orderData['id']}',
                style: getTextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Status Badges
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (orderData['tags'] as List<String>)
                .map(
                  (tag) => OrderStatusBadgeWidget(
                    tag: tag,
                    status: orderData['status'],
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 16),

          // Estimated Delivery Time
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Estimated Delivery Time : ',
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                TextSpan(
                  text: orderData['estimatedDelivery'],
                  style: getTextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
