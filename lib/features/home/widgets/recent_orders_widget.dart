import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import 'recent_order_card_widget.dart';

class RecentOrdersWidget extends StatelessWidget {
  RecentOrdersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.history, size: 20, color: Color(0xFF111827)),
                SizedBox(width: 8),
                Text(
                  'Recent Orders',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: controller.seeAllRecentOrders,
              child: Text(
                'See All',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6366F1),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Obx(
          () => Column(
            children: controller.recentOrders
                .map(
                  (order) => RecentOrderCardWidget(
                    customer: order['customer'] as String,
                    items: order['items'] as String,
                    amount: order['amount'] as String,
                    time: order['time'] as String,
                    status: order['status'] as String,
                    statusColor: order['statusColor'] as Color,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
