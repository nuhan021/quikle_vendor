import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/products_controller.dart';
import 'product_card_widget.dart';

class ProductsListWidget extends StatelessWidget {
  const ProductsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>();

    return Obx(
      () => ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 12),
        itemCount: controller.products.length,
        itemBuilder: (context, index) {
          final product = controller.products[index];
          return ProductCardWidget(product: product);
        },
      ),
    );
  }
}
