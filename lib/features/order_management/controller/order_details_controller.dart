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
  void acceptOrder(String orderId) {}

  void rejectOrder(String orderId) {}

  void reviewOrder(String orderId) {}

  void markAsPrepared(String orderId) {}

  void markAsDispatched(String orderId) {}

  void viewPrescription(String orderId) {}
}
