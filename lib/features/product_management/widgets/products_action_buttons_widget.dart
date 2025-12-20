import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/common/widgets/custom_button.dart';
import 'package:quikle_vendor/features/cupons/screen/cupon_screen.dart';
import 'package:quikle_vendor/features/cupons/controllers/cupon_controller.dart';
import 'package:quikle_vendor/features/profile/my_profile/controller/my_profile_controller.dart';
import '../controllers/add_product_controller.dart';

class _ProductsActionButtonsController extends GetxController {
  final isLoadingCoupons = false.obs;
}

class ProductsActionButtonsWidget extends StatelessWidget {
  const ProductsActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final addProductController = Get.find<AddProductController>();
    final ctl = Get.put(_ProductsActionButtonsController());

    // Safe access to MyProfileController
    final myProfileController = Get.isRegistered<MyProfileController>()
        ? Get.find<MyProfileController>()
        : null;

    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          // Show warning if features are disabled
          if (myProfileController != null)
            // Obx(
            //   () => myProfileController.shouldDisableFeatures.value
            //       ? Container(
            //           width: double.infinity,
            //           padding: EdgeInsets.all(12),
            //           margin: EdgeInsets.only(bottom: 12),
            //           decoration: BoxDecoration(
            //             color: Colors.red.shade100,
            //             border: Border.all(color: Colors.red),
            //             borderRadius: BorderRadius.circular(8),
            //           ),
            //           child: Text(
            //             myProfileController.profileCompletionPercentage.value <
            //                     100
            //                 ? 'Complete your profile to add products'
            //                 : 'Verify KYC to add products',
            //             style: TextStyle(
            //               color: Colors.red.shade900,
            //               fontSize: 12,
            //               fontWeight: FontWeight.w500,
            //             ),
            //             textAlign: TextAlign.center,
            //           ),
            //         )
            //       : SizedBox.shrink(),
            // ),
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => CustomButton(
                    text: ctl.isLoadingCoupons.value
                        ? 'Add Cupons...'
                        : 'Add Cupons',
                    onPressed:
                        (myProfileController?.shouldDisableFeatures.value ??
                            false)
                        ? () {} // Disabled state
                        : () async {
                            try {
                              ctl.isLoadingCoupons.value = true;
                              // Ensure coupon controller exists and refresh data
                              final couponController = Get.put(
                                CouponController(),
                              );
                              await couponController.fetchCoupons();
                              ctl.isLoadingCoupons.value = false;
                              Get.to(() => CuponScreen());
                            } catch (e) {
                              ctl.isLoadingCoupons.value = false;
                              rethrow;
                            }
                          },
                    textColor: Colors.white,
                    backgroundColor:
                        (myProfileController?.shouldDisableFeatures.value ??
                            false)
                        ? Colors.grey
                        : Colors.black,
                    isLoading: ctl.isLoadingCoupons.value,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: 'Add New Product',
                  onPressed:
                      (myProfileController?.shouldDisableFeatures.value ??
                          false)
                      ? () {} // Disabled state
                      : addProductController.showAddProductDialog,
                  backgroundColor:
                      (myProfileController?.shouldDisableFeatures.value ??
                          false)
                      ? Colors.grey
                      : Colors.black,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
