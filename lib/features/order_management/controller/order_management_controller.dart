import 'package:get/get.dart';
import 'package:quikle_vendor/routes/app_routes.dart';
import 'package:quikle_vendor/features/profile/my_profile/controller/my_profile_controller.dart';
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
    // Check if features are disabled
    try {
      final myProfileController = Get.find<MyProfileController>();
      if (myProfileController.areFeauresDisabled()) {
        return; // Skip API call if features are disabled
      }
    } catch (e) {
      // Controller not found, continue anyway
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Pass stored token (if available) as Bearer token
      final storedToken = StorageService.token;
      final authHeader = storedToken != null ? 'Bearer $storedToken' : null;

      final response = await _orderService.fetchOrders(
        offset: 0,
        limit: 50,
        token: authHeader,
      );

      if (response != null && response.orders.isNotEmpty) {
        // Convert API response to UI format
        final uiOrders = response.orders
            .map((order) => OrderService.orderModelToMap(order))
            .toList();
        allOrders.assignAll(uiOrders);
      } else {
        errorMessage.value = 'You have to complete your profile to get orders.';
        // If token missing or invalid, give actionable message
        if (authHeader == null) {
          errorMessage.value = 'Authentication token missing. Please login.';
        }
        // Remove dummy data: clear any existing orders so UI shows empty state
        allOrders.clear();
      }
    } catch (e) {
      errorMessage.value = 'Failed to load orders: $e';
      print('Error fetching orders: $e');
      // Remove dummy data fallback: clear orders so UI can display empty/error state
      allOrders.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// -------------------- Tab Switch with API Call --------------------
  void changeTab(int index) {
    selectedTab.value = index;
    // Fetch orders for the selected tab
    _fetchOrdersByStatus(index);
  }

  /// -------------------- Fetch Orders by Tab Status --------------------
  Future<void> _fetchOrdersByStatus(int tabIndex) async {
    // Check if features are disabled
    try {
      final myProfileController = Get.find<MyProfileController>();
      if (myProfileController.areFeauresDisabled()) {
        return; // Skip API call if features are disabled
      }
    } catch (e) {
      // Controller not found, continue anyway
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final tabName = tabs[tabIndex].toLowerCase();

      // Map UI tab to a single API status (one status → one tab)
      String? apiStatus;
      switch (tabName) {
        case 'new':
          apiStatus = 'processing';
          break;
        case 'in progress':
          apiStatus = 'confirmed';
          break;
        case 'completed':
          apiStatus = 'delivered';
          break;
      }

      final storedToken = StorageService.token;
      final authHeader = storedToken != null ? 'Bearer $storedToken' : null;

      final response = await _orderService.fetchOrders(
        offset: 0,
        limit: 50,
        status: apiStatus,
        token: authHeader,
      );

      if (response != null && response.orders.isNotEmpty) {
        final uiOrders = response.orders
            .map((order) => OrderService.orderModelToMap(order))
            .toList();
        allOrders.assignAll(uiOrders);
      } else {
        errorMessage.value = 'No orders found for this status';
        if (authHeader == null) {
          errorMessage.value = 'Authentication token missing. Please login.';
        }
      }
    } catch (e) {
      errorMessage.value = 'Failed to load orders: $e';
      print('Error fetching orders by status: $e');
    } finally {
      isLoading.value = false;
    }
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
