import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import 'package:quikle_vendor/core/widgets/shimmer_widget.dart';
import 'package:quikle_vendor/features/order_management/widget/list/order_card_widget.dart';
import '../../appbar/screen/appbar_screen.dart';
import '../controller/order_management_controller.dart';
import '../widget/list/orders_tab_navigation_widget.dart';

class OrderManagementScreen extends StatelessWidget {
  const OrderManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderManagementController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppbarScreen(title: "Order Management"),
      body: SafeArea(
        child: Column(
          children: [
            OrdersTabNavigationWidget(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  // Show a list of ShimmerOrderCard placeholders while orders load
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 6,
                    itemBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: ShimmerOrderCard(),
                    ),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Text(
                      controller.errorMessage.value,
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final orders = controller.filteredOrders;
                if (orders.isEmpty) {
                  return const Center(child: Text("No orders found"));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
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
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
