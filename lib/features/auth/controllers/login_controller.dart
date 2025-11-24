import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:quikle_vendor/features/auth/controllers/auth_controller.dart';
import 'package:quikle_vendor/features/auth/presentation/screens/resgiter_screen.dart';

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
      errorMessage.value = "Enter valid phone";
      return;
    }

    isLoading.value = true;

    final res = await _auth.sendOtpForLogin(phone);

    if (res.isSuccess) {
      Get.toNamed(
        AppRoute.getVerify(),
        arguments: {"phone": phone, "isLogin": true},
      );
    } else {
      errorMessage.value = res.errorMessage;
    }

    isLoading.value = false;
  }

  void onTapCreateAccount() {
    Get.to(RegisterScreen());
  }
}
