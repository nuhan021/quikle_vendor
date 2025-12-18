import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/features/profile/my_profile/widget/profile_field.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../routes/app_routes.dart';
import '../controller/my_profile_controller.dart';

class KycStatusCard extends StatelessWidget {
  const KycStatusCard({super.key});

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
            /// Title + Edit Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'KYC Verification',
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                CustomButton(
                  width: 50,
                  height: 26,
                  text: "Edit",
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // Navigate to vendor selection screen to start KYC update flow
                    Get.toNamed(
                      AppRoute.vendorSelectionScreen,
                      arguments: {'fromProfile': true},
                    );
                  },
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 14,
                  borderRadius: 6,
                ),
              ],
            ),
            const Divider(height: 24, thickness: 0.8),

            /// KYC Status with color indicator
            Row(
              children: [
                Text(
                  'Status: ',
                  style: getTextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(
                      controller.kycStatus.value,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(controller.kycStatus.value),
                    style: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(controller.kycStatus.value),
                    ),
                  ),
                ),
              ],
            ),

            if (controller.nidNumberDisplay.value.isNotEmpty) ...[
              // Divider(height: 20.h),
              // ProfileField(
              //   label: "NID Number",
              //   value: controller.nidNumberDisplay.value,
              //   showDivider: false,
              // ),
            ],

            if (controller.kycDocumentUrl.value.isNotEmpty) ...[
              // Divider(height: 20.h),
              // ProfileField(
              //   label: "KYC Document",
              //   value: "Uploaded",
              //   showDivider: false,
              // ),
            ],
          ],
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
        return 'Verified ✓';
      case 'submitted':
      case 'pending':
        return 'Pending';
      case 'rejected':
        return 'Rejected';
      case 'skipped':
        return 'Not Submitted';
      default:
        return 'Not Submitted';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
        return Colors.green;
      case 'submitted':
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
