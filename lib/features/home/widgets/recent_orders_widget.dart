import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import '../../../core/common/styles/global_text_style.dart';
import '../controller/home_controller.dart';
import 'recent_order_card_widget.dart';

class RecentOrdersWidget extends StatelessWidget {
  const RecentOrdersWidget({super.key});

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
                  style: getTextStyle(
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
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.backgroundDark,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Obx(
          () => Container(
            padding: const EdgeInsets.all(16),

            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
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
        ),
      ],
    );
  }
}
