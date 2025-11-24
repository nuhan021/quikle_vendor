import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:quikle_vendor/core/utils/logging/logger.dart';
import 'package:quikle_vendor/features/auth/controllers/auth_controller.dart';
import 'package:quikle_vendor/routes/app_routes.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  final isLoading = false.obs;

  late final AuthService _auth;

  @override
  void onInit() {
    _auth = Get.find<AuthService>();
    super.onInit();
  }

  Future<void> onTapCreateAccount() async {
    if (!_validateInputs()) return;

    isLoading.value = true;

    final shopName = nameController.text.trim();
    final phone = phoneController.text.trim();

    final res = await _auth.sendOtpForSignup(phone);
    AppLoggerHelper.info('📱 Send OTP Response: ${res.responseData}');

    if (res.isSuccess) {
      Get.toNamed(
        AppRoute.getVerify(),
        arguments: {"phone": phone, "shopName": shopName, "isLogin": false},
      );
    } else {
      print('❌ Send OTP Error: ${res.errorMessage}');
    }

    isLoading.value = false;
  }

  bool _validateInputs() {
    final shopName = nameController.text.trim();
    final phone = phoneController.text.trim();

    if (shopName.isEmpty) {
      print('❌ Validation Error: Please enter shop name');
      return false;
    }

    if (phone.isEmpty) {
      print('❌ Validation Error: Please enter phone number');
      return false;
    }

    // Basic phone validation (remove spaces and dashes, check if it has digits)
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    if (!RegExp(r'^\+?91\d{10}$|^\d{10}$').hasMatch(cleanPhone)) {
      print('❌ Validation Error: Please enter a valid phone number');
      return false;
    }

    return true;
  }
}
