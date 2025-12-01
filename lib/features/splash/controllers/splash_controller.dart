import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';

import 'package:video_player/video_player.dart';

import '../../auth/presentation/screens/login_screen.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/helpers/snackbar_helper.dart';
import '../../auth/data/services/auth_service.dart';
import '../../../routes/app_routes.dart';
import '../../user/controllers/user_controller.dart';

class SplashController extends GetxController {
  // final networkController = Get.find<NetworkController>();
  late final VideoPlayerController video;
  final RxBool isReady = false.obs;
  final RxBool shouldShrink = false.obs;

  static const double _ellipseTopFinal = 666.0;
  final RxDouble ellipseTop = _ellipseTopFinal.obs;

  final RxBool showEllipse = false.obs;
  final RxBool showLogin = false.obs;

  final Duration shrinkDelay = const Duration(milliseconds: 20);
  final Duration ellipseTriggerAt = const Duration(seconds: 2);
  final Duration playDuration = const Duration(seconds: 3);

  bool _ellipseMoved = false;

  @override
  void onInit() {
    super.onInit();
    _initVideo();
  }

  Future<void> _initVideo() async {
    video = VideoPlayerController.asset('assets/videos/splash_intro.mp4');
    await video.initialize();
    await video.setVolume(0);
    await video.play();
    isReady.value = true;

    Future.delayed(shrinkDelay, () {
      shouldShrink.value = true;
    });

    video.addListener(_progressWatcher);
    video.addListener(_listenDuration);
  }

  void _progressWatcher() {
    final v = video.value;
    if (!_ellipseMoved && v.isInitialized && v.position >= ellipseTriggerAt) {
      _ellipseMoved = true;
      showEllipse.value = true;
      video.removeListener(_progressWatcher);
    }
  }

  void _listenDuration() async {
    final v = video.value;
    if (v.isInitialized && v.position >= playDuration) {
      video.pause();
      video.removeListener(_listenDuration);

      await _handleNavigation();
    }
  }

  Future<void> _handleNavigation() async {
    if (StorageService.hasToken()) {
      // Call vendor details API
      final auth = Get.find<AuthService>();
      final vendorDetailsResponse = await auth.getVendorDetails();

      // Check if response data is a Map
      if (vendorDetailsResponse.responseData is Map) {
        final vendorData =
            vendorDetailsResponse.responseData as Map<String, dynamic>;

        if (vendorData['vendor_profile'] ==
                'Vendor profile fetched successfully' &&
            vendorData['vendor_profile']['is_completed'] == true) {
          log('✅ Navigated to Navbar Screen 1');
          Get.offAllNamed(AppRoute.navbarScreen);
        }
        // Handle: Vendor profile not found
        else if (vendorData['detail'] == 'Vendor profile not found.') {
          Get.offAllNamed(AppRoute.vendorSelectionScreen);
        } else if (vendorDetailsResponse.statusCode == 200 &&
            vendorData['message'] == 'Vendor profile fetched successfully' &&
            vendorData['vendor_profile']['kyc_status'] == 'verified') {
          log('✅ Navigated to Navbar Screen 2');
          Get.offAllNamed(AppRoute.navbarScreen);
        } else if (vendorDetailsResponse.statusCode == 200 &&
            vendorData['message'] == 'Vendor profile fetched successfully' &&
            vendorData['vendor_profile']['kyc_status'] == 'submitted') {
          Get.offAllNamed(
            AppRoute.kycApprovalScreen,
            arguments: {'kycStatus': 'submitted'},
          );
        } else if (vendorDetailsResponse.statusCode == 200 &&
            vendorData['message'] == 'Vendor profile fetched successfully' &&
            vendorData['vendor_profile']['kyc_status'] == 'rejected') {
          Get.offAllNamed(
            AppRoute.kycApprovalScreen,
            arguments: {'kycStatus': 'rejected'},
          );
        }
      } else {
        // Any other error case
        SnackBarHelper.error('Failed to fetch vendor details');
        Get.off(() => const LoginScreen());
      }
    } else {
      Get.off(() => const LoginScreen());
    }
  }

  @override
  void onClose() {
    video.removeListener(_progressWatcher);
    video.removeListener(_listenDuration);
    video.dispose();
    super.onClose();
  }
}
