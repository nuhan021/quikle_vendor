import 'package:get/get.dart';
import 'package:flutter/scheduler.dart';
import 'overview_controller.dart';

class EarningsController extends GetxController {
  var tabs = ["Overview", /*"Payments",*/ "Invoices", "Payouts"];
  var selectedTab = 0.obs;

  void changeTab(int index) {
    selectedTab.value = index;
    // If Overview tab selected, trigger a refresh of overview data.
    if (index == 0) {
      // Schedule after frame so OverviewTab (and its controller) is built/put.
      SchedulerBinding.instance.addPostFrameCallback((_) {
        try {
          final overview = Get.find<OverviewController>();
          overview.fetchOverviewData();
        } catch (e) {
          // OverviewController not yet registered — ignore
        }
      });
    }
  }
}
