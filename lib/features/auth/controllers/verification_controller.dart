import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/models/response_data.dart';
import '../../../routes/app_routes.dart';
import 'auth_controller.dart';

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

  final isVerifying = false.obs;

  late final AuthService _auth;

  @override
  void onInit() {
    _auth = Get.find<AuthService>();
    _startTimer();
    super.onInit();
  }

  Future<void> onTapVerify() async {
    final otp = otpDigits.join();

    if (otp.length != 6) {
      print('❌ Verification Error: Enter 6-digit OTP');
      return;
    }

    isVerifying.value = true;

    ResponseData res;

    if (isLogin) {
      // LOGIN FLOW
      res = await _auth.verifyLogin(phone, otp);
    } else {
      // SIGNUP FLOW
      res = await _auth.vendorSignup(shopName!, phone, otp);
    }

    if (res.isSuccess) {
      Get.offAllNamed(AppRoute.vendorSelectionScreen);
    } else {
      print('❌ Verification Error: ${res.errorMessage}');
    }

    isVerifying.value = false;
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
      _startTimer();
    } else {
      print('❌ Resend OTP Error: ${res.errorMessage}');
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
