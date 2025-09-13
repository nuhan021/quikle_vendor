import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/features/home/controller/rider_assignment_controller.dart';
import 'package:quikle_vendor/routes/app_routes.dart';

class HomeController extends GetxController {
  var selectedTab = 0.obs;
  var isShopOpen = true.obs;
  var riderAssignController = RiderAssignmentController();

  // New Orders Data
  var newOrders = [
    {'id': '#12345', 'items': '2 Pizza, 1 Coke'},
    {'id': '#12345', 'items': '1 Pizza, 1 Coke'},
  ].obs;

  // Ongoing Deliveries Data
  var ongoingDeliveries = [
    {'id': '#12345', 'status': 'On the Way'},
    {'id': '#12339', 'status': 'On the Way'},
  ].obs;

  // Pending Actions Data
  var pendingActions = [
    {
      'title': 'Update Inventory',
      'subtitle': '3 items low in stock',
      'buttonText': 'Update',
      'buttonColor': Color(0xFFEF4444),
    },
    {
      'title': 'Assign Rider',
      'subtitle': 'Order #12344 ready for pickup',
      'buttonText': 'Assign',
      'buttonColor': Color(0xFFEF4444),
    },
  ].obs;

  // Recent Orders Data
  var recentOrders = [
    {
      'customer': 'Rahul M.',
      'items': '3 items',
      'amount': '\$5.50',
      'time': '15 mins ago',
      'status': 'Delivered',
      'statusColor': Color(0xFF10B981),
    },
    {
      'customer': 'Priya S.',
      'items': '3 items',
      'amount': '\$5.50',
      'time': '15 mins ago',
      'status': 'Processing',
      'statusColor': Color(0xFFF59E0B),
    },
  ].obs;

  void navigateDashboard(String name) {
    switch (name) {
      case 'Orders':
        Get.toNamed(AppRoute.orderManagementScreen);
        break;
      case 'Products':
        Get.toNamed(AppRoute.productManagementScreen);
        break;
      case 'Earnings':
        Get.toNamed(AppRoute.earningsScreen);
        break;
      default:
        debugPrint('Invalid navigation: $name');
        break;
    }
  }

  void toggleRestaurantStatus() {
    isShopOpen.value = !isShopOpen.value;
    Get.snackbar(
      'Restaurant Status',
      isShopOpen.value ? 'Open' : 'Closed',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isShopOpen.value ? Color(0xFF10B981) : Color(0xFFEF4444),
      colorText: Colors.white,
    );
  }

  void acceptOrder(String orderId) {
    Get.snackbar(
      'Order Accepted',
      'Order $orderId has been accepted',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF10B981),
      colorText: Colors.white,
    );
  }

  void viewAllOrders() {
    Get.toNamed(AppRoute.orderManagementScreen);
  }

  void updateInventory() {
    Get.toNamed(AppRoute.productManagementScreen);
  }

  void assignRider() {
    riderAssignController.currentDialogState.value = 'initial';
  }

  void seeAllRecentOrders() {
    Get.toNamed(AppRoute.orderManagementScreen);
  }

  @override
  void onInit() {
    super.onInit();
    riderAssignController = Get.put(RiderAssignmentController());
  }
}
