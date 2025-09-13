import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import '../../appbar/screen/appbar_screen.dart';
import '../controller/order_management_controller.dart';
import '../widget/list/orders_list_widget.dart';
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
            Expanded(child: OrdersListWidget()),
          ],
        ),
      ),
    );
  }
}
