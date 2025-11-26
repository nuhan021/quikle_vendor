import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/logging/logger.dart';
import 'package:quikle_vendor/routes/app_routes.dart';
import '../data/services/auth_service.dart';

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

    final response = await _auth.sendOtpForSignup(phone);
    AppLoggerHelper.info('📱 Send OTP Response: ${response.responseData}');

    if (response.isSuccess) {
      Get.toNamed(
        AppRoute.getVerify(),
        arguments: {"phone": phone, "shopName": shopName, "isLogin": false},
      );
    } else {
      Get.snackbar(
        '❌',
        response.errorMessage,
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }

    isLoading.value = false;
  }

  bool _validateInputs() {
    final shopName = nameController.text.trim();
    final phone = phoneController.text.trim();

    if (shopName.isEmpty) {
      Get.snackbar(
        '❌',
        'Please enter shop name',
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return false;
    }

    if (phone.isEmpty) {
      Get.snackbar(
        '❌',
        'Please enter phone number',
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return false;
    }

    // Basic phone validation (remove spaces and dashes, check if it has digits)
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    if (!RegExp(r'^\+?91\d{10}$|^\d{10}$').hasMatch(cleanPhone)) {
      Get.snackbar(
        '❌',
        'Please enter a valid phone number',
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return false;
    }

    return true;
  }
}
