// import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
// import 'package:quikle_vendor/core/models/response_data.dart';
// import 'package:quikle_vendor/core/services/network_caller.dart';
// import 'package:quikle_vendor/core/utils/constants/api_constants.dart';

// class AuthService extends GetxService {
//   final NetworkCaller _network = NetworkCaller();

//   /// Send OTP for Signup
//   Future<ResponseData> sendOtpForSignup(String phone) {
//     return _network.postRequest(
//       ApiConstants.sendOtp,
//       form: true,
//       body: {
//         "phone": phone,
//         "purpose": "vendor_signup",
//       },
//     );
//   }

//   /// Send OTP for Login
//   Future<ResponseData> sendOtpForLogin(String phone) {
//     return _network.postRequest(
//       ApiConstants.sendOtp,
//       form: true,
//       body: {
//         "phone": phone,
//         "purpose": "vendor_login",
//       },
//     );
//   }

//   /// Complete Vendor Signup after OTP
//   Future<ResponseData> vendorSignup(
//       String shopName, String phone, String otp) {
//     return _network.postRequest(
//       ApiConstants.vendorSignup,
//       form: true,
//       body: {
//         "phone": phone,
//         "name": shopName,
//         "otp": otp,
//       },
//     );
//   }

//   /// Verify OTP for Login
//   Future<ResponseData> verifyLogin(String phone, String otp) {
//     return _network.postRequest(
//       ApiConstants.login,
//       form: true,
//       body: {
//         "phone": phone,
//         "otp": otp,
//         "purpose": "vendor_login",
//       },
//     );
//   }
// }
