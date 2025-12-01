import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import 'package:quikle_vendor/core/utils/helpers/snackbar_helper.dart';
import 'package:quikle_vendor/features/auth/data/services/auth_service.dart';
import 'package:quikle_vendor/features/user/controllers/user_controller.dart';
import '../../../core/models/response_data.dart';
import '../../../routes/app_routes.dart';

class VerificationController extends GetxController {
  final otpDigits = List.generate(6, (_) => '').obs;

  // TextEditingControllers for OTP input fields
  late final List<TextEditingController> digits = List.generate(
    6,
    (_) => TextEditingController(),
  );

  // FocusNodes for OTP input fields
  late final List<FocusNode> focuses = List.generate(6, (_) => FocusNode());

  late final String phone = Get.arguments["phone"];
  late final bool isLogin = Get.arguments["isLogin"] ?? false;
  late final String? shopName = Get.arguments["shopName"];
  late final String? token = StorageService.token;

  final isVerifying = false.obs;

  late final AuthService _auth;

  @override
  void onInit() {
    _auth = Get.find<AuthService>();
    _startTimer();
    super.onInit();
  }

  Future<void> onTapVerifyLogin() async {
    final otp = otpDigits.join();

    if (otp.length != 6) {
      SnackBarHelper.error('Enter 6-digit OTP');
      return;
    }

    isVerifying.value = true;

    ResponseData response;

    response = await _auth.vendorLogin(phone, otp);

    if (response.isSuccess) {
      // Extract token and id from response
      if (response.responseData is Map) {
        final responseData = response.responseData as Map<String, dynamic>;
        final token = responseData['access_token'];
        final id =
            responseData['id']?.toString() ??
            responseData['user_id']?.toString() ??
            '';

        // Save token and id to storage
        if (token != null) {
          await StorageService.saveToken(token, id);
        }
      }

      // Call vendor details API
      final vendorDetailsResponse = await _auth.getVendorDetails();
      log('Vendor Details Response: ${vendorDetailsResponse.responseData}');

      // Check if response data is a Map
      if (vendorDetailsResponse.responseData is Map) {
        final vendorData =
            vendorDetailsResponse.responseData as Map<String, dynamic>;

        // Handle: Vendor profile not found
        if (vendorData['detail'] == 'Vendor profile not found.') {
          isVerifying.value = false;
          Get.offAllNamed(AppRoute.vendorSelectionScreen);
        }

        if (vendorDetailsResponse.statusCode == 200 &&
            vendorData['message'] == 'Vendor profile fetched successfully' &&
            vendorData['vendor_profile']['kyc_status'] == 'verified') {
          isVerifying.value = false;
          Get.offAllNamed(AppRoute.myProfileScreen);
        }

        if (vendorDetailsResponse.statusCode == 200 &&
            vendorData['message'] == 'Vendor profile fetched successfully' &&
            vendorData['vendor_profile']['kyc_status'] == 'submitted') {
          isVerifying.value = false;
          Get.offAllNamed(
            AppRoute.kycApprovalScreen,
            arguments: {'kycStatus': 'submitted'},
          );
        }

        // Handle successful response with vendor_profile
        if (vendorData['vendor_profile'] != null) {
          final vendorProfile =
              vendorData['vendor_profile'] as Map<String, dynamic>;

          // Store vendor details in UserController
          Get.find<UserController>().setVendorDetails(vendorProfile);

          isVerifying.value = false;

          // Simple navigation: based on is_completed only
          final isCompleted = vendorProfile['is_completed'] as bool? ?? false;

          if (isCompleted) {
            Get.offAllNamed(AppRoute.homeScreen);
          } else {
            // Let each screen decide based on kyc_status
            Get.offAllNamed(AppRoute.myProfileScreen);
          }
          return;
        }
      }

      // Any other error case
      SnackBarHelper.error('Failed to fetch vendor details');
      isVerifying.value = false;
    } else {
      SnackBarHelper.error(response.errorMessage);
      isVerifying.value = false;
    }
  }

  Future<void> onTapVerifySignup() async {
    final otp = otpDigits.join();

    if (otp.length != 6) {
      SnackBarHelper.error('Enter 6-digit OTP');
      return;
    }

    isVerifying.value = true;

    ResponseData response;

    response = await _auth.vendorSignup(shopName!, phone, otp);

    if (response.isSuccess) {
      SnackBarHelper.success('Signup Successful');
      Get.offAllNamed(AppRoute.login);
    } else {
      SnackBarHelper.error(response.errorMessage);
      isVerifying.value = false;
    }
  }

  bool get canResend => secondsLeft.value == 0;

  final secondsLeft = 30.obs;
  Timer? _timer;

  void _startTimer() {
    secondsLeft.value = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft.value > 0) {
        secondsLeft.value--;
      } else {
        t.cancel();
      }
    });
  }

  Future<void> onTapResend() async {
    if (!canResend) return;

    final res = isLogin
        ? await _auth.sendOtpForLogin(phone)
        : await _auth.sendOtpForSignup(phone);

    if (res.isSuccess) {
      SnackBarHelper.success('OTP Sent Successfully');
      _startTimer();
    } else {
      SnackBarHelper.error(res.errorMessage);
    }
  }

  @override
  void onClose() {
    for (var controller in digits) {
      controller.dispose();
    }
    for (var focus in focuses) {
      focus.dispose();
    }
    otpDigits.clear();
    _timer?.cancel();
    super.onClose();
  }

  void onDigitChanged(int index, String value) {
    if (value.isEmpty) {
      otpDigits[index] = '';
      if (index > 0) {
        focuses[index - 1].requestFocus();
      }
    } else if (value.length == 1) {
      otpDigits[index] = value;
      digits[index].text = value;
      if (index < 5) {
        focuses[index + 1].requestFocus();
      }
    }
  }
}
