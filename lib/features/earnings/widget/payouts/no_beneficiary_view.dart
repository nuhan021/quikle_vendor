import 'package:flutter/material.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/styles/global_text_style.dart';

class NoBeneficiaryView extends StatelessWidget {
  final String title;
  final VoidCallback onAddBeneficiary;
  const NoBeneficiaryView({
    super.key,
    required this.title,
    required this.onAddBeneficiary,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          CustomButton(text: "Add Beneficiary", onPressed: onAddBeneficiary),
        ],
      ),
    );
  }
}
