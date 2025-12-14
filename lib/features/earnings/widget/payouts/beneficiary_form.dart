import 'package:flutter/material.dart';
import 'package:quikle_vendor/core/common/styles/global_text_style.dart';
import 'package:quikle_vendor/core/common/widgets/custom_button.dart';
import 'package:quikle_vendor/core/common/widgets/custom_textfield.dart';

class BeneficiaryForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController accountController;
  final TextEditingController ifscController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final VoidCallback onSubmit;

  const BeneficiaryForm({
    super.key,
    required this.nameController,
    required this.accountController,
    required this.ifscController,
    required this.emailController,
    required this.phoneController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //   Text(
          //     "Beneficiary Details",
          //     style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          //   ),
          //   const SizedBox(height: 16),
          CustomTextField(
            label: "Beneficiary Name",
            hintText: "e.g. John Doe",
            controller: nameController,
          ),
          const SizedBox(height: 12),

          CustomTextField(
            label: "Bank Account Number",
            hintText: "0000 0000 0000",
            keyboardType: TextInputType.number,
            controller: accountController,
          ),
          const SizedBox(height: 12),

          CustomTextField(
            label: "IFSC Code",
            hintText: "ABCD0123456",
            controller: ifscController,
          ),
          const SizedBox(height: 4),
          Text(
            "Indian Financial System Code",
            style: getTextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 12),

          CustomTextField(
            label: "Email Address",
            hintText: "john@example.com",
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
          ),
          const SizedBox(height: 12),

          CustomTextField(
            label: "Phone Number",
            hintText: "+1 234 567 890",
            keyboardType: TextInputType.phone,
            controller: phoneController,
          ),
          const SizedBox(height: 24),

          CustomButton(
            text: "Save Beneficiary",
            onPressed: onSubmit,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            borderRadius: 12,
            height: 48,
          ),
        ],
      ),
    );
  }
}
