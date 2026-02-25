import 'package:get/get.dart';
import 'package:flutter/scheduler.dart';
import 'overview_controller.dart';

class EarningsController extends GetxController {
  var tabs = ["Overview", "Payments", "Invoices", "Payouts"];
  var selectedTab = 0.obs;

  void changeTab(int index) {
    selectedTab.value = index;
    if (index == 0) {
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
