import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/features/profile/edit_profile/screen/edit_profile_screen.dart';
import 'package:quikle_vendor/features/profile/my_profile/widget/profile_field.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_button.dart';
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
                  text: "Edit",
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  onPressed: () => Get.to(EditProfileScreen()),
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 14,
                  borderRadius: 6,
                ),
              ],
            ),
            const Divider(height: 24, thickness: 0.8),

            ProfileField(
              label: "Owner Name",
              value: controller.ownerNameController.text,
            ),

            // ProfileField(
            //   label: "Phone Number",
            //   value: controller.phoneController.text,
            // ),
            // ProfileField(
            //   label: "Business Address",
            //   value: controller.addressController.text,
            // ),
            ProfileField(
              label: "Vendor Type",
              value: controller.vendorDetails.type.toString(),
              showDivider: false,
            ),
            Divider(height: 20.h),

            ProfileField(
              label: "Active Status",
              value: controller.accountStatusController.text,
              showDivider: false,
            ),
            Divider(height: 20.h),

            ProfileField(
              label: "Phone Number",
              value: controller.phoneController.text,
              showDivider: false,
            ),
            Divider(height: 20.h),
            ProfileField(
              label: "NID Number",
              value: controller.tinNumberController.text,
              showDivider: false,
            ),
            Divider(height: 20.h),
            ProfileField(
              label: "Opening Hours",
              value: controller.openingHoursController.text,
              showDivider: false,
            ),
          ],
        ),
      ),
    );
  }
}
