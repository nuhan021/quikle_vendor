import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:quikle_vendor/core/models/response_data.dart';
import 'package:quikle_vendor/core/services/network_caller.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import 'package:quikle_vendor/core/utils/constants/api_constants.dart';
import 'package:quikle_vendor/core/utils/logging/logger.dart';

class AuthService extends GetxService {
  final NetworkCaller _network = NetworkCaller();

  Future<ResponseData> sendOtpForSignup(String phone) {
    return _network.postRequest(
      ApiConstants.sendOtp,
      form: true,
      body: {"phone": phone, "purpose": "vendor_signup"},
    );
  }

  Future<ResponseData> sendOtpForLogin(String phone) {
    return _network.postRequest(
      ApiConstants.sendOtp,
      form: true,
      body: {"phone": phone, "purpose": "vendor_login"},
    );
  }

  Future<ResponseData> vendorLogin(String phone, String otp) {
    return _network.postRequest(
      ApiConstants.login,
      form: true,
      body: {"phone": phone, "otp": otp, "purpose": "vendor_login"},
    );
  }

  Future<ResponseData> vendorSignup(String shopName, String phone, String otp) {
    return _network.postRequest(
      ApiConstants.vendorSignup,
      form: true,
      body: {"phone": phone, "name": shopName, "otp": otp},
    );
  }

  Future<ResponseData> verifyLogin(String phone, String otp) {
    return _network.postRequest(
      ApiConstants.login,
      form: true,
      body: {"phone": phone, "otp": otp, "purpose": "vendor_login"},
    );
  }

  Future<ResponseData> verifyToken() {
    return _network.getRequest(
      ApiConstants.verifyToken,
      token: 'Bearer ${StorageService.token}',
    );
  }

  Future<ResponseData> getVendorDetails() async {
    final token = StorageService.token;
    AppLoggerHelper.info('🔑 Fetching vendor details with token: $token');
    final ResponseData response = await _network.getRequest(
      ApiConstants.vendorDetails,
      token: 'Bearer $token',
    );
    AppLoggerHelper.debug('✅ ========== VENDOR DETAILS RESPONSE ==========');
    AppLoggerHelper.info('Status Code: ${response.statusCode}');
    AppLoggerHelper.info(
      '📱 Vendor Details Response Data: ${response.responseData}',
    );

    return response;
  }
}
