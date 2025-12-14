import 'dart:developer';

import 'package:get/get.dart';
import 'package:quikle_vendor/features/earnings/model/beneficiary_model.dart';
import 'package:quikle_vendor/features/earnings/services/add_beneficiary_services.dart';
import 'package:quikle_vendor/core/models/response_data.dart';
import 'package:quikle_vendor/core/utils/logging/logger.dart';

class PayoutsController extends GetxController {
  /// -------------------- Observables --------------------
  var availableBalance = 0.0.obs;
  var nextAutoWithdrawal = "".obs;

  var minWithdrawalAmount = "".obs;
  var autoWithdrawalEnabled = false.obs;
  var selectedDay = "".obs;
  var paymentMethod = "".obs;
  var bankAccount = "".obs;

  Rx<BeneficiaryModel?> beneficiary = Rx<BeneficiaryModel?>(null);

  var isBeneficiarySelected = false.obs;

  bool get hasBeneficiary => beneficiary.value != null;

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

  void addBeneficiary(BeneficiaryModel beneficiary) {
    this.beneficiary.value = beneficiary;
  }

  /// Add beneficiary via API and update local state
  Future<ResponseData> addBeneficiaryRemote(
    BeneficiaryModel model, {
    String? refreshToken,
  }) async {
    final service = AddBeneficiaryServices();
    try {
      AppLoggerHelper.info('Calling addBeneficiaryRemote for ${model.name}');
      final response = await service.addBeneficiary(
        beneficiaryName: model.name,
        bankAccountNumber: model.bankAccount,
        bankIfsc: model.ifsc,
        email: model.email.isNotEmpty ? model.email : null,
        phone: model.phone.isNotEmpty ? model.phone : null,
        refreshToken: refreshToken,
      );

      if (response.isSuccess) {
        // Update local beneficiary on success
        beneficiary.value = model;
        isBeneficiarySelected.value = true;
        log('Beneficiary added successfully: ${response.responseData}');
      } else {
        AppLoggerHelper.error(
          'Add beneficiary failed: ${response.errorMessage}',
        );
      }

      return response;
    } catch (e) {
      AppLoggerHelper.error('Exception in addBeneficiaryRemote', e);
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: {},
        errorMessage: e.toString(),
      );
    }
  }

  void selectBeneficiary() {
    isBeneficiarySelected.value = true;
  }

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
