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
        // Fetch vendor details if available
        final auth = Get.find<AuthService>();
        final vendorDetailsResponse = await auth.getVendorDetails();

        final vendorData =
            vendorDetailsResponse.responseData as Map<String, dynamic>;

        // Save vendor profile if exists
        if (vendorData['vendor_profile'] != null) {
          await StorageService.saveVendorDetails(vendorData['vendor_profile']);
          log('✅ Vendor profile saved');
        } else {
          log('ℹ️ No vendor profile in response');
        }

        // Always navigate to navbar if token exists
        log('✅ Navigating to Navbar Screen');
        Get.offAllNamed(AppRoute.navbarScreen);
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
