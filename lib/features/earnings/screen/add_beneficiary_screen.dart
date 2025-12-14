import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import 'package:quikle_vendor/features/appbar/screen/appbar_screen.dart';
import 'package:quikle_vendor/features/earnings/widget/payouts/beneficiary_form.dart';
import '../controller/payouts_controller.dart';
import '../model/beneficiary_model.dart';

class AddBeneficiaryScreen extends StatelessWidget {
  AddBeneficiaryScreen({super.key});

  final nameController = TextEditingController();
  final accountController = TextEditingController();
  final ifscController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final payoutsController = Get.find<PayoutsController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppbarScreen(title: "Add Beneficiary"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: BeneficiaryForm(
          nameController: nameController,
          accountController: accountController,
          ifscController: ifscController,
          emailController: emailController,
          phoneController: phoneController,
          onSubmit: () async {
            final beneficiary = BeneficiaryModel(
              name: nameController.text.trim(),
              bankAccount: accountController.text.trim(),
              ifsc: ifscController.text.trim(),
              email: emailController.text.trim(),
              phone: phoneController.text.trim(),
            );

            // show loading
            Get.dialog(
              const Center(child: CircularProgressIndicator()),
              barrierDismissible: false,
            );

            final response = await payoutsController.addBeneficiaryRemote(
              beneficiary,
            );

            // close loading
            if (Get.isDialogOpen ?? false) Get.back();

            if (response.isSuccess) {
              Get.back(); // return to payouts tab
              Get.snackbar('Success', 'Beneficiary added successfully');
            } else {
              Get.snackbar(
                'Error',
                response.errorMessage.isNotEmpty
                    ? response.errorMessage
                    : 'Failed to add beneficiary',
              );
            }
          },
        ),
      ),
    );
  }
}
