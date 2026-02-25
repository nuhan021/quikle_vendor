import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../data/services/auth_service.dart';
import '../../../routes/app_routes.dart';
import '../../auth/presentation/screens/login_screen.dart';

class WelcomeController extends GetxController {
  final int delayMs = 1200;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _timer = Timer(Duration(milliseconds: delayMs), () {
      _handleNavigation();
    });
  }

  Future<void> _handleNavigation() async {
    try {
      if (StorageService.hasToken()) {
        final auth = Get.find<AuthService>();
        final vendorDetailsResponse = await auth.getVendorDetails();

        final vendorData =
            vendorDetailsResponse.responseData as Map<String, dynamic>;

        if (vendorData['message'] == 'Vendor profile fetched successfully' &&
            vendorData['vendor_profile']['is_completed'] == true) {
          log('✅ Navigated to Navbar Screen - Profile Completed');
          await StorageService.saveVendorDetails(vendorData['vendor_profile']);
          Get.offAllNamed(AppRoute.navbarScreen);
          return;
        }
        if (vendorData['detail'] == 'Vendor profile not found.') {
          log('📋 Navigating to Vendor Selection');
          Get.offAllNamed(AppRoute.vendorSelectionScreen);
          return;
        }

        if (vendorDetailsResponse.statusCode == 200 &&
            vendorData['message'] == 'Vendor profile fetched successfully' &&
            vendorData['vendor_profile']['kyc_status'] == 'verified') {
          log('✅ Navigated to Navbar Screen - KYC Verified');
          await StorageService.saveVendorDetails(vendorData['vendor_profile']);
          Get.offAllNamed(
            AppRoute.kycApprovalScreen,
            arguments: {'kycStatus': 'verified'},
          );
          return;
        }

        if (vendorDetailsResponse.statusCode == 200 &&
            vendorData['message'] == 'Vendor profile fetched successfully' &&
            vendorData['vendor_profile']['kyc_status'] == 'submitted') {
          log('⏳ Navigating to KYC Approval - Submitted');
          await StorageService.saveVendorDetails(vendorData['vendor_profile']);
          Get.offAllNamed(
            AppRoute.kycApprovalScreen,
            arguments: {'kycStatus': 'submitted'},
          );
          return;
        }

        if (vendorDetailsResponse.statusCode == 200 &&
            vendorData['message'] == 'Vendor profile fetched successfully' &&
            vendorData['vendor_profile']['kyc_status'] == 'rejected') {
          log('❌ Navigating to KYC Approval - Rejected');
          await StorageService.saveVendorDetails(vendorData['vendor_profile']);
          Get.offAllNamed(
            AppRoute.kycApprovalScreen,
            arguments: {'kycStatus': 'rejected'},
          );
          return;
        }

        log('Default navigation - Profile incomplete or unknown status');
        Get.offAllNamed(AppRoute.vendorSelectionScreen);
        return;
      } else {
        log('🔓 No token found - Navigating to Login');
        await Future.delayed(const Duration(milliseconds: 700));
        Get.offAllNamed(AppRoute.login);
      }
    } catch (e, stackTrace) {
      log('Error in _handleNavigation: $e');
      log('StackTrace: $stackTrace');
      Get.off(() => const LoginScreen());
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
