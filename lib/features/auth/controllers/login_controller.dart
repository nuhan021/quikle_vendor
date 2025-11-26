import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/features/auth/data/services/auth_service.dart';
import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final phoneController = TextEditingController();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  late final AuthService _auth;

  @override
  void onInit() {
    _auth = Get.find<AuthService>();
    super.onInit();
  }

  Future<void> onTapLogin() async {
    final phone = phoneController.text.trim();

    if (phone.length < 10) {
      Get.snackbar(
        '❌',
        'Enter valid phone number',
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return;
    }

    isLoading.value = true;

    try {
      final res = await _auth.sendOtpForLogin(phone);

      if (res.isSuccess) {
        Get.toNamed(
          AppRoute.getVerify(),
          arguments: {"phone": phone, "isLogin": true},
        );
      } else {
        Get.snackbar(
          '❌',
          res.errorMessage,
          snackPosition: SnackPosition.TOP,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void onTapCreateAccount() {
    Get.toNamed(AppRoute.register);
  }
}
