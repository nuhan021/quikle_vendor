import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/features/profile/my_profile/widget/profile_field.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/custom_textfield.dart';
import '../controller/my_profile_controller.dart';

class BasicInfoCard extends StatelessWidget {
  const BasicInfoCard({super.key});

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
                  "Basic Information",
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                CustomButton(
                  width: controller.isBasicInfoEditing.value ? 56 : 50,
                  height: 26,
                  text: controller.isBasicInfoEditing.value ? "Save" : "Edit",
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  onPressed: controller.isBasicInfoEditing.value
                      ? controller.saveBasicInfo
                      : controller.toggleBasicInfoEdit,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 14,
                  borderRadius: 6,
                ),
              ],
            ),
            const Divider(height: 24, thickness: 0.8),

            /// Editable Fields or Display
            if (controller.isBasicInfoEditing.value) ...[
              CustomTextField(
                label: "Business Name",
                hintText: "Enter business name",
                controller: controller.businessNameController,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: "Owner Name",
                hintText: "Enter owner name",
                controller: controller.ownerNameController,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: "Account Status",
                hintText: "Enter account status",
                controller: controller.accountStatusController,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: "Services Offered",
                hintText: "Describe services offered",
                controller: controller.servicesController,
                maxLines: 4,
              ),
            ] else ...[
              ProfileField(
                label: "Business Name",
                value: controller.businessNameController.text,
              ),
              ProfileField(
                label: "Owner Name",
                value: controller.ownerNameController.text,
              ),
              ProfileField(
                label: "Account Status",
                value: controller.accountStatusController.text,
              ),
              ProfileField(
                label: "Services Offered",
                value: controller.servicesController.text,
                showDivider: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
