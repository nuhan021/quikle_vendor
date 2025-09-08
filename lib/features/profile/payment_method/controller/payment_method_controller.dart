import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/constants/icon_path.dart';

class PaymentMethodController extends GetxController {
  /// List of available payment methods
  var methods = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();

    /// Initial default methods
    methods.addAll([
      {"icon": IconPath.paytm, "name": "Paytm"},
      {"icon": IconPath.googlePay, "name": "Google Pay"},
      {"icon": IconPath.phonepe, "name": "PhonePe"},
      {"icon": IconPath.cashfree, "name": "Cashfree"},
      {"icon": IconPath.razorpay, "name": "Razorpay"},
      {"icon": IconPath.bankTransfer, "name": "Bank Transfer"},
    ]);
  }

  /// Delete a payment method
  void deleteMethod(int index) {
    methods.removeAt(index);
  }

  /// Add a new payment method
  void addMethod(String icon, String name) {
    // methods.add({"icon": icon, "name": name});
  }
}
