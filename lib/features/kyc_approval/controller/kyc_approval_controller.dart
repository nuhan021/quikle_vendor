import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/logging/logger.dart';
import 'package:quikle_vendor/routes/app_routes.dart';

class KycApprovalController extends GetxController {
  /// -------------------- Observables --------------------
  var kycStatus = "pending".obs;

  @override
  void onInit() {
    super.onInit();
    // Get KYC status from arguments or from stored vendor details
    _loadKycStatus();
  }

  /// Load KYC status from arguments only
  void _loadKycStatus() {
    // Get KYC status from navigation arguments only
    final argumentKycStatus = Get.arguments?['kycStatus'] as String?;

    if (argumentKycStatus != null && argumentKycStatus.isNotEmpty) {
      kycStatus.value = argumentKycStatus.toLowerCase();
      AppLoggerHelper.info('📋 KYC Status from arguments: ${kycStatus.value}');
    } else {
      // Default to "pending" if no argument provided
      AppLoggerHelper.warning(
        '⚠️ No KYC status from arguments, using default: pending',
      );
      kycStatus.value = "pending";
    }
  }

  /// -------------------- Fetch from API --------------------
  Future<void> fetchKycStatus() async {
    await Future.delayed(const Duration(milliseconds: 800));
    _loadKycStatus();
  }

  /// -------------------- Resubmit KYC --------------------
  Future<void> resubmitKyc() async {
    // Navigate back to vendor selection to select vendor type again
    Get.offAllNamed(AppRoute.vendorSelectionScreen);
  }

  /// -------------------- Update Profile --------------------
  Future<void> updateProfile() async {
    // Navigate to my profile screen
    Get.offAllNamed(AppRoute.myProfileScreen);
  }

  Future<void> goNavbar() async {
    await Get.offAllNamed(AppRoute.navbarScreen);
  }
}
