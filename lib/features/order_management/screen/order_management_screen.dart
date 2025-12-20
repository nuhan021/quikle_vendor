import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import 'package:quikle_vendor/core/widgets/shimmer_widget.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import 'package:quikle_vendor/features/order_management/prescription_order_management/presentation/screens/prescription_list_screen.dart';
import 'package:quikle_vendor/features/order_management/prescription_order_management/presentation/widget/prescription_order_widget.dart';
import 'package:quikle_vendor/features/order_management/widget/list/order_card_widget.dart';
import '../../appbar/screen/appbar_screen.dart';
import '../controller/order_management_controller.dart';
import '../widget/list/orders_tab_navigation_widget.dart';

class OrderManagementScreen extends StatelessWidget {
  const OrderManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderManagementController());

    // Get vendor type from StorageService
    final vendorData = StorageService.getVendorDetails();
    final vendorType = vendorData?['type'] as String? ?? '';
    final isMedicineVendor = vendorType.toLowerCase() == 'medicine';

    print(
      'DEBUG ORDER_MANAGEMENT: Vendor Type = "$vendorType", Is Medicine = $isMedicineVendor',
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppbarScreen(title: "Order Management"),
      body: SafeArea(
        child: Column(
          children: [
            OrdersTabNavigationWidget(),
            // Show prescription orders widget only for medicine vendors in "New" tab
            Obx(() {
              if (controller.selectedTab.value == 0 && isMedicineVendor) {
                return GestureDetector(
                  onTap: () {
                    Get.to(() => PrescriptionListScreen());
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 16,
                      bottom: 8,
                    ),
                    child: PrescriptionOrdersWidget(pendingCount: 5),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            Expanded(
              child: Obx(() {
                // Pull-to-refresh should refresh only the currently selected tab's data
                Future<void> _onRefresh() async {
                  final apiStatus = controller.apiStatusForTabIndex(
                    controller.selectedTab.value,
                  );
                  // Force a refresh even if cache exists so API is hit and shimmer shows
                  await controller.fetchOrdersForApiStatus(
                    apiStatus,
                    force: true,
                  );
                }

                if (controller.isLoading.value) {
                  // Show a list of ShimmerOrderCard placeholders while orders load
                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    backgroundColor: Colors.white,
                    color: Colors.amber,
                    displacement:
                        kToolbarHeight +
                        MediaQuery.of(context).padding.top +
                        8.0,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: 6,
                      itemBuilder: (context, index) => const Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: ShimmerOrderCard(),
                      ),
                    ),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    backgroundColor: Colors.white,
                    color: Colors.amber,
                    displacement:
                        kToolbarHeight +
                        MediaQuery.of(context).padding.top +
                        8.0,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      children: [
                        Center(
                          child: Text(
                            controller.errorMessage.value,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final orders = controller.filteredOrders;
                if (orders.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    backgroundColor: Colors.white,
                    color: Colors.amber,
                    displacement:
                        kToolbarHeight +
                        MediaQuery.of(context).padding.top +
                        8.0,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      children: const [Center(child: Text("No orders found"))],
                    ),
                  );
                }
                return RefreshIndicator(
                  color: AppColors.beakYellow,
                  onRefresh: () => controller.fetchOrders(),
                  child: ListView.builder(
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
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
