import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import 'new_order_card_widget.dart';
import 'ongoing_delivery_card_widget.dart';

class OrdersOverviewWidget extends StatelessWidget {
  OrdersOverviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.receipt_long, size: 20, color: Color(0xFF111827)),
            SizedBox(width: 8),
            Text(
              'Orders Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),

        // New Orders Section
        Text(
          'New Orders',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
        SizedBox(height: 8),
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

        SizedBox(height: 20),

        // Ongoing Deliveries Section
        Text(
          'Ongoing Deliveries',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
        SizedBox(height: 8),
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

        SizedBox(height: 20),

        // View All Orders Button
        GestureDetector(
          onTap: controller.viewAllOrders,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Color(0xFF111827),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'View All Orders',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
