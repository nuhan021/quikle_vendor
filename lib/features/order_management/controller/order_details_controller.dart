import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'order_management_controller.dart';

class OrderDetailsController extends GetxController {
  /// 🔹 Reactive order data (null-safe)
  final orderData = Rxn<Map<String, dynamic>>();

  /// 🔹 Loading & Error states (for API readiness)
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrderDetails();
  }

  /// 🔹 Fetch order details (currently from mock list, later replace with API)
  void fetchOrderDetails() {
    final orderId = Get.arguments as String?;
    if (orderId == null) {
      errorMessage.value = "Invalid order ID";
      return;
    }

    isLoading.value = true;

    try {
      // In production, replace this with actual API call
      final managementController = Get.find<OrderManagementController>();
      final foundOrder = managementController.allOrders.firstWhereOrNull(
        (e) => e['id'] == orderId,
      );

      if (foundOrder != null) {
        orderData.value = foundOrder;
      } else {
        errorMessage.value = "Order not found!";
      }
    } catch (e) {
      errorMessage.value = "Failed to load order details: $e";
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 Mark order as completed (Mock)
  void markAsCompleted() {
    final id = orderData.value?['id'];
    if (id == null) return;

    Get.snackbar(
      "Order Completed",
      "Order $id marked as completed!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF10B981),
      colorText: Colors.white,
    );

    // TODO: Implement API call to update order status
  }

  /// 🔹 Update local order status (for testing / visual feedback)
  void updateOrderStatus(String newStatus) {
    if (orderData.value == null) return;
    orderData.update((order) {
      if (order != null) order['status'] = newStatus;
    });
  }

  /// -------------------- Order Actions --------------------
  void _showSnackbar(String title, String message, Color bgColor) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: bgColor,
      colorText: Colors.white,
    );
  }

  void acceptOrder(String orderId) =>
      _showSnackbar('Order Accepted', 'Order $orderId accepted', Colors.green);

  void rejectOrder(String orderId) =>
      _showSnackbar('Order Rejected', 'Order $orderId rejected', Colors.red);

  void reviewOrder(String orderId) => _showSnackbar(
    'Order Review',
    'Reviewing $orderId prescription',
    Colors.indigo,
  );

  void markAsPrepared(String orderId) => _showSnackbar(
    'Prepared',
    'Order $orderId marked as prepared',
    Colors.green,
  );

  void markAsDispatched(String orderId) =>
      _showSnackbar('Dispatched', 'Order $orderId dispatched', Colors.green);

  void viewPrescription(String orderId) => _showSnackbar(
    'Prescription',
    'Viewing prescription for $orderId',
    Colors.blue,
  );
}
