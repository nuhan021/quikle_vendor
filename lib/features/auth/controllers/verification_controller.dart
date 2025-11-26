import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import 'package:quikle_vendor/core/utils/logging/logger.dart';
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
      Get.snackbar(
        '❌',
        'Enter 6-digit OTP',
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return;
    }

    isVerifying.value = true;

    ResponseData response;

    response = await _auth.vendorLogin(phone, otp);
    AppLoggerHelper.info('📱 Vendor Login Response: ${response.responseData}');

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
          AppLoggerHelper.info('✅ Token and ID saved to storage');
          AppLoggerHelper.info('✅Token: $token');
          AppLoggerHelper.info('User ID: $id');
        }
      }

      // Call vendor details API
      AppLoggerHelper.debug('Token is: ${StorageService.token}');
      AppLoggerHelper.debug('Token is: $token');
      final vendorDetailsResponse = await _auth.getVendorDetails();
      AppLoggerHelper.debug('✅ ========== VENDOR DETAILS RESPONSE ==========');
      AppLoggerHelper.info('Status Code: ${vendorDetailsResponse.statusCode}');
      AppLoggerHelper.info('Is Success: ${vendorDetailsResponse.isSuccess}');

      AppLoggerHelper.debug(
        '📱 Vendor Details Response: ${vendorDetailsResponse.responseData}',
      );

      // AppLoggerHelper.debug('✅ ========== VENDOR DETAILS RESPONSE ==========');
      // AppLoggerHelper.info('Status Code: ${vendorDetailsResponse.statusCode}');
      // AppLoggerHelper.info('Is Success: ${vendorDetailsResponse.isSuccess}');
      // AppLoggerHelper.info(
      //   'Full Response: ${vendorDetailsResponse.responseData}',
      // );
      // AppLoggerHelper.info(
      //   'Error Message: ${vendorDetailsResponse.errorMessage}',
      // );

      // // Store vendor details in UserController
      // if (vendorDetailsResponse.isSuccess &&
      //     vendorDetailsResponse.responseData is Map) {
      //   final vendorData =
      //       vendorDetailsResponse.responseData as Map<String, dynamic>;
      //   AppLoggerHelper.debug('🏪 ========== VENDOR DETAILS DATA ==========');
      //   AppLoggerHelper.info('Vendor Data Keys: ${vendorData.keys.toList()}');
      //   vendorData.forEach((key, value) {
      //     AppLoggerHelper.info('  $key: $value');
      //   });

      //   if (vendorData['vendor_profile'] != null) {
      //     final vendorProfile =
      //         vendorData['vendor_profile'] as Map<String, dynamic>;
      //     AppLoggerHelper.debug(
      //       '👤 ========== VENDOR PROFILE DETAILS ==========',
      //     );
      //     AppLoggerHelper.info('Shop Name: ${vendorProfile['shop_name']}');
      //     AppLoggerHelper.info('Email: ${vendorProfile['email']}');
      //     AppLoggerHelper.info('Phone: ${vendorProfile['phone']}');
      //     AppLoggerHelper.info('Type: ${vendorProfile['type']}');
      //     AppLoggerHelper.info('Is Active: ${vendorProfile['is_active']}');
      //     AppLoggerHelper.info('NID: ${vendorProfile['nid']}');
      //     AppLoggerHelper.info('KYC Status: ${vendorProfile['kyc_status']}');
      //     AppLoggerHelper.info('Latitude: ${vendorProfile['latitude']}');
      //     AppLoggerHelper.info('Longitude: ${vendorProfile['longitude']}');
      //     AppLoggerHelper.info('Location: ${vendorProfile['location_name']}');
      //     AppLoggerHelper.debug('==========================================');

      //     Get.find<UserController>().setVendorDetails(vendorProfile);
      //   }
      // }

      // Get.snackbar(
      //   '✅',
      //   'Login Successful',
      //   snackPosition: SnackPosition.TOP,
      //   colorText: Colors.white,
      //   backgroundColor: Colors.green,
      // );
      Get.offAllNamed(AppRoute.vendorSelectionScreen);
    } else {
      Get.snackbar(
        '❌',
        response.errorMessage,
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      isVerifying.value = false;
    }
  }

  Future<void> onTapVerifySignup() async {
    final otp = otpDigits.join();

    if (otp.length != 6) {
      Get.snackbar(
        '❌',
        'Enter 6-digit OTP',
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return;
    }

    isVerifying.value = true;

    ResponseData response;

    response = await _auth.vendorSignup(shopName!, phone, otp);

    if (response.isSuccess) {
      Get.snackbar(
        '✅',
        'Signup Successful',
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        backgroundColor: Colors.green,
      );
      Get.offAllNamed(AppRoute.login);
    } else {
      Get.snackbar(
        '❌',
        response.errorMessage,
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
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
      Get.snackbar(
        '✅',
        'OTP Sent Successfully',
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        backgroundColor: Colors.green,
      );
      _startTimer();
    } else {
      Get.snackbar(
        '❌',
        res.errorMessage,
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
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
