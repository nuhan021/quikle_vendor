import 'package:get/get.dart';

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
    fetchOverviewData(); // Initial fetch
  }

  /// Fetch overview data (mock for now)
  void fetchOverviewData() {
    // TODO: Replace with API call for "Overview Data"
    totalEarnings.value = 4250.80;
    netEarnings.value = 325.72;
    paymentReceived.value = 3890.40;
    pending.value = 360.40;
    commission.value = 425.08;
    avgOrder.value = 29.93;
    ordersCount.value = 142;
  }

  /// Change selected range
  void changeRange(String value) {
    selectedRange.value = value;

    // TODO: Call API with `value` as filter parameter
    if (value == "This Month") {
      totalEarnings.value = 12250.50;
      netEarnings.value = 1050.75;
      paymentReceived.value = 11000.00;
      pending.value = 800.00;
      commission.value = 450.50;
      avgOrder.value = 32.10;
      ordersCount.value = 420;
    } else if (value == "This Year") {
      totalEarnings.value = 50250.75;
      netEarnings.value = 3200.20;
      paymentReceived.value = 48000.00;
      pending.value = 1500.00;
      commission.value = 750.55;
      avgOrder.value = 30.40;
      ordersCount.value = 1680;
    } else {
      fetchOverviewData();
    }
  }
}
