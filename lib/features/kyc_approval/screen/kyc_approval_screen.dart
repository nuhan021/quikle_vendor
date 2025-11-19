import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/features/profile/my_profile/screen/my_profile_screen.dart';
import 'package:quikle_vendor/routes/app_routes.dart' show AppRoute;
import '../../../../core/common/styles/global_text_style.dart';
import '../../appbar/screen/appbar_screen.dart';
import '../controller/kyc_approval_controller.dart';
import '../widget/kyc_status_card.dart';

class KycApprovalScreen extends StatelessWidget {
  const KycApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(KycApprovalController());
    controller.fetchKycStatus(); // fetch current KYC status

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: const AppbarScreen(title: "KYC Approval"),
      body: Obx(() {
        final status = controller.kycStatus.value;

        switch (status) {
          case "pending":
            return Center(
              child: StatusCard(
                icon: Icons.hourglass_top,
                color: Colors.orange,
                title: "Documents Submitted",
                subtitle:
                    "Your KYC documents have been submitted\nand are waiting for approval.",
                buttonText: "Check Again",
                onButtonTap: controller.fetchKycStatus,
              ),
            );

          case "approved":
            return Center(
              child: StatusCard(
                icon: Icons.verified,
                color: Colors.green,
                title: "KYC Approved!",
                subtitle:
                    "Your documents have been successfully verified.\nYou’re all set!",
                buttonText: "Update Profile",
                onButtonTap: () {
                  Get.offAll(MyProfileScreen(fromKycFlow: true));
                },
              ),
            );

          case "rejected":
            return Center(
              child: StatusCard(
                icon: Icons.cancel,
                color: Colors.red,
                title: "KYC Rejected",
                subtitle:
                    "Your verification was rejected.\nPlease re-upload your documents.",
                buttonText: "Verify KYC Again",
                onButtonTap: () {
                  // ✅ Navigate back to KYC upload screen
                  Get.offAllNamed(AppRoute.kycVerificationScreen);
                },
              ),
            );

          default:
            return Center(
              child: Text(
                "Unknown status: $status",
                style: getTextStyle(fontSize: 15, color: Colors.black54),
              ),
            );
        }
      }),
    );
  }
}
