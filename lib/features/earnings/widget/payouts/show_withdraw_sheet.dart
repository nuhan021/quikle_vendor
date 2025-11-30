import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/helpers/snackbar_helper.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/custom_textfield.dart';
import '../../controller/payouts_controller.dart';

void showWithdrawDialog(BuildContext context, PayoutsController controller) {
  final amountController = TextEditingController();

  Get.dialog(
    Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Title
              Text(
                "Withdraw Funds",
                style: getTextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              /// Available Balance
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Available Balance:",
                  style: getTextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "\$${controller.availableBalance.value.toStringAsFixed(2)}",
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              /// Enter Amount
              CustomTextField(
                label: "Enter Amount",
                hintText: "Enter amount",
                hintTextStyle: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade500,
                ),
                controller: amountController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              /// Buttons Row
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: "Cancel",
                      onPressed: () => Get.back(),
                      height: 44,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      borderColor: Colors.black26,
                      fontSize: 14,
                      borderRadius: 8,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomButton(
                      text: "Confirm",
                      onPressed: () {
                        final amount =
                            double.tryParse(amountController.text) ?? 0;

                        if (amount <= 0 ||
                            amount > controller.availableBalance.value) {
                          SnackBarHelper.error("Invalid withdraw amount");
                          return;
                        }

                        controller.withdrawFunds(amount);

                        Get.back(); // Close dialog

                        /// Success dialog
                        Get.dialog(
                          Material(
                            color: Colors.transparent,
                            child: Center(
                              child: Container(
                                height: 260,
                                width: double.infinity,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                ),
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Text(
                                    "Successfully withdrew \$${amount.toStringAsFixed(2)}!",
                                    style: getTextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );

                        Future.delayed(const Duration(seconds: 3), () {
                          if (Get.isDialogOpen ?? false) Get.back();
                        });
                      },
                      height: 44,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 14,
                      borderRadius: 8,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
