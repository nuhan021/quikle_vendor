import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/features/profile/my_profile/widget/profile_field.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/custom_textfield.dart';
import '../controller/my_profile_controller.dart';

class ContactInfoCard extends StatelessWidget {
  const ContactInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MyProfileController>();

    return Obx(
      () => Container(
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
            /// Title + Edit/Save Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Contact Information',
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                CustomButton(
                  width: controller.isContactInfoEditing.value ? 56 : 50,
                  height: 26,
                  text: controller.isContactInfoEditing.value ? "Save" : "Edit",
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  onPressed: controller.isContactInfoEditing.value
                      ? controller.saveContactInfo
                      : controller.toggleContactInfoEdit,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 14,
                  borderRadius: 6,
                ),
              ],
            ),
            const Divider(height: 24, thickness: 0.8),

            /// Editable Fields or Display
            if (controller.isContactInfoEditing.value) ...[
              CustomTextField(
                label: "Contact Person",
                hintText: "Enter contact person name",
                controller: controller.contactPersonController,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: "Phone Number",
                hintText: "Enter phone number",
                controller: controller.phoneController,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: "Business Address",
                hintText: "Enter business address",
                controller: controller.addressController,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: "Opening Hours",
                hintText: "Enter opening hours",
                controller: controller.openingHoursController,
              ),
            ] else ...[
              ProfileField(
                label: "Contact Person",
                value: controller.contactPersonController.text,
              ),
              ProfileField(
                label: "Phone Number",
                value: controller.phoneController.text,
              ),
              ProfileField(
                label: "Business Address",
                value: controller.addressController.text,
              ),
              ProfileField(
                label: "Opening Hours",
                value: controller.openingHoursController.text,
                showDivider: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
