import 'package:flutter/material.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_button.dart';

class AvailableBalanceCard extends StatelessWidget {
  final String title;
  final String balanceText;
  final String subtitle;
  final VoidCallback onWithdraw;
  final bool showWithdrawButton;

  const AvailableBalanceCard({
    super.key,
    required this.title,
    required this.balanceText,
    required this.subtitle,
    required this.onWithdraw,
    this.showWithdrawButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                title,
                style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Text(
                balanceText,
                style: getTextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                style: getTextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),

          if (showWithdrawButton)
            CustomButton(
              height: 32,
              width: 87,
              text: "Withdraw",
              onPressed: onWithdraw,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 12,
              borderRadius: 8,
            ),
        ],
      ),
    );
  }
}
