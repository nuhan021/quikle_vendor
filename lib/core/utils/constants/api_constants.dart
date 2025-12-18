class ApiConstants {
  // Base URL
  static const String baseUrl = "https://quikle-u4dv.onrender.com/";
  // static const String baseUrl = "https://quikle-dev.onrender.com/";

  static const String sendOtp = "${baseUrl}auth/send_otp/";
  static const String login = "${baseUrl}auth/login/";
  static const String loginAuth2 = "${baseUrl}auth/login_auth2/";

  static const String vendorSignup = "${baseUrl}auth/vendor/signup/";
  static const String updateKyc = "${baseUrl}auth/vendor/update-kyc/";
  static const String toggleActiveStatus =
      "${baseUrl}auth/vendor/toggle-active-status/";
  static const String vendorDetails = "${baseUrl}auth/vendor/vendor-details/";
  static const String updateVendorProfile =
      "${baseUrl}auth/vendor/update-vendor-profile/";
  static const String verifyToken = "${baseUrl}auth/verify-token/";
  static const String subcategories =
      "${baseUrl}items/subcategories/?category_id={categoryId}";
  static const String addProductMedicine = "${baseUrl}items/medicine/";
  static const String addProductFood = "${baseUrl}items/food/";
  static const String getMedicineProducts =
      "${baseUrl}items/medicine/my-product/";
  static const String getFoodProducts = "${baseUrl}items/food/my-product/";
  static const String updateProductMedicine =
      "${baseUrl}items/medicine/{itemId}";
  static const String updateProductFood = "${baseUrl}items/food/{itemId}";
  static const String deleteProductMedicine =
      "${baseUrl}items/medicine/{itemId}";
  static const String deleteProductFood = "${baseUrl}items/food/{itemId}";

  // Orders
  static const String myOrders = "${baseUrl}earning/order/my_orders";
  static const String createOffer = "${baseUrl}rider/orders/create-offer/";
  static const String markShipped = "${baseUrl}rider/orders/shipped/";
  // Earnings / Vendor account
  static const String vendorAccount = "${baseUrl}earning/vendor/vendor_account";
  // Cupons
  static const String createCupon = "${baseUrl}promo/cupons/";
  static const String getCupons = "${baseUrl}promo/cupons/my_cupon";
  static const String updateCupon = "${baseUrl}promo/cupons/?cupon_id=";
  static const String deleteCupon = "${baseUrl}promo/cupons/?cupon_id=";
  // Prescription Orders
  static const String getAllPrescriptionOrders =
      "${baseUrl}prescription/prescriptions-order/all";
  static const String getPrescriptionOrderById =
      "${baseUrl}prescription/prescriptions-order";
  static const String changePrescriptionStatus =
      "${baseUrl}prescription/prescriptions-order/change-status/";
  static const String submitVendorResponse =
      "${baseUrl}prescription/prescriptions-order/vendor-response";

  static const String sendNotification = "${baseUrl}rider/send_notification/";
  static const String vendorResponseAboutPrescription =
      "${baseUrl}prescription/prescriptions-order/vendor-response";
}