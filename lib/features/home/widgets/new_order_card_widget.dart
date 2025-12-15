import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/common/styles/global_text_style.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import 'package:quikle_vendor/features/home/controller/home_controller.dart';

class NewOrderCardWidget extends StatelessWidget {
  final String orderId;
  final String items;

  const NewOrderCardWidget({
    super.key,
    required this.orderId,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderId,
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                Text(
                  items,
                  style: getTextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => controller.viewOrder(orderId),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFF111827),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'View Order',
                style: getTextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
