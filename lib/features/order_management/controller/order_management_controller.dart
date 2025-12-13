import 'package:get/get.dart';
import 'package:quikle_vendor/routes/app_routes.dart';
import '../../../core/services/storage_service.dart';
import '../services/order_services.dart';

class OrderManagementController extends GetxController {
  /// -------------------- Tabs --------------------
  final tabs = ["New", "In Progress", "Shipped", "Completed"];
  final selectedTab = 0.obs;

  /// -------------------- Orders (Mock Data) --------------------
  final allOrders = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Per-status cache: apiStatus -> list of orders
  final Map<String, List<Map<String, dynamic>>> _statusCache = {};
  final Map<String, int> _statusOffsets = {};
  final Map<String, bool> _statusHasMore = {};
  final Map<String, bool> _statusLoading = {};
  // Exposed reactive small cache for RecentOrdersWidget: [first shipped, first delivered]
  final recentOrdersCache = <Map<String, dynamic>>[].obs;

  /// -------------------- Button State Management --------------------
  final disabledButtons = <String>{}.obs;
  final confirmedOrders = <String>{}.obs;

  /// -------------------- Services --------------------
  final OrderService _orderService = OrderService();

  @override
  void onInit() {
    super.onInit();
    // Prefetch each tab's orders on app start
    _prefetchAllTabs();
  }

  /// Prefetch orders for all tabs so UI can show shipped/completed without extra taps
  Future<void> _prefetchAllTabs() async {
    for (var i = 0; i < tabs.length; i++) {
      final apiStatus = _mapTabIndexToApiStatus(i);
      // initialize tracking
      _statusOffsets[apiStatus] = 0;
      _statusHasMore[apiStatus] = true;
      _statusCache[apiStatus] = [];
      _statusLoading[apiStatus] = false;
    }

    // Fire off prefetches (await sequentially to avoid rate limits)
    for (var i = 0; i < tabs.length; i++) {
      final apiStatus = _mapTabIndexToApiStatus(i);
      await _fetchOrdersByStatus(i, offset: 0, limit: 20);
    }

    // After prefetch, populate allOrders with selected tab cache
    final initialApi = _mapTabIndexToApiStatus(selectedTab.value);
    final cached = _statusCache[initialApi] ?? [];
    allOrders.assignAll(cached);
  }

  /// -------------------- Fetch Orders from API --------------------
  Future<void> fetchOrders() async {
    // Deprecated: use per-status prefetch and _fetchOrdersByStatus instead
    return;
  }

  /// -------------------- Tab Switch with API Call --------------------
  void changeTab(int index) {
    selectedTab.value = index;
    // If we have cached orders for this tab, use them; otherwise fetch
    final apiStatus = _mapTabIndexToApiStatus(index);
    final cached = _statusCache[apiStatus];
    if (cached != null && cached.isNotEmpty) {
      allOrders.assignAll(cached);
    } else {
      _fetchOrdersByStatus(index);
    }
  }

  /// -------------------- Fetch Orders by Tab Status --------------------
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
      case 'in progress':
        return 'confirmed';
      case 'shipped':
        return 'shipped';
      case 'completed':
        return 'delivered';
      default:
        return 'processing';
    }
  }

  /// Public helper: ensure orders for a given API status are loaded into the cache.
  /// Safe to call repeatedly; it will noop if cache already populated or loading is in progress.
  Future<void> fetchOrdersForApiStatus(String apiStatus) async {
    // find tab index corresponding to this apiStatus
    final tabIndex = tabs.indexWhere(
      (t) => _mapTabIndexToApiStatus(tabs.indexOf(t)) == apiStatus,
    );
    if (tabIndex < 0) return;

    // If already have cached data or currently loading, do nothing
    if ((_statusCache[apiStatus]?.isNotEmpty ?? false) ||
        (_statusLoading[apiStatus] == true))
      return;

    await _fetchOrdersByStatus(tabIndex, offset: 0, limit: 20);
    // ensure recent cache updated after fetch
    _updateRecentOrdersCache();
  }

  /// Public: check if a specific API status is currently loading.
  bool isStatusLoading(String apiStatus) {
    return _statusLoading[apiStatus] == true;
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
      case 'shipped':
        // We'll filter by apiStatus for shipped orders in UI mapping
        statusFilter = 'shipped';
        break;
      case 'completed':
        statusFilter = 'completed';
        break;
      default:
        statusFilter = 'new';
    }

    if (statusFilter == 'shipped') {
      // Filter by original API status for shipped tab
      return allOrders
          .where((order) => order['apiStatus'] == 'shipped')
          .toList();
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
