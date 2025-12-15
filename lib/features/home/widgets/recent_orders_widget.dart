import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import '../../../core/common/styles/global_text_style.dart';
import '../controller/home_controller.dart';
import 'package:quikle_vendor/features/order_management/controller/order_management_controller.dart';
import 'recent_order_card_widget.dart';
import 'package:quikle_vendor/core/widgets/shimmer_widget.dart';

class RecentOrdersWidget extends StatelessWidget {
  const RecentOrdersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.history, size: 20, color: Color(0xFF111827)),
                SizedBox(width: 8),
                Text(
                  'Recent Orders',
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: controller.seeAllRecentOrders,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  'See All',
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.backgroundDark,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Obx(() {
          final omc = Get.find<OrderManagementController>();

          // Use the controller's reactive recentOrdersCache (first shipped, first delivered)
          final cached = omc.recentOrdersCache;

          // If cache doesn't have both items yet, request them. Controller will no-op if already cached/ loading.
          if (cached.length < 1) omc.fetchOrdersForApiStatus('shipped');
          if (cached.length < 2) omc.fetchOrdersForApiStatus('delivered');

          // Build a display list of exactly two slots: [shipped, delivered]
          final List<Map<String, dynamic>> displayOrders = [];
          if (cached.isNotEmpty)
            displayOrders.addAll(
              cached.map((e) => Map<String, dynamic>.from(e)),
            );
          // pad with empty maps to keep two slots
          while (displayOrders.length < 2) {
            displayOrders.add({});
          }

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              children: List.generate(displayOrders.length, (index) {
                final order = displayOrders[index];

                if (order.isEmpty) {
                  final widget = const RecentOrderShimmer();
                  if (index < displayOrders.length - 1) {
                    return Column(children: [widget, SizedBox(height: 16)]);
                  }
                  return widget;
                }

                final rawOrderId =
                    order['order_id'] ?? order['id'] ?? order['orderId'];
                final customer = rawOrderId is String
                    ? rawOrderId
                    : (rawOrderId != null ? rawOrderId.toString() : '');

                String items;
                final rawItems = order['items'];
                if (rawItems is String) {
                  items = rawItems;
                } else if (rawItems is List) {
                  items = '${rawItems.length} items';
                } else {
                  final itemsList = order['items_list'];
                  if (itemsList is List) {
                    items = '${itemsList.length} items';
                  } else {
                    items = '0 items';
                  }
                }

                String amount;
                final rawTotal = order['total'] ?? order['subtotal'];
                if (rawTotal is num) {
                  amount = '\$${rawTotal.toString()}';
                } else if (rawTotal is String) {
                  amount = rawTotal.startsWith('\$')
                      ? rawTotal
                      : '\$' + rawTotal;
                } else {
                  amount = '\$0';
                }

                final time = order['created_at'] is String
                    ? order['created_at'] as String
                    : (order['time'] is String ? order['time'] as String : '');

                final status = order['status'] is String
                    ? order['status'] as String
                    : (order['apiStatus'] is String
                          ? order['apiStatus'] as String
                          : 'Unknown');

                Color statusColor = const Color(0xFF6B7280);
                final sc = order['statusColor'];
                if (sc is int) {
                  statusColor = Color(sc);
                } else if (sc is Color) {
                  statusColor = sc;
                } else {
                  final sl = status.toLowerCase();
                  if (sl.contains('in-progress') ||
                      sl.contains('in progress') ||
                      sl.contains('processing') ||
                      sl.contains('shipped')) {
                    statusColor = Colors.amber;
                  } else if (sl.contains('delivered') ||
                      sl.contains('completed') ||
                      sl.contains('complete')) {
                    statusColor = Colors.green;
                  }
                }

                final card = RecentOrderCardWidget(
                  customer: customer,
                  items: items,
                  amount: amount,
                  time: time,
                  status: status,
                  statusColor: statusColor,
                );

                if (index < displayOrders.length - 1) {
                  return Column(children: [card, SizedBox(height: 16)]);
                }
                return card;
              }),
            ),
          );
        }),
      ],
    );
  }
}
