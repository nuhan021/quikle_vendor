import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/features/home/controller/rider_assignment_controller.dart';
import 'package:quikle_vendor/features/home/services/home_services.dart';
import 'package:quikle_vendor/features/navbar/controller/navbar_controller.dart';
import 'package:quikle_vendor/routes/app_routes.dart';
import 'package:quikle_vendor/features/order_management/controller/order_management_controller.dart';

import '../../../core/services/storage_service.dart';

class HomeController extends GetxController {
  final controller = Get.find<NavbarController>();
  var selectedTab = 0.obs;
  var isShopOpen = false.obs;
  var riderAssignController = RiderAssignmentController();
  late final HomeServices _homeServices;

  // Reactive vendor data - will trigger UI updates when changed
  var vendorPhotoUrl = Rx<String?>(null);
  var vendorOwnerName = Rx<String?>(null);
  var vendorCloseTime = Rx<String?>(null);
  var imageUpdateTimestamp = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _homeServices = Get.put(HomeServices());
    Get.put(RiderAssignmentController());
    // Initialize OrderManagementController early so OrdersOverviewWidget can access it
    Get.put(OrderManagementController());
    loadShopStatus();
  }

  void loadShopStatus() {
    final vendorData = StorageService.getVendorDetails();
    if (vendorData != null) {
      final isActive = vendorData['is_active'] as bool? ?? false;
      isShopOpen.value = isActive;
      vendorPhotoUrl.value = vendorData['photo'] as String?;
      vendorOwnerName.value = vendorData['owner_name'] as String?;
      vendorCloseTime.value = vendorData['close_time'] as String?;
      log('Shop status loaded from vendor details: $isActive');
    }
  }

  /// Reload vendor data from SharedPreferences to trigger UI updates
  void loadVendorData() {
    final vendorData = StorageService.getVendorDetails();
    if (vendorData != null) {
      final isActive = vendorData['is_active'] as bool? ?? false;
      isShopOpen.value = isActive;
      final newPhotoUrl = vendorData['photo'] as String?;
      if (newPhotoUrl != vendorPhotoUrl.value) {
        vendorPhotoUrl.value = newPhotoUrl;
        imageUpdateTimestamp.value = DateTime.now().millisecondsSinceEpoch;
      }
      vendorOwnerName.value = vendorData['owner_name'] as String?;
      vendorCloseTime.value = vendorData['close_time'] as String?;
      log('Vendor data reloaded from SharedPreferences');
      log('Updated photo URL: ${vendorPhotoUrl.value}');
      log('Updated timestamp: ${imageUpdateTimestamp.value}');
      log('Updated owner name: ${vendorOwnerName.value}');
      log('Updated close time: ${vendorCloseTime.value}');
      // Force rebuild by updating a dummy observable
      update();
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

  // New Orders Data (sourced from OrderManagementController)
  List<Map<String, dynamic>> get newOrders {
    try {
      final omc = Get.find<OrderManagementController>();
      return omc.allOrders.where((o) => o['status'] == 'new').toList();
    } catch (_) {
      return <Map<String, dynamic>>[];
    }
  }

  // Ongoing Deliveries Data
  var ongoingDeliveries = [
    // {'id': '#12345', 'status': 'On the Way'},
    // {'id': '#12339', 'status': 'On the Way'},
  ].obs;

  // Pending Actions Data
  var pendingActions = <Map<String, dynamic>>[].obs;

  // Recent Orders Data
  var recentOrders = [
    // {
    //   'customer': 'Rahul M.',
    //   'items': '3 items',
    //   'amount': '\$5.50',
    //   'time': '15 mins ago',
    //   'status': 'Delivered',
    //   'statusColor': Color(0xFF10B981),
    // },
    // {
    //   'customer': 'Priya S.',
    //   'items': '3 items',
    //   'amount': '\$5.50',
    //   'time': '15 mins ago',
    //   'status': 'Processing',
    //   'statusColor': Color(0xFFF59E0B),
    // },
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

  void confirmOrder(String orderId) {}

  void viewOrder(String orderId) {
    Get.toNamed(AppRoute.completedOrderDetailsScreen, arguments: orderId);
  }

  void viewAllOrders() {
    Get.toNamed(AppRoute.orderManagementScreen);
  }

  void updateInventory() {
    // Navigate via the navbar controller to the Product Management tab
    // (keeps navigation consistent with other dashboard shortcuts)
    controller.changeTab(3);
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
