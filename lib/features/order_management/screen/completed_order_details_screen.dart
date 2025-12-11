import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import '../../appbar/screen/appbar_screen.dart';
import '../controller/order_details_controller.dart';
import '../widget/details/order_details_header_widget.dart';
import '../widget/details/order_details_items_widget.dart';
import '../widget/details/order_details_actions_widget.dart';

class CompletedOrderDetailsScreen extends StatelessWidget {
  const CompletedOrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderDetailsController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppbarScreen(title: "Order Details"),
      body: SafeArea(
        child: Obx(() {
          final order = controller.orderData.value;
          if (order == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 Header (fully data-driven)
                OrderDetailsHeaderWidget(
                  orderId: order['id'],
                  status: order['status'],
                  tags: List<String>.from(order['tags']),
                  estimatedDelivery: order['estimatedDelivery'],
                ),
                const SizedBox(height: 10),

                /// 🔹 Order Items (fully reusable)
                OrderDetailsItemsWidget(
                  items: List<Map<String, dynamic>>.from(order['items']),
                  total: order['total'],
                  specialInstructions: order['specialInstructions'],
                ),
                const SizedBox(height: 20),

                /// 🔹 Customer Info
                // OrderDetailsCustomerInfoWidget(
                //   name: order['customerName'],
                //   deliveryTime: order['deliveryTime'],
                //   address: order['address'],
                // ),
                // const SizedBox(height: 30),

                /// 🔹 Actions — button callbacks come from controller
                OrderDetailsActionsWidget(
                  orderId: order['id'],
                  status: order['status'],
                  requiresPrescription: order['requiresPrescription'],
                  onConfirm: controller.confirmOrder,
                  onReject: controller.rejectOrder,
                  onReview: controller.reviewOrder,
                  onPrepared: controller.markAsPrepared,
                  onShipped: controller.markAsShipped,
                  onViewPrescription: controller.viewPrescription,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
