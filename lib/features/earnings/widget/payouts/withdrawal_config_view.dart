import 'package:flutter/material.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_textfield.dart';

class WithdrawalConfigView extends StatelessWidget {
  static const List<String> _withdrawalFrequencyOptions = [
    "manual",
    "weekly",
    "monthly",
    "yearly",
  ];

  final String minAmount;
  final ValueChanged<String> onMinAmountChanged;

  final bool autoWithdrawalEnabled;
  final ValueChanged<bool> onToggleAutoWithdrawal;

  final String? paymentMethod;
  final ValueChanged<String> onPaymentMethodChanged;

  final String bankAccount;
  final ValueChanged<String> onBankAccountChanged;

  const WithdrawalConfigView({
    super.key,
    required this.minAmount,
    required this.onMinAmountChanged,
    required this.autoWithdrawalEnabled,
    required this.onToggleAutoWithdrawal,
    required this.paymentMethod,
    required this.onPaymentMethodChanged,
    required this.bankAccount,
    required this.onBankAccountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: .05), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Withdrawal Configuration",
            style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          CustomTextField(
            label: "Minimum Withdrawal Amount",
            controller: TextEditingController(text: minAmount),
            onChanged: onMinAmountChanged,
          ),
          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            value: paymentMethod,
            items: _withdrawalFrequencyOptions
                .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                .toList(),
            onChanged: (v) => onPaymentMethodChanged(v!),
          ),
        ],
      ),
    );
  }
}
