import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common/styles/global_text_style.dart';
import '../controller/order_management_controller.dart';

class OrdersTabNavigationWidget extends StatelessWidget {
  OrdersTabNavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderManagementController>();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
      ),
      child: Row(
        children: List.generate(controller.tabs.length, (index) {
          return Expanded(
            child: Obx(
              () => GestureDetector(
                onTap: () => controller.changeTab(index),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: controller.selectedTab.value == index
                            ? Color(0xFF111827)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    controller.tabs[index],
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: controller.selectedTab.value == index
                          ? Color(0xFF111827)
                          : Color(0xFF9CA3AF),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
