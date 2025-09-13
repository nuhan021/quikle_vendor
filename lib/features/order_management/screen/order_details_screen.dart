import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/constants/colors.dart';
import '../../appbar/screen/appbar_screen.dart';
import '../controller/order_management_controller.dart';
import '../widget/details/order_details_content_widget.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String orderId = Get.arguments ?? '';
    final controller = Get.find<OrderManagementController>();
    final orderData = controller.getOrderById(orderId);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppbarScreen(title: "Order Details"),
      body: SafeArea(child: OrderDetailsContentWidget(orderData: orderData!)),
    );
  }
}
