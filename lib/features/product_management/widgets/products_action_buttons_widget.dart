import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/common/widgets/custom_button.dart';
import 'package:quikle_vendor/features/cupons/screen/cupon_screen.dart';
import 'package:quikle_vendor/features/cupons/controllers/cupon_controller.dart';
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

    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: Obx(
              () => CustomButton(
                text: ctl.isLoadingCoupons.value
                    ? 'Add Cupons...'
                    : 'Add Cupons',
                onPressed: () async {
                  try {
                    ctl.isLoadingCoupons.value = true;
                    // Ensure coupon controller exists and refresh data
                    final couponController = Get.put(CouponController());
                    await couponController.fetchCoupons();
                    ctl.isLoadingCoupons.value = false;
                    Get.to(() => CuponScreen());
                  } catch (e) {
                    ctl.isLoadingCoupons.value = false;
                    rethrow;
                  }
                },
                textColor: Colors.white,
                backgroundColor: Colors.black,
                isLoading: ctl.isLoadingCoupons.value,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: CustomButton(
              text: 'Add New Product',
              onPressed: addProductController.showAddProductDialog,
              backgroundColor: Colors.black,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
