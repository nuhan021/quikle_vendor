import 'package:get/get.dart';

class PayoutsController extends GetxController {
  /// -------------------- Observables --------------------
  var availableBalance = 0.0.obs;
  var nextAutoWithdrawal = "".obs;

  var minWithdrawalAmount = "".obs;
  var autoWithdrawalEnabled = false.obs;
  var selectedDay = "".obs;
  var paymentMethod = "".obs;
  var bankAccount = "".obs;

  /// Dropdown options
  final withdrawalDays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];
  final paymentMethods = ["Bank Transfer", "PayPal", "Stripe", "Other"];

  /// -------------------- Lifecycle --------------------
  @override
  void onInit() {
    super.onInit();
    fetchPayoutData();
  }

  /// -------------------- Actions --------------------
  void withdraw() {
    // Handled via show_withdraw_sheet
  }

  void updateMinWithdrawal(String value) {
    minWithdrawalAmount.value = value;
    // TODO: Send updated minimum withdrawal to API
  }

  void toggleAutoWithdrawal(bool value) {
    autoWithdrawalEnabled.value = value;
    // TODO: Update toggle state in API
  }

  void changeDay(String day) {
    selectedDay.value = day;
    // TODO: Update day in API
  }

  void changePaymentMethod(String method) {
    paymentMethod.value = method;
    // TODO: Update payment method in API
  }

  void updateBankAccount(String value) {
    bankAccount.value = value;
    // TODO: Update bank account in API
  }

  void withdrawFunds(double amount) {
    if (amount <= 0 || amount > availableBalance.value) {
      // TODO: Show error (snackbar or dialog)
      return;
    }
    availableBalance.value -= amount;
  }

  /// -------------------- Fetch Data --------------------
  Future<void> fetchPayoutData() async {
    // TODO: Replace this with API call
    await Future.delayed(const Duration(milliseconds: 500));
    availableBalance.value = 47.40;
    nextAutoWithdrawal.value = "Every Friday";
    minWithdrawalAmount.value = "\$100";
    autoWithdrawalEnabled.value = true;
    selectedDay.value = "Friday";
    paymentMethod.value = "Bank Transfer";
    bankAccount.value = "123456789";
  }
}
