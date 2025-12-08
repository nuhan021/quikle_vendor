import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/features/home/controller/rider_assignment_controller.dart';
import 'package:quikle_vendor/features/home/services/home_services.dart';
import 'package:quikle_vendor/features/navbar/controller/navbar_controller.dart';
import 'package:quikle_vendor/routes/app_routes.dart';

import '../../../core/services/storage_service.dart';

class HomeController extends GetxController {
  final controller = Get.find<NavbarController>();
  var selectedTab = 0.obs;
  var isShopOpen = false.obs;
  var riderAssignController = RiderAssignmentController();
  late final HomeServices _homeServices;

  @override
  void onInit() {
    super.onInit();
    _homeServices = Get.put(HomeServices());
    Get.put(RiderAssignmentController());
    loadShopStatus();
  }

  void loadShopStatus() {
    final vendorData = StorageService.getVendorDetails();
    if (vendorData != null) {
      final isActive = vendorData['is_active'] as bool? ?? false;
      isShopOpen.value = isActive;
      log('Shop status loaded from vendor details: $isActive');
    }
  }

  void toggleShopStatus() async {
    final response = await _homeServices.toggleActiveStatus();

    if (response.isSuccess) {
      bool newStatus = response.responseData["status"];
      log('Shop status updated: $newStatus');
      isShopOpen.value = newStatus;
      // Update vendor details with new status
      final vendorData = StorageService.getVendorDetails();
      if (vendorData != null) {
        vendorData['is_active'] = newStatus;
        await StorageService.saveVendorDetails(vendorData);
      }
    } else {
      log('Error: ${response.errorMessage}');
    }
  }

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

  void toggleRestaurantStatus() {
    isShopOpen.value = !isShopOpen.value;
  }

  void acceptOrder(String orderId) {}

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

  // @override
  // void onInit() {
  //   super.onInit();
  //   riderAssignController = Get.put(RiderAssignmentController());
  // }
}
