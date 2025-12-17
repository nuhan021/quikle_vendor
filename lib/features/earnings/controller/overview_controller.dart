import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/logging/logger.dart';
import '../services/earning_sevices.dart';
import '../model/earnings_model.dart';

class OverviewController extends GetxController {
  /// ---------------------- Earnings ----------------------
  var totalEarnings = 0.0.obs;
  var netEarnings = 0.0.obs;

  /// ---------------------- Filters ----------------------
  var selectedRange = "This Week".obs;
  final ranges = ["This Week", "This Month", "This Year"];

  /// ---------------------- Stats ----------------------
  var paymentReceived = 0.0.obs;
  var pending = 0.0.obs;
  var commission = 0.0.obs;
  var avgOrder = 0.0.obs;

  /// ---------------------- Orders ----------------------
  var ordersCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOverviewData(); // Initial fetch (calls API)
  }

  final EarningsService _service = EarningsService();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  /// Fetch overview data from API and populate observables
  Future<void> fetchOverviewData({String? range}) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final period = _mapRangeToPeriod(range ?? selectedRange.value);
      AppLoggerHelper.debug('Fetching earnings for period: $period');
      final EarningsModel? model = await _service.fetchVendorAccount(
        period: period,
      );

      AppLoggerHelper.debug(
        'EarningsService returned: ${model?.toJson() ?? 'null'}',
      );

      if (model != null) {
        totalEarnings.value = model.totalEarnings ?? 0.0;
        // If platform doesn't return net directly, keep some simple calculation
        netEarnings.value =
            (model.totalEarnings ?? 0.0) - (model.platformCost ?? 0.0);
        paymentReceived.value =
            (model.totalEarnings ?? 0.0) - (model.totalPending ?? 0.0);
        pending.value = model.totalPending ?? 0.0;
        commission.value = model.commissionEarned ?? 0.0;
        avgOrder.value = (model.totalOrders != null && model.totalOrders! > 0)
            ? ((model.totalEarnings ?? 0.0) / (model.totalOrders ?? 1))
            : 0.0;
        ordersCount.value = model.totalOrders ?? 0;
      } else {
        // fallback to previous mock data for UX continuity
        _applyMockData();
        errorMessage.value = 'Failed to load earnings. Showing demo data.';
      }
    } catch (e) {
      _applyMockData();
      errorMessage.value = 'Error loading earnings: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Change selected range
  void changeRange(String value) {
    selectedRange.value = value;
    // Call API with selected range mapped to period
    fetchOverviewData(range: value);
  }

  // Map UI label to API period parameter
  String _mapRangeToPeriod(String rangeLabel) {
    final v = rangeLabel.toLowerCase();
    if (v.contains('week')) return 'this_week';
    if (v.contains('month')) return 'this_month';
    if (v.contains('year')) return 'this_year';
    return 'this_week';
  }

  void _applyMockData() {
    totalEarnings.value = 0.0;
    netEarnings.value = 0.0;
    paymentReceived.value = 0.0;
    pending.value = 0.0;
    commission.value = 0.0;
    avgOrder.value = 0.0;
    ordersCount.value = 0;
  }
}
