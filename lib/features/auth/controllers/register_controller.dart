import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/services/firebase/notification_service.dart';
import 'package:quikle_vendor/core/utils/logging/logger.dart';
import 'package:quikle_vendor/routes/app_routes.dart';
import '../data/services/auth_service.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  final isLoading = false.obs;
  final nameError = ''.obs;
  final phoneError = ''.obs;

  late final AuthService _auth;

  @override
  void onInit() {
    _auth = Get.find<AuthService>();
    nameController.addListener(() {
      if (nameError.value.isNotEmpty) {
        nameError.value = '';
      }
    });
    phoneController.addListener(() {
      if (phoneError.value.isNotEmpty) {
        phoneError.value = '';
      }
    });
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
      NotificationService.sendLocalNotification(
        title: 'OTP Sent',
        body: '${response.responseData['message']}',
      );
      Get.toNamed(
        AppRoute.getVerify(),
        arguments: {"phone": phone, "shopName": shopName, "isLogin": false},
      );
    } else {}

    isLoading.value = false;
  }

  bool _validateInputs() {
    final shopName = nameController.text.trim();
    final phone = phoneController.text.trim();

    bool isValid = true;

    if (shopName.isEmpty) {
      nameError.value = 'Shop name is required';
      isValid = false;
    } else {
      nameError.value = '';
    }

    if (phone.isEmpty) {
      phoneError.value = 'Phone number is required';
      isValid = false;
    } else {
      phoneError.value = '';
    }

    if (!isValid) return false;

    // Basic phone validation (remove spaces and dashes, check if it has digits)
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    if (!RegExp(r'^\+?91\d{10}$|^\d{10}$').hasMatch(cleanPhone)) {
      phoneError.value = 'Please enter a valid phone number';
      return false;
    }

    return true;
  }
}
