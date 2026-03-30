import 'package:get/get.dart';

import '../model/payment_transaction_model.dart';
import '../services/payments_service.dart';

class PaymentsController extends GetxController {
  final PaymentsService _paymentsService = PaymentsService();

  final transactions = <PaymentTransactionModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final totalOrders = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  Future<void> fetchTransactions({bool showLoader = true}) async {
    final previousTransactions = List<PaymentTransactionModel>.from(
      transactions,
    );
    final previousTotalOrders = totalOrders.value;

    if (showLoader) {
      isLoading.value = true;
    }
    errorMessage.value = '';

    try {
      final response = await _paymentsService.fetchConfirmedPayments();
      transactions.assignAll(response.orders);
      totalOrders.value = response.totalOrders;
    } catch (e) {
      transactions.assignAll(previousTransactions);
      totalOrders.value = previousTotalOrders;

      if (previousTransactions.isEmpty) {
        errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      }
    } finally {
      if (showLoader) {
        isLoading.value = false;
      }
    }
  }
}
