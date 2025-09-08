import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/constants/icon_path.dart';

import '../controller/home_controller.dart';
import 'dashboard_card_widget.dart';

class DashboardOptions extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();

  DashboardOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          DashboardCardWidget(
            title: 'Orders',
            image: IconPath.orderDashboard,
            controller: controller,
          ),
          DashboardCardWidget(
            title: 'Products',
            image: IconPath.productDashboard,
            controller: controller,
          ),
          DashboardCardWidget(
            title: 'Earnings',
            image: IconPath.earningDashboard,
            controller: controller,
          ),
        ],
      ),
    );
  }
}
