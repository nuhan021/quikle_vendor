import 'package:flutter/material.dart';
import '../../../../core/common/styles/global_text_style.dart';

class BeneficiaryCardView extends StatelessWidget {
  final String name;
  final String account;
  final String ifsc;
  final VoidCallback onTap;

  const BeneficiaryCardView({
    super.key,
    required this.name,
    required this.account,
    required this.ifsc,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text("Account: $account"),
            Text("IFSC: $ifsc"),
          ],
        ),
      ),
    );
  }
}
