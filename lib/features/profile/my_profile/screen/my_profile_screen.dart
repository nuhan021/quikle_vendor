import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:quikle_vendor/core/common/widgets/custom_button.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import 'package:quikle_vendor/core/utils/constants/image_path.dart';
import 'package:quikle_vendor/features/profile/my_profile/widget/contactInfoCard.dart';
import 'package:quikle_vendor/features/profile/my_profile/widget/kyc_status_card.dart';
import 'package:quikle_vendor/features/vendor/models/vendor_model.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import 'package:quikle_vendor/core/utils/widgets/network_image_with_fallback.dart';
import 'package:quikle_vendor/routes/app_routes.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../appbar/screen/appbar_screen.dart';
import '../controller/my_profile_controller.dart';

class MyProfileScreen extends StatelessWidget {
  final bool fromKycFlow;

  const MyProfileScreen({super.key, this.fromKycFlow = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyProfileController());
    final vendorData = StorageService.getVendorDetails();
    final vendorDetails = vendorData != null
        ? VendorDetailsModel.fromJson(vendorData)
        : null;
    log('vendorDetails: $vendorDetails');

    log("fromKycFlow: $fromKycFlow");
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppbarScreen(title: "My Profile"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Profile Header with editable image
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
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
                children: [
                  Obx(
                    () => CircularPercentIndicator(
                      radius: 55.0,
                      lineWidth: 5.0,
                      animation: true,
                      animationDuration: 1000,
                      percent:
                          controller.profileCompletionPercentage.value / 100,
                      center: ClipRRect(
                        borderRadius: BorderRadius.circular(45),
                        child: SizedBox(
                          width: 90,
                          height: 90,
                          child: _buildProfileImage(controller, vendorDetails),
                        ),
                      ),
                      footer: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '${controller.profileCompletionPercentage.value.toStringAsFixed(0)}% Complete',
                          style: getTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor:
                          controller.profileCompletionPercentage.value == 100
                          ? Colors.green
                          : controller.profileCompletionPercentage.value >= 70
                          ? AppColors.beakYellow
                          : controller.profileCompletionPercentage.value >= 40
                          ? Colors.orange
                          : Colors.red,
                      backgroundColor: Colors.grey.shade200,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    vendorDetails?.shopName ?? '',
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      vendorDetails?.locationName != null &&
                              vendorDetails!.locationName!.isNotEmpty
                          ? vendorDetails!.locationName!
                          : 'Add your business location',
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        fontSize: 14,
                        color:
                            vendorDetails?.locationName != null &&
                                vendorDetails!.locationName!.isNotEmpty
                            ? Colors.black54
                            : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Profile Info Card
            // const BasicInfoCard(),
            const SizedBox(height: 20),

            /// KYC Status Card
            const KycStatusCard(),
            const SizedBox(height: 20),

            /// Contact Info
            ContactInfoCard(fromKycFlow: fromKycFlow),
            const SizedBox(height: 20),

            if (fromKycFlow) ...[
              const SizedBox(height: 20),
              CustomButton(
                text: "Update",
                onPressed: () {
                  Get.offAllNamed(AppRoute.navbarScreen);
                },
                height: 48,
                width: double.infinity,
                borderRadius: 10,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 15,
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }

  /// Build profile image widget with fallback
  Widget _buildProfileImage(
    MyProfileController controller,
    VendorDetailsModel? vendorDetails,
  ) {
    // Priority 1: Local file image (recently picked)
    if (controller.profileImagePath.value != null) {
      return Image.file(
        File(controller.profileImagePath.value!),
        fit: BoxFit.cover,
      );
    }

    // Priority 2: Photo URL from SharedPreferences (API response)
    final vendorData = StorageService.getVendorDetails();
    if (vendorData != null && vendorData['photo'] != null) {
      final photoUrl = vendorData['photo'] as String;
      if (photoUrl.isNotEmpty) {
        return NetworkImageWithFallback(
          photoUrl,
          fallback: "assets/images/logo.png",
          fit: BoxFit.cover,
        );
      }
    }

    // Priority 3: Default asset image
    return Image.asset(ImagePath.logo, fit: BoxFit.cover);
  }
}
