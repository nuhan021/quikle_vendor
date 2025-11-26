final userController = Get.find<UserController>();
final vendor = userController.getVendorDetails();

print(vendor?.shopName);    // "Vendor Six"
print(vendor?.email);       // "vendor6@gmail.com"
print(vendor?.kycStatus);   // "submitted"