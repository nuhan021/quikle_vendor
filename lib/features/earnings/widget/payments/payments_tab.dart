import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/constants/icon_path.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../controller/payments_controller.dart';
import 'transaction_card.dart';

class PaymentsTab extends StatelessWidget {
  const PaymentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<PaymentsController>()
        ? Get.find<PaymentsController>()
        : Get.put(PaymentsController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recent Transactions",
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: Implement export functionality
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black12, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Export",
                      style: getTextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset(IconPath.export, width: 14, height: 14),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage.value.isNotEmpty) {
              return _PaymentStateView(
                message: controller.errorMessage.value,
                actionLabel: 'Retry',
                onAction: controller.fetchTransactions,
              );
            }

            if (controller.transactions.isEmpty) {
              return _PaymentStateView(
                message: 'No confirmed payments found.',
                actionLabel: 'Refresh',
                onAction: controller.fetchTransactions,
              );
            }

            return RefreshIndicator(
              onRefresh: () => controller.fetchTransactions(showLoader: false),
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: controller.transactions.length,
                itemBuilder: (context, index) {
                  final tx = controller.transactions[index];
                  return TransactionCard(
                    orderId: tx.displayOrderId,
                    amount: tx.displayAmount,
                    status: tx.displayStatus,
                    time: tx.displayTime,
                    customer: tx.displayCustomer,
                    delivery: tx.displayDelivery,
                    tags: tx.displayTags,
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _PaymentStateView extends StatelessWidget {
  final String message;
  final String actionLabel;
  final Future<void> Function() onAction;

  const _PaymentStateView({
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: getTextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(onPressed: onAction, child: Text(actionLabel)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
