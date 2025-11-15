import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/custom_textfield.dart';
import '../../../appbar/screen/appbar_screen.dart';

class EditBusinessDetailsScreen extends StatelessWidget {
  const EditBusinessDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final panelLicenseController = TextEditingController(text: "Not Provided");
    final tinNumberController = TextEditingController(text: "+963-172-345678");

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppbarScreen(title: "Edit Business Details"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Form Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Edit Business Details",
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Panel License Number
                  CustomTextField(
                    label: "Panel License Number",
                    hintText: "Enter panel license number",
                    controller: panelLicenseController,
                  ),
                  const SizedBox(height: 12),

                  /// TIN Number
                  CustomTextField(
                    label: "TIN Number",
                    hintText: "Enter TIN number",
                    controller: tinNumberController,
                  ),
                  const SizedBox(height: 20),

                  /// Save Button
                  CustomButton(
                    text: "Save Changes",
                    fontSize: 16,
                    onPressed: () {
                      // TODO: Save business details logic
                      Get.back();
                    },
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    height: 50,
                    borderRadius: 8,
                    fontWeight: FontWeight.w600,
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
