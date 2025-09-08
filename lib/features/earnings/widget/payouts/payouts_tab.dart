import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../controller/payouts_controller.dart';
import 'show_withdraw_sheet.dart';

class PayoutsTab extends StatelessWidget {
  const PayoutsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PayoutsController());

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Available Balance Card
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Available Balance",
                        style: getTextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "\$${controller.availableBalance.value.toStringAsFixed(2)}",
                        style: getTextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Next auto-withdrawal: ${controller.nextAutoWithdrawal.value}",
                        style: getTextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),

                  /// Withdraw Button
                  CustomButton(
                    height: 32,
                    width: 87,
                    text: "Withdraw",
                    onPressed: () => showWithdrawDialog(context, controller),
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 12,
                    borderRadius: 8,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// Withdrawal Configuration
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Withdrawal Configuration",
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Minimum Withdrawal Amount
                  Text(
                    "Minimum Withdrawal Amount",
                    style: getTextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    initialValue: controller.minWithdrawalAmount.value,
                    onChanged: controller.updateMinWithdrawal,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Auto Withdrawal Day
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Auto Withdrawal Day",
                        style: getTextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),

                      /// Scaled Switch
                      Transform.scale(
                        scale: 0.65,
                        child: Switch(
                          value: controller.autoWithdrawalEnabled.value,
                          onChanged: controller.toggleAutoWithdrawal,
                          activeTrackColor: Colors.green,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey.shade300,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  /// Day Dropdown
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    value: controller.selectedDay.value.isEmpty
                        ? null
                        : controller.selectedDay.value,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: controller.withdrawalDays
                        .map(
                          (day) => DropdownMenuItem(
                            value: day,
                            child: Text(
                              day,
                              style: getTextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) controller.changeDay(val);
                    },
                  ),
                  const SizedBox(height: 16),

                  /// Payment Method
                  Text(
                    "Payment Method",
                    style: getTextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 6),

                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    value: controller.paymentMethod.value.isEmpty
                        ? null
                        : controller.paymentMethod.value,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: controller.paymentMethods
                        .map(
                          (method) => DropdownMenuItem(
                            value: method,
                            child: Text(
                              method,
                              style: getTextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) controller.changePaymentMethod(val);
                    },
                  ),
                  const SizedBox(height: 16),

                  /// Bank Account
                  Text(
                    "Bank Account",
                    style: getTextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    initialValue: controller.bankAccount.value,
                    onChanged: controller.updateBankAccount,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
