import 'package:get/get.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import 'order_management_controller.dart';
import '../services/order_services.dart';

class OrderDetailsController extends GetxController {
  /// 🔹 Reactive order data (null-safe)
  final orderData = Rxn<Map<String, dynamic>>();

  /// 🔹 Loading & Error states (for API readiness)
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  /// 🔹 Prepare time for new orders
  final prepareTime = 0.obs;

  /// 🔹 Services
  final OrderService _orderService = OrderService();

  @override
  void onInit() {
    super.onInit();
    fetchOrderDetails();
  }

  /// 🔹 Fetch order details from mock list or API
  void fetchOrderDetails() {
    final orderId = Get.arguments as String?;
    if (orderId == null) {
      errorMessage.value = "Invalid order ID";
      return;
    }

    isLoading.value = true;

    try {
      // First try to find in the management controller's cached orders
      final managementController = Get.find<OrderManagementController>();
      final foundOrder = managementController.allOrders.firstWhereOrNull(
        (e) => e['id'] == orderId || e['apiOrderId'] == orderId,
      );

      if (foundOrder != null) {
        orderData.value = foundOrder;
      } else {
        errorMessage.value = "Order not found!";
      }
    } catch (e) {
      errorMessage.value = "Failed to load order details: $e";
      print('Error in fetchOrderDetails: $e');
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
  void confirmOrder(String orderId) async {
    final order = orderData.value;
    if (order == null) {
      errorMessage.value = 'Order data not found';
      return;
    }

    if (prepareTime.value <= 0) {
      errorMessage.value = 'Please enter a valid prepare time';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final storedToken = StorageService.token;
      final authHeader = storedToken != null ? 'Bearer $storedToken' : null;

      // Use apiOrderId if available, otherwise use id
      final actualOrderId = order['apiOrderId'] ?? order['id'];

      final success = await _orderService.createOffer(
        orderId: actualOrderId,
        prepareTime: prepareTime.value,
        token: authHeader,
      );

      if (success) {
        errorMessage.value = 'Order confirmed! Offer sent to customer.';
        // Optionally navigate back or refresh order list
        Future.delayed(const Duration(seconds: 2), () {
          Get.back();
        });
      } else {
        errorMessage.value = 'Failed to confirm order. Please try again.';
      }
    } catch (e) {
      errorMessage.value = 'Error confirming order: $e';
      print('Error in confirmOrder: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void rejectOrder(String orderId) {}

  void reviewOrder(String orderId) {}

  void markAsPrepared(String orderId) {}

  void markAsShipped(String orderId) async {
    final order = orderData.value;
    if (order == null) {
      errorMessage.value = 'Order data not found';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final storedToken = StorageService.token;
      final authHeader = storedToken != null ? 'Bearer $storedToken' : null;

      final actualOrderId = order['apiOrderId'] ?? order['id'];

      final success = await _orderService.markShipped(
        orderId: actualOrderId,
        token: authHeader,
      );

      if (success) {
        errorMessage.value = 'Order marked as shipped!';
        updateOrderStatus('completed');
        Future.delayed(const Duration(seconds: 2), () {
          Get.back();
        });
      } else {
        errorMessage.value = 'Failed to mark as shipped. Please try again.';
      }
    } catch (e) {
      errorMessage.value = 'Error marking as shipped: $e';
      print('Error in markAsShipped: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void viewPrescription(String orderId) {}
}
