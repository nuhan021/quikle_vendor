import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:quikle_vendor/features/earnings/controller/payouts_controller.dart';
import 'package:quikle_vendor/features/earnings/widget/payouts/available_balance_card.dart';
import 'package:quikle_vendor/features/earnings/widget/payouts/beneficiary_card_view.dart';
import 'package:quikle_vendor/features/earnings/widget/payouts/no_beneficiary_view.dart';
import 'package:quikle_vendor/features/earnings/widget/payouts/show_withdraw_sheet.dart';
import 'package:quikle_vendor/features/earnings/widget/payouts/withdrawal_config_view.dart';
import 'package:quikle_vendor/routes/app_routes.dart';

class PayoutsTab extends StatelessWidget {
  const PayoutsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PayoutsController());

    return Obx(() {
      if (!controller.hasBeneficiary) {
        return NoBeneficiaryView(
          title: "No beneficiary added",
          onAddBeneficiary: () => Get.toNamed(AppRoute.addBeneficiaryScreen),
        );
      }

      return SingleChildScrollView(
        child: Column(
          children: [
            AvailableBalanceCard(
              title: "Available Balance",
              balanceText:
                  "\$${controller.availableBalance.value.toStringAsFixed(2)}",
              subtitle:
                  "Next auto-withdrawal: ${controller.nextAutoWithdrawal.value}",
              onWithdraw: () => showWithdrawDialog(context, controller),
            ),
            const SizedBox(height: 16),

            controller.isBeneficiarySelected.value
                ? WithdrawalConfigView(
                    minAmount: controller.minWithdrawalAmount.value,
                    onMinAmountChanged: controller.updateMinWithdrawal,
                    autoWithdrawalEnabled:
                        controller.autoWithdrawalEnabled.value,
                    onToggleAutoWithdrawal: controller.toggleAutoWithdrawal,
                    selectedDay: controller.selectedDay.value,
                    days: controller.withdrawalDays,
                    onDayChanged: controller.changeDay,
                    paymentMethod: controller.paymentMethod.value,
                    paymentMethods: controller.paymentMethods,
                    onPaymentMethodChanged: controller.changePaymentMethod,
                    bankAccount: controller.bankAccount.value,
                    onBankAccountChanged: controller.updateBankAccount,
                  )
                : BeneficiaryCardView(
                    name: controller.beneficiary.value!.name,
                    account: controller.beneficiary.value!.bankAccount,
                    ifsc: controller.beneficiary.value!.ifsc,
                    onTap: controller.selectBeneficiary,
                  ),
          ],
        ),
      );
    });
  }
}
