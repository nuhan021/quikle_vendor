import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/common/widgets/custom_button.dart';
import '../controllers/products_controller.dart';
import '../controllers/add_product_controller.dart';

class ProductsActionButtonsWidget extends StatelessWidget {
  const ProductsActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>();
    final addProductController = Get.find<AddProductController>();

    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              text: 'Add Discount',
              onPressed: controller.showCreateDiscountDialog,
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
            ),
          ),
        ],
      ),
    );
  }
}
