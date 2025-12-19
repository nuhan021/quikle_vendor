import 'package:get/get.dart';
import 'package:quikle_vendor/routes/app_routes.dart';
import '../../../core/services/storage_service.dart';
import '../services/order_services.dart';

class OrderManagementController extends GetxController {
  /// -------------------- Tabs --------------------
  final tabs = ["New", "In Progress", "Completed"];
  final selectedTab = 0.obs;

  /// -------------------- Orders (Mock Data) --------------------
  final allOrders = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  /// -------------------- Button State Management --------------------
  final disabledButtons = <String>{}.obs;
  final confirmedOrders = <String>{}.obs;

  /// -------------------- Services --------------------
  final OrderService _orderService = OrderService();

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  /// -------------------- Fetch Orders from API --------------------
  Future<void> fetchOrders() async {
    // Always fetch orders; do not gate on profile/KYC

    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Pass stored token (if available) as Bearer token
      final storedToken = StorageService.token;
      final authHeader = storedToken != null ? 'Bearer $storedToken' : null;

      print('🔍 [ORDER FETCH] Starting fetch...');
      print('🔍 [ORDER FETCH] Token present: ${storedToken != null}');
      print('🔍 [ORDER FETCH] Auth header: $authHeader');

      final response = await _orderService.fetchOrders(
        offset: 0,
        limit: 50,
        token: authHeader,
      );

      print('🔍 [ORDER FETCH] Response received: $response');
      print('🔍 [ORDER FETCH] Response is null: ${response == null}');

      if (response != null && response.orders.isNotEmpty) {
        print('✅ [ORDER FETCH] Found ${response.orders.length} orders');
        // Convert API response to UI format
        final uiOrders = response.orders
            .map((order) => OrderService.orderModelToMap(order))
            .toList();
        allOrders.assignAll(uiOrders);
        print('✅ [ORDER FETCH] Assigned ${uiOrders.length} orders to UI');
      } else {
        print('❌ [ORDER FETCH] No orders in response');
        if (response == null) {
          print(
            '❌ [ORDER FETCH] Response object is null - API call likely failed',
          );
        } else {
          print(
            '❌ [ORDER FETCH] Response exists but orders list is empty: ${response.orders.length} orders',
          );
        }
        errorMessage.value = 'No orders found';
        if (authHeader == null) {
          errorMessage.value = 'Authentication token missing. Please login.';
        }
        allOrders.clear();
      }
    } catch (e) {
      errorMessage.value = 'Failed to load orders: $e';
      print('❌ [ORDER FETCH] Exception caught: $e');
      print('❌ [ORDER FETCH] Stack trace: ${StackTrace.current}');
      // Remove dummy data fallback: clear orders so UI can display empty/error state
      allOrders.clear();
    } finally {
      isLoading.value = false;
      print(
        '🔍 [ORDER FETCH] Fetch complete. Total orders in UI: ${allOrders.length}',
      );
    }
  }

  /// -------------------- Tab Switch with API Call --------------------
  void changeTab(int index) {
    // Switch tab and rely on client-side filtering (no extra API call)
    selectedTab.value = index;
  }

  /// -------------------- Fetch Orders by Tab Status --------------------
  Future<void> _fetchOrdersByStatus(int tabIndex) async {
    // Not used: tab-specific server fetch. The controller fetches all orders once
    // and `filteredOrders` performs client-side filtering.
    return;
  }

  /// -------------------- Filtered Orders by Selected Tab --------------------
  List<Map<String, dynamic>> get filteredOrders {
    // establish reactive dependencies on selectedTab and allOrders
    final tabName = tabs[selectedTab.value].toLowerCase();

    String statusFilter;
    switch (tabName) {
      case 'new':
        statusFilter = 'new';
        break;
      case 'in progress':
        statusFilter = 'in-progress';
        break;
      case 'completed':
        statusFilter = 'completed';
        break;
      default:
        statusFilter = 'new';
    }

    return allOrders.where((order) => order['status'] == statusFilter).toList();
  }

  /// -------------------- Navigate to Details --------------------
  void navigateToOrderDetails(String orderId) {
    Get.toNamed(AppRoute.completedOrderDetailsScreen, arguments: orderId);
  }

  /// -------------------- Order Actions --------------------
  void confirmOrder(String orderId) {}

  void rejectOrder(String orderId) {}

  void reviewOrder(String orderId) {}

  void markAsPrepared(String orderId) {
    disabledButtons.add(orderId);
  }

  void markAsShipped(String orderId) {
    disabledButtons.add(orderId);
  }

  /// -------------------- Get Order by ID --------------------
  Map<String, dynamic>? getOrderById(String orderId) {
    try {
      return allOrders.firstWhereOrNull((order) => order['id'] == orderId);
    } catch (_) {
      return null;
    }
  }

  /// -------------------- View Prescription --------------------
  void viewPrescription(String orderId) {}

  /// -------------------- View Details --------------------
  void viewDetails(String orderId) {
    Get.toNamed(AppRoute.completedOrderDetailsScreen, arguments: orderId);
  }
}
