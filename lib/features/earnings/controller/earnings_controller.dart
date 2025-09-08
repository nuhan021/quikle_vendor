import 'package:get/get.dart';

class EarningsController extends GetxController {
  var tabs = ["Overview", "Payments", "Invoices", "Payouts"];
  var selectedTab = 0.obs;

  void changeTab(int index) {
    selectedTab.value = index;
  }
}
