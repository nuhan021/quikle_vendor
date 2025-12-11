import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/common/widgets/custom_button.dart';
import 'package:quikle_vendor/features/cupons/screen/cupon_screen.dart';
import 'package:quikle_vendor/features/cupons/controllers/cupon_controller.dart';
import '../controllers/add_product_controller.dart';

class ProductsActionButtonsWidget extends StatelessWidget {
  const ProductsActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final addProductController = Get.find<AddProductController>();

    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              text: 'Add Cupons',
              onPressed: () async {
                // Ensure coupon controller exists and refresh data
                final couponController = Get.put(CouponController());
                await couponController.fetchCoupons();
                Get.to(() => CuponScreen());
              },
              textColor: Colors.black,
              backgroundColor: Colors.white,
              borderColor: Colors.black,
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
