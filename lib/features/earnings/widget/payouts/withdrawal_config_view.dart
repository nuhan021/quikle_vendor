import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_textfield.dart';

class WithdrawalConfigView extends StatefulWidget {
  static const List<String> _withdrawalFrequencyOptions = [
    "manual",
    "weekly",
    "monthly",
    "yearly",
  ];

  final String minAmount;
  final ValueChanged<String> onMinAmountChanged;
  final String? paymentMethod;
  final ValueChanged<String> onPaymentMethodChanged;

  const WithdrawalConfigView({
    super.key,
    required this.minAmount,
    required this.onMinAmountChanged,
    required this.paymentMethod,
    required this.onPaymentMethodChanged,
  });

  @override
  State<WithdrawalConfigView> createState() => _WithdrawalConfigViewState();
}

class _WithdrawalConfigViewState extends State<WithdrawalConfigView> {
  late final TextEditingController _minAmountController;

  @override
  void initState() {
    super.initState();
    _minAmountController = TextEditingController(text: widget.minAmount);
  }

  @override
  void didUpdateWidget(covariant WithdrawalConfigView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.minAmount != _minAmountController.text) {
      _minAmountController.value = TextEditingValue(
        text: widget.minAmount,
        selection: TextSelection.collapsed(offset: widget.minAmount.length),
      );
    }
  }

  @override
  void dispose() {
    _minAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedMethod =
        WithdrawalConfigView._withdrawalFrequencyOptions.contains(
          widget.paymentMethod,
        )
        ? widget.paymentMethod
        : null;

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
            hintText: "500",
            controller: _minAmountController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: widget.onMinAmountChanged,
          ),
          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            initialValue: selectedMethod,
            decoration: const InputDecoration(
              labelText: "Auto Payout Status",
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(),
            ),
            items: WithdrawalConfigView._withdrawalFrequencyOptions
                .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                .toList(),
            onChanged: (v) {
              if (v != null) {
                widget.onPaymentMethodChanged(v);
              }
            },
          ),
          const SizedBox(height: 16),

          Text(
            "This updates your beneficiary auto payout settings.",
            style: getTextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
