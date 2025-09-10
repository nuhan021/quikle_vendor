import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/order_management_controller.dart';
import 'order_card_widget.dart';

class OrdersListWidget extends StatelessWidget {
  OrdersListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderManagementController>();

    return Obx(
      () => ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: controller.filteredOrders.length,
        itemBuilder: (context, index) {
          final order = controller.filteredOrders[index];
          return OrderCardWidget(
            orderId: order['id']!,
            customerName: order['customerName']!,
            timeAgo: order['timeAgo']!,
            deliveryTime: order['deliveryTime']!,
            tags: List<String>.from(order['tags']),
            status: order['status']!,
            isUrgent: order['isUrgent']!,
            requiresPrescription: order['requiresPrescription']!,
          );
        },
      ),
    );
  }
}
