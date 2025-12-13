import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/common/widgets/custom_button.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import '../../../core/common/styles/global_text_style.dart';
import '../controller/home_controller.dart';
import 'package:quikle_vendor/features/order_management/controller/order_management_controller.dart';
import 'new_order_card_widget.dart';
import 'ongoing_delivery_card_widget.dart';
import 'package:quikle_vendor/core/widgets/shimmer_widget.dart';

class OrdersOverviewWidget extends StatelessWidget {
  const OrdersOverviewWidget({super.key});

  List<Map<String, dynamic>> _getNewOrders() {
    try {
      // Use Get.isRegistered to safely check before accessing
      if (!Get.isRegistered<OrderManagementController>()) {
        return [];
      }
      final omc = Get.find<OrderManagementController>();
      return omc.allOrders.where((o) => o['status'] == 'new').take(3).toList();
    } catch (_) {
      return [];
    }
  }

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
              Obx(() {
                if (!Get.isRegistered<OrderManagementController>()) {
                  return Row(
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
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Text(
                          '0',
                          style: getTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                }
                final omc = Get.find<OrderManagementController>();
                final newOrderCount = omc.allOrders
                    .where((o) => o['status'] == 'new')
                    .length;
                return Row(
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
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Text(
                        '$newOrderCount',
                        style: getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 8),
              Obx(() {
                final newOrders = _getNewOrders();
                if (newOrders.isEmpty) {
                  // show shimmer placeholders while the 'processing' status is loading
                  final omc = Get.find<OrderManagementController>();
                  if (omc.isStatusLoading('processing')) {
                    return Column(
                      children: List.generate(
                        2,
                        (_) => const NewOrderShimmer(),
                      ),
                    );
                  }
                }
                return Column(
                  children: newOrders.map((order) {
                    // Normalize items into a short string for the overview card
                    final rawItems = order['items'];
                    String itemsText;
                    if (rawItems is String) {
                      itemsText = rawItems;
                    } else if (rawItems is List) {
                      // prefer a concise summary like "2 items"
                      itemsText = '${rawItems.length} items';
                    } else {
                      itemsText = rawItems?.toString() ?? '';
                    }
                    return NewOrderCardWidget(
                      orderId: order['id']!,
                      items: itemsText,
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
        // const SizedBox(height: 20),

        // Container(
        //   width: double.infinity,
        //   padding: const EdgeInsets.all(16),
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(10),
        //     color: Colors.white, // Light gray instead of amber to match image
        //     border: Border.all(color: const Color(0xFFE5E7EB)),
        //   ),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Row(
        //         children: [
        //           Text(
        //             'Ongoing Deliveries',
        //             style: getTextStyle(
        //               fontSize: 16,
        //               fontWeight: FontWeight.w600,
        //               color: Color(0xFF111827),
        //             ),
        //           ),
        //           Spacer(),
        //           Obx(
        //             () => Container(
        //               padding: const EdgeInsets.all(6),
        //               decoration: BoxDecoration(
        //                 color: AppColors.warning,
        //                 borderRadius: BorderRadius.circular(22),
        //               ),
        //               child: Text(
        //                 '${controller.ongoingDeliveries.length}',
        //                 style: getTextStyle(
        //                   fontSize: 12,
        //                   fontWeight: FontWeight.w600,
        //                   color: Colors.white,
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //       SizedBox(height: 12),
        //       Obx(
        //         () => Column(
        //           children: controller.ongoingDeliveries
        //               .map(
        //                 (delivery) => OngoingDeliveryCardWidget(
        //                   orderId: delivery['id']!,
        //                   status: delivery['status']!,
        //                 ),
        //               )
        //               .toList(),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // const SizedBox(height: 8),

        // Order cards (now properly in a vertical Column)
        SizedBox(height: 20),

        CustomButton(
          text: 'View All Orders',
          backgroundColor: Colors.black,
          textColor: Colors.white,
          onPressed: controller.viewAllOrders,
        ),
      ],
    );
  }
}
