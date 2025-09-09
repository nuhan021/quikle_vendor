import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/common/widgets/custom_button.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import '../../../core/common/styles/global_text_style.dart';
import '../controller/home_controller.dart';
import 'new_order_card_widget.dart';
import 'ongoing_delivery_card_widget.dart';

class OrdersOverviewWidget extends StatelessWidget {
  const OrdersOverviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.receipt_outlined, size: 20),
            SizedBox(width: 8),
            Text(
              'Orders Overview',
              style: getTextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),

        // New Orders Section
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white, // Light gray instead of amber to match image
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'New Orders',
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                  ),
                  Spacer(),
                  Obx(
                    () => Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Text(
                        '${controller.newOrders.length}',
                        style: getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Order cards (now properly in a vertical Column)
              Obx(
                () => Column(
                  children: controller.newOrders
                      .map(
                        (order) => NewOrderCardWidget(
                          orderId: order['id']!,
                          items: order['items']!,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white, // Light gray instead of amber to match image
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Ongoing Deliveries',
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                  ),
                  Spacer(),
                  Obx(
                    () => Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.warning,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Text(
                        '${controller.ongoingDeliveries.length}',
                        style: getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Obx(
                () => Column(
                  children: controller.ongoingDeliveries
                      .map(
                        (delivery) => OngoingDeliveryCardWidget(
                          orderId: delivery['id']!,
                          status: delivery['status']!,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Order cards (now properly in a vertical Column)
        SizedBox(height: 20),

        CustomButton(
          text: 'View All Orders',
          onPressed: controller.viewAllOrders,
        ),
      ],
    );
  }
}
