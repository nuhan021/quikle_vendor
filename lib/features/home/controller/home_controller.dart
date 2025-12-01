import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/features/home/controller/rider_assignment_controller.dart';
import 'package:quikle_vendor/features/home/services/home_service.dart';
import 'package:quikle_vendor/features/navbar/controller/navbar_controller.dart';
import 'package:quikle_vendor/routes/app_routes.dart';

class HomeController extends GetxController {
  final controller = Get.find<NavbarController>();
  final _homeService = HomeService();
  var selectedTab = 0.obs;
  var isShopOpen = true.obs;
  var isTogglingStatus = false.obs;
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
        // Get.toNamed(AppRoute.orderManagementScreen);
        controller.changeTab(1);
        break;
      case 'Products':
        //Get.toNamed(AppRoute.productManagementScreen);
        controller.changeTab(3);
        break;
      case 'Earnings':
        // Get.toNamed(AppRoute.earningsScreen);
        controller.changeTab(2);
        break;
      default:
        debugPrint('Invalid navigation: $name');
        break;
    }
  }

  Future<void> toggleRestaurantStatus() async {
    if (isTogglingStatus.value) return; // Prevent multiple requests

    try {
      isTogglingStatus.value = true;
      debugPrint('🔄 Toggling restaurant status...');
      final response = await _homeService.toggleActiveStatus();
      debugPrint(
        '✅ API Response: Success=${response.isSuccess}, Message=${response.errorMessage}',
      );

      if (response.isSuccess) {
        isShopOpen.value = !isShopOpen.value;
        Get.snackbar(
          'Restaurant Status',
          isShopOpen.value
              ? 'Restaurant is now Open'
              : 'Restaurant is now Closed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: isShopOpen.value
              ? Color(0xFF10B981)
              : Color(0xFFEF4444),
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to update restaurant status',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color(0xFFEF4444),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('❌ Error toggling status: $e');
      Get.snackbar(
        'Error',
        'Something went wrong: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFFEF4444),
        colorText: Colors.white,
      );
    } finally {
      isTogglingStatus.value = false;
      debugPrint('✨ Toggle complete, isTogglingStatus set to false');
    }
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
