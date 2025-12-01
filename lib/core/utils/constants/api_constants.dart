class ApiConstants {
  // Base URL
  static const String baseUrl = "https://caditya619-backend.onrender.com/";

  static const String sendOtp = "${baseUrl}auth/send_otp/";
  static const String login = "${baseUrl}auth/login/";
  static const String loginAuth2 = "${baseUrl}auth/login_auth2/";

  static const String vendorSignup = "${baseUrl}auth/vendor/signup/";
  static const String updateKyc = "${baseUrl}auth/vendor/update-kyc/";
  static const String toggleActiveStatus =
      "${baseUrl}vendor/toggle-active-status/";
  static const String vendorDetails = "${baseUrl}auth/vendor/vendor-details/";
  static const String updateVendorProfile =
      "${baseUrl}vendor/update-vendor-profile/";
  static const String verifyToken = "${baseUrl}auth/verify-token/";
  static const String toggle_active_status =
      "${baseUrl}auth/vendor/toggle-active-status/";
}
