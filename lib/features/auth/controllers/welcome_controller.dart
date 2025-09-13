import 'dart:async';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class WelcomeController extends GetxController {
  final int delayMs = 1200;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _timer = Timer(Duration(milliseconds: delayMs), () {
      Get.offAllNamed(AppRoute.getNavbarScreen());
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
