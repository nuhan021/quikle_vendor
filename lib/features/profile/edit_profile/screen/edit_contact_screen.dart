import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/custom_textfield.dart';
import '../../../appbar/screen/appbar_screen.dart';

class EditContactInfoScreen extends StatelessWidget {
  const EditContactInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contactPersonController = TextEditingController(
      text: "Vikram Rajput",
    );
    final phoneController = TextEditingController(text: "+963-172-345678");
    final addressController = TextEditingController(
      text: "House 34, Road 12, Dhanmondi, Dhaka",
    );
    final openingHoursController = TextEditingController(
      text: "9:00 AM - 8:00 PM",
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppbarScreen(title: "Edit Contact Info"),
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
                    "Edit Contact Information",
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Contact Person
                  CustomTextField(
                    label: "Contact Person",
                    hintText: "Enter contact person name",
                    controller: contactPersonController,
                  ),
                  const SizedBox(height: 12),

                  /// Phone Number
                  CustomTextField(
                    label: "Phone Number",
                    hintText: "Enter phone number",
                    controller: phoneController,
                  ),
                  const SizedBox(height: 12),

                  /// Business Address
                  CustomTextField(
                    label: "Business Address",
                    hintText: "Enter business address",
                    controller: addressController,
                  ),
                  const SizedBox(height: 12),

                  /// Opening Hours
                  CustomTextField(
                    label: "Opening Hours",
                    hintText: "Enter opening hours",
                    controller: openingHoursController,
                  ),
                  const SizedBox(height: 20),

                  /// Save Button
                  CustomButton(
                    text: "Save Changes",
                    fontSize: 16,
                    onPressed: () {
                      // TODO: Save contact info logic
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
