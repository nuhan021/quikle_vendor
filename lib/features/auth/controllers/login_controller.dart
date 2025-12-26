import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/services/firebase/notification_service.dart';
import 'package:quikle_vendor/features/auth/data/services/auth_service.dart';
import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final phoneController = TextEditingController();
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final phoneError = ''.obs;

  late final AuthService _auth;

  @override
  void onInit() {
    _auth = Get.find<AuthService>();
    phoneController.addListener(() {
      if (phoneError.value.isNotEmpty) {
        phoneError.value = '';
      }
    });
    super.onInit();
  }

  Future<void> onTapLogin() async {
    final phone = phoneController.text.trim();

    if (phone.isEmpty) {
      phoneError.value = 'Phone number is required';
      return;
    }

    phoneError.value = ''; // Clear error

    if (phone.length < 10) {
      phoneError.value = 'Please enter a valid phone number';
      return;
    }

    isLoading.value = true;

    try {
      final res = await _auth.sendOtpForLogin(phone);

      if (res.isSuccess) {
        NotificationService.sendLocalNotification(
          title: 'OTP Sent',
          body: '${res.responseData['message']}',
        );
        Get.toNamed(
          AppRoute.getVerify(),
          arguments: {"phone": phone, "isLogin": true},
        );
      } else {}
    } finally {
      isLoading.value = false;
    }
  }

  void onTapCreateAccount() {
    Get.toNamed(AppRoute.register);
  }
}
