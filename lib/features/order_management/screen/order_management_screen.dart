import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import 'package:quikle_vendor/features/profile/my_profile/controller/my_profile_controller.dart';
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

    // Safe access to MyProfileController
    final myProfileController = Get.isRegistered<MyProfileController>()
        ? Get.find<MyProfileController>()
        : null;

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
            // Show warning if features are disabled
            if (myProfileController != null)
              Obx(
                () => myProfileController.shouldDisableFeatures.value
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          myProfileController.kycStatusMessage.value.isNotEmpty
                              ? myProfileController.kycStatusMessage.value
                              : 'Verify KYC to view orders',
                          style: TextStyle(
                            color: Colors.red.shade900,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : SizedBox.shrink(),
              ),
            OrdersTabNavigationWidget(),
            // Show prescription orders widget only for medicine vendors in "New" tab
            Obx(() {
              if (controller.selectedTab.value == 0 && isMedicineVendor) {
                return GestureDetector(
                  onTap:
                      (myProfileController?.shouldDisableFeatures.value ??
                          false)
                      ? null
                      : () {
                          Get.to(() => PrescriptionListScreen());
                        },
                  child: Opacity(
                    opacity:
                        (myProfileController?.shouldDisableFeatures.value ??
                            false)
                        ? 0.5
                        : 1.0,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                        bottom: 8,
                      ),
                      child: PrescriptionOrdersWidget(pendingCount: 5),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if ((myProfileController?.shouldDisableFeatures.value ??
                    false)) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        myProfileController != null &&
                                myProfileController
                                    .kycStatusMessage
                                    .value
                                    .isNotEmpty
                            ? myProfileController.kycStatusMessage.value
                            : 'Verify KYC to view orders',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
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
