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

  var vendorPhotoUrl = Rx<String?>(null);
  var vendorOwnerName = Rx<String?>(null);
  var vendorCloseTime = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    _homeServices = Get.put(HomeServices());
    Get.put(RiderAssignmentController());
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

  void loadVendorData() {
    final vendorData = StorageService.getVendorDetails();
    if (vendorData != null) {
      final isActive = vendorData['is_active'] as bool? ?? false;
      isShopOpen.value = isActive;
      vendorPhotoUrl.value = vendorData['photo'] as String?;
      vendorOwnerName.value = vendorData['owner_name'] as String?;
      vendorCloseTime.value = vendorData['close_time'] as String?;
      log('Vendor data reloaded from SharedPreferences');
      log('Updated photo URL: ${vendorPhotoUrl.value}');
      log('Updated owner name: ${vendorOwnerName.value}');
      log('Updated close time: ${vendorCloseTime.value}');
      update();
    }
  }

  void toggleShopStatus() async {
    final response = await _homeServices.toggleActiveStatus();

    if (response.isSuccess) {
      bool newStatus = response.responseData["status"];
      log('Shop status updated: $newStatus');
      isShopOpen.value = newStatus;
      final vendorData = StorageService.getVendorDetails();
      if (vendorData != null) {
        vendorData['is_active'] = newStatus;
        await StorageService.saveVendorDetails(vendorData);
      }
    } else {
      log('Error: ${response.errorMessage}');
    }
  }

  List<Map<String, dynamic>> get newOrders {
    try {
      final omc = Get.find<OrderManagementController>();
      return omc.allOrders.where((o) => o['status'] == 'new').toList();
    } catch (_) {
      return <Map<String, dynamic>>[];
    }
  }

  var ongoingDeliveries = [
    {'id': '#12345', 'status': 'On the Way'},
    {'id': '#12339', 'status': 'On the Way'},
  ].obs;

  var pendingActions = <Map<String, dynamic>>[].obs;

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
        controller.changeTab(1);
        break;
      case 'Products':
        controller.changeTab(3);
        break;
      case 'Earnings':
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
    controller.changeTab(3);
  }

  void assignRider() {
    riderAssignController.currentDialogState.value = 'initial';
  }

  void seeAllRecentOrders() {
    Get.toNamed(AppRoute.orderManagementScreen);
  }

 
}
