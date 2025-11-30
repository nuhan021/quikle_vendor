import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/app.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';

import 'features/auth/data/services/auth_service.dart';
import 'features/auth/controllers/welcome_controller.dart';
import 'features/vendor/controllers/vendor_controller.dart';
import 'features/vendor/services/vendor_service.dart';
import 'features/user/controllers/user_controller.dart';

void main() {
  _initDependencies();
  StorageService.init();
  runApp(const MyApp());
}

void _initDependencies() {
  if (!Get.isRegistered<UserService>()) {
    Get.put<UserService>(UserService(), permanent: true);
  }

  if (!Get.isRegistered<AuthService>()) {
    Get.put<AuthService>(AuthService(), permanent: true);
  }

  if (!Get.isRegistered<VendorController>()) {
    Get.put<VendorController>(VendorController(), permanent: true);
  }

  if (!Get.isRegistered<UserController>()) {
    Get.put<UserController>(UserController(), permanent: true);
  }

  if (!Get.isRegistered<WelcomeController>()) {
    Get.lazyPut<WelcomeController>(() => WelcomeController(), fenix: true);
  }
}
