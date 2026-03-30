import 'dart:developer';

import 'package:get/get.dart';
import 'package:quikle_vendor/features/earnings/model/earnings_model.dart';
import 'package:quikle_vendor/features/earnings/model/beneficiary_model.dart';
import 'package:quikle_vendor/features/earnings/services/add_beneficiary_services.dart';
import 'package:quikle_vendor/features/earnings/services/earning_sevices.dart';
import 'package:quikle_vendor/core/models/response_data.dart';
import 'package:quikle_vendor/core/utils/logging/logger.dart';

class PayoutsController extends GetxController {
  final EarningsService _earningsService = EarningsService();
  final AddBeneficiaryServices _beneficiaryService = AddBeneficiaryServices();

  var availableBalance = 0.0.obs;

  var minWithdrawalAmount = "".obs;
  var autoWithdrawalEnabled = false.obs;
  var paymentMethod = "".obs;
  var bankAccount = "".obs;
  var isSavingWithdrawalConfig = false.obs;

  Rx<BeneficiaryModel?> beneficiary = Rx<BeneficiaryModel?>(null);

  var isBeneficiarySelected = false.obs;

  bool get hasBeneficiary => beneficiary.value != null;
  @override
  void onInit() {
    super.onInit();
    fetchPayoutData();
  }

  void addBeneficiary(BeneficiaryModel beneficiary) {
    this.beneficiary.value = beneficiary;
  }

  Future<ResponseData> addBeneficiaryRemote(
    BeneficiaryModel model, {
    int? autoPayoutAmount,
    String? autoPayoutStatus,
    String? refreshToken,
  }) async {
    try {
      AppLoggerHelper.info('Calling addBeneficiaryRemote for ${model.name}');
      final response = await _beneficiaryService.addBeneficiary(
        beneficiaryName: model.name,
        bankAccountNumber: model.bankAccount,
        bankIfsc: model.ifsc,
        email: model.email.isNotEmpty ? model.email : null,
        phone: model.phone.isNotEmpty ? model.phone : null,
        autoPayoutAmount: autoPayoutAmount,
        autoPayoutStatus: autoPayoutStatus,
        refreshToken: refreshToken,
      );

      if (response.isSuccess) {
        beneficiary.value = model;
        bankAccount.value = model.bankAccount;
        if (autoPayoutAmount != null) {
          minWithdrawalAmount.value = autoPayoutAmount.toString();
        }
        if (autoPayoutStatus != null && autoPayoutStatus.isNotEmpty) {
          paymentMethod.value = autoPayoutStatus;
          autoWithdrawalEnabled.value = autoPayoutStatus != 'manual';
        }
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

  void withdraw() {}

  void updateMinWithdrawal(String value) {
    minWithdrawalAmount.value = value.replaceAll(RegExp(r'[^0-9]'), '');
  }

  void toggleAutoWithdrawal(bool value) {
    autoWithdrawalEnabled.value = value;
    // TODO: Update toggle state in API
  }

  void changePaymentMethod(String method) {
    paymentMethod.value = method;
    autoWithdrawalEnabled.value = method != 'manual';
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

  Future<ResponseData> saveWithdrawalConfig({String? refreshToken}) async {
    final currentBeneficiary = beneficiary.value;

    if (currentBeneficiary == null) {
      return ResponseData(
        isSuccess: false,
        statusCode: 400,
        responseData: {},
        errorMessage: 'Please add a beneficiary first.',
      );
    }

    final amount = int.tryParse(minWithdrawalAmount.value.trim());
    if (amount == null || amount <= 0) {
      return ResponseData(
        isSuccess: false,
        statusCode: 400,
        responseData: {},
        errorMessage: 'Please enter a valid auto payout amount.',
      );
    }

    final status = paymentMethod.value.trim().isEmpty
        ? 'manual'
        : paymentMethod.value.trim();

    isSavingWithdrawalConfig.value = true;
    try {
      return await addBeneficiaryRemote(
        currentBeneficiary,
        autoPayoutAmount: amount,
        autoPayoutStatus: status,
        refreshToken: refreshToken,
      );
    } finally {
      isSavingWithdrawalConfig.value = false;
    }
  }

  Future<void> fetchPayoutData() async {
    try {
      final EarningsModel? model = await _earningsService.fetchVendorAccount();

      availableBalance.value =
          model?.pendingBalance ?? model?.totalEarnings ?? 0.0;
    } catch (e) {
      AppLoggerHelper.error('Exception in fetchPayoutData', e);
      availableBalance.value = 0.0;
    }

    if (minWithdrawalAmount.value.isEmpty) {
      minWithdrawalAmount.value = "500";
    }
    if (paymentMethod.value.isEmpty) {
      paymentMethod.value = "manual";
    }
    autoWithdrawalEnabled.value = paymentMethod.value != 'manual';
    bankAccount.value = beneficiary.value?.bankAccount ?? bankAccount.value;
  }
}
