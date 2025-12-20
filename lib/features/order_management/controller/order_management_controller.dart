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
<<<<<<< Updated upstream
  Future<void> _fetchOrdersByStatus(int tabIndex) async {
    // Not used: tab-specific server fetch. The controller fetches all orders once
    // and `filteredOrders` performs client-side filtering.
    return;
=======
  Future<void> _fetchOrdersByStatus(
    int tabIndex, {
    int offset = 0,
    int limit = 20,
  }) async {
    // New implementation: support pagination and caching per status
    final apiStatus = _mapTabIndexToApiStatus(tabIndex);
    if (_statusLoading[apiStatus] == true) return;
    _statusLoading[apiStatus] = true;

    final currentOffset = _statusOffsets[apiStatus] ?? 0;
    final fetchOffset = offset == 0 ? currentOffset : offset;

    try {
      final storedToken = StorageService.token;
      final authHeader = storedToken != null ? 'Bearer $storedToken' : null;

      final response = await _orderService.fetchOrders(
        offset: fetchOffset,
        limit: limit,
        status: apiStatus,
        token: authHeader,
      );

      if (response != null) {
        final uiOrders = response.orders
            .map((order) => OrderService.orderModelToMap(order))
            .toList();
        final existing = _statusCache[apiStatus] ?? [];
        // append new
        existing.addAll(uiOrders);
        _statusCache[apiStatus] = existing;
        // update offset
        _statusOffsets[apiStatus] = existing.length;
        // set hasMore
        _statusHasMore[apiStatus] = (response.orders.length >= limit);

        // if current selected tab, show cached
        if (_mapTabIndexToApiStatus(selectedTab.value) == apiStatus) {
          allOrders.assignAll(existing);
        }
        // update the recentOrdersCache (first shipped + first delivered)
        _updateRecentOrdersCache();
      } else {
        // no response — mark no more
        _statusHasMore[apiStatus] = false;
      }
    } catch (e) {
      print('Error fetching orders by status: $e');
    } finally {
      _statusLoading[apiStatus] = false;
    }
  }

  void _updateRecentOrdersCache() {
    final shipped = _statusCache['shipped'] ?? [];
    final delivered = _statusCache['delivered'] ?? [];

    final List<Map<String, dynamic>> out = [];
    if (shipped.isNotEmpty) out.add(shipped.first);
    if (delivered.isNotEmpty) out.add(delivered.first);

    // ensure length 2 when possible; do not fill with duplicates
    recentOrdersCache.assignAll(out);
  }

  /// Helper to map tab index to API status string
  String _mapTabIndexToApiStatus(int tabIndex) {
    final tabName = tabs[tabIndex].toLowerCase();
    switch (tabName) {
      case 'new':
        return 'processing';
      case 'confirmed':
        return 'confirmed';
      case 'shipped':
        return 'outfordelivery';
      case 'completed':
        return 'delivered';
      default:
        return 'processing';
    }
  }

  /// Public helper: map tab index to API status string (exposes private mapper)
  String apiStatusForTabIndex(int tabIndex) =>
      _mapTabIndexToApiStatus(tabIndex);

  /// Public helper: ensure orders for a given API status are loaded into the cache.
  /// Safe to call repeatedly; it will noop if cache already populated or loading is in progress.
  /// Fetch orders for a given API status. If [force] is true, clear the
  /// existing cache for that status and re-fetch from offset 0.
  /// When the currently selected tab is being refreshed with [force]=true,
  /// `isLoading` will be set true so UI can show shimmer placeholders.
  Future<void> fetchOrdersForApiStatus(
    String apiStatus, {
    bool force = false,
  }) async {
    // find tab index corresponding to this apiStatus
    final tabIndex = tabs.indexWhere(
      (t) => _mapTabIndexToApiStatus(tabs.indexOf(t)) == apiStatus,
    );
    if (tabIndex < 0) return;

    // If not forcing and we already have cached data or currently loading, do nothing
    if (!force &&
        ((_statusCache[apiStatus]?.isNotEmpty ?? false) ||
            (_statusLoading[apiStatus] == true)))
      return;

    if (force) {
      // clear cache and reset offset so API is hit for fresh data
      _statusCache[apiStatus] = [];
      _statusOffsets[apiStatus] = 0;
      _statusHasMore[apiStatus] = true;
    }

    final bool isActiveTab =
        _mapTabIndexToApiStatus(selectedTab.value) == apiStatus;

    try {
      if (isActiveTab && force) isLoading.value = true;
      await _fetchOrdersByStatus(tabIndex, offset: 0, limit: 20);
      // ensure recent cache updated after fetch
      _updateRecentOrdersCache();
    } finally {
      if (isActiveTab && force) isLoading.value = false;
    }
  }

  /// Public: check if a specific API status is currently loading.
  bool isStatusLoading(String apiStatus) {
    return _statusLoading[apiStatus] == true;
>>>>>>> Stashed changes
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
      case 'confirmed':
        statusFilter = 'confirmed';
        break;
<<<<<<< Updated upstream
=======
      case 'shipped':
        statusFilter = 'shipped';
        break;
>>>>>>> Stashed changes
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
