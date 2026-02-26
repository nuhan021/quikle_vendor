import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/logging/logger.dart';
import 'package:quikle_vendor/routes/app_routes.dart';

class KycApprovalController extends GetxController {
  var kycStatus = "pending".obs;

  @override
  void onInit() {
    super.onInit();
    _loadKycStatus();
  }

  void _loadKycStatus() {
    final argumentKycStatus = Get.arguments?['kycStatus'] as String?;

    if (argumentKycStatus != null && argumentKycStatus.isNotEmpty) {
      kycStatus.value = argumentKycStatus.toLowerCase();
      AppLoggerHelper.info('📋 KYC Status from arguments: ${kycStatus.value}');
    } else {
      AppLoggerHelper.warning(
        '⚠️ No KYC status from arguments, using default: pending',
      );
      kycStatus.value = "pending";
    }
  }

  Future<void> fetchKycStatus() async {
    await Future.delayed(const Duration(milliseconds: 800));
    _loadKycStatus();
  }

  Future<void> resubmitKyc() async {
    Get.offAllNamed(AppRoute.vendorSelectionScreen);
  }

  Future<void> updateProfile() async {
    Get.offAllNamed(AppRoute.myProfileScreen);
  }

  Future<void> goNavbar() async {
    await Get.offAllNamed(AppRoute.navbarScreen);
  }
}
