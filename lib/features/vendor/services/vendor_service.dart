import 'package:get/get.dart';

class UserService extends GetxController {
  static UserService get instance => Get.find<UserService>();

  final RxBool _isLoggedIn = false.obs;

  bool get isLoggedIn => _isLoggedIn.value;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> setLoggedIn(bool status) async {
    _isLoggedIn.value = status;
  }

  Future<void> clearUser() async {
    try {
      _isLoggedIn.value = false;
    } catch (e) {
      throw Exception('Failed to clear user: $e');
    }
  }
}
