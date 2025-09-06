import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'vendor_controller.dart';
import 'orders_controller.dart';
import 'actions_controller.dart';

/// Main Home Controller that coordinates other controllers
class HomeController extends GetxController {
  // Loading state for the entire home screen
  var isLoading = false.obs;

  // Initialize sub-controllers
  late VendorController vendorController;
  late OrdersController ordersController;
  late ActionsController actionsController;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    loadHomeData();
  }

  @override
  void onClose() {
    // Clean up controllers if needed
    super.onClose();
  }

  /// Initialize all sub-controllers
  void _initializeControllers() {
    vendorController = Get.put(VendorController());
    ordersController = Get.put(OrdersController());
    actionsController = Get.put(ActionsController());
  }

  /// Load all home screen data
  Future<void> loadHomeData() async {
    try {
      isLoading.value = true;

      // Load data from all controllers in parallel
      await Future.wait([
        vendorController.loadVendorData(),
        ordersController.loadOrders(),
        ordersController.loadRecentOrders(),
        actionsController.loadPendingActions(),
      ]);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to load home screen data: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFF44336),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh all home screen data
  Future<void> refreshHomeData() async {
    await loadHomeData();
  }

  /// Quick access methods for convenience

  // Vendor related
  bool get isVendorOpen => vendorController.isVendorOpen.value;
  String get vendorName => vendorController.vendorName.value;
  String get totalOrders => vendorController.totalOrders.value;
  String get totalProducts => vendorController.totalProducts.value;
  String get totalEarnings => vendorController.totalEarnings.value;

  void toggleVendorStatus() => vendorController.toggleVendorStatus();

  // Orders related
  get newOrders => ordersController.newOrders;
  get ongoingOrders => ordersController.ongoingOrders;
  get recentOrders => ordersController.recentOrders;

  Future<void> acceptOrder(String orderId) =>
      ordersController.acceptOrder(orderId);
  Future<void> rejectOrder(String orderId) =>
      ordersController.rejectOrder(orderId);

  // Actions related
  get pendingActions => actionsController.pendingActions;
  int get highPriorityActionsCount =>
      actionsController.highPriorityActionsCount;

  Future<void> executeAction(String actionId) =>
      actionsController.executeAction(actionId);
  Future<void> dismissAction(String actionId) =>
      actionsController.dismissAction(actionId);

  /// Get dashboard summary data
  Map<String, dynamic> get dashboardSummary {
    return {
      'vendorName': vendorName,
      'isOpen': isVendorOpen,
      'totalOrders': totalOrders,
      'totalProducts': totalProducts,
      'totalEarnings': totalEarnings,
      'newOrdersCount': ordersController.newOrders.length,
      'ongoingOrdersCount': ordersController.ongoingOrders.length,
      'pendingActionsCount': actionsController.pendingActions.length,
      'highPriorityActionsCount': highPriorityActionsCount,
    };
  }
}
