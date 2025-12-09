import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/products_controller.dart';
import 'product_card_widget.dart';

class ProductsListWidget extends StatelessWidget {
  const ProductsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>();

    return Obx(() {
      // Use search results when searching, otherwise use main products list
      var displayedProducts = controller.searchText.value.isNotEmpty
          ? controller.searchResults.toList()
          : controller.products.toList();

      // Filter to show only low stock and out of stock products if filter is active
      if (controller.showLowStockFilter.value) {
        displayedProducts = displayedProducts
            .where((product) => product.stock <= 10)
            .toList();
      }

      final isSearching = controller.searchText.value.isNotEmpty;
      final isLoadingSearch = controller.isLoadingSearch.value;

      return ListView.builder(
        controller: isSearching
            ? null
            : controller
                  .scrollController, // Disable scroll controller when searching
        padding: EdgeInsets.symmetric(horizontal: 12),
        itemCount:
            displayedProducts.length +
            ((controller.isLoadingMore.value && !isSearching) || isLoadingSearch
                ? 1
                : 0),
        itemBuilder: (context, index) {
          if (index == displayedProducts.length) {
            if (isLoadingSearch) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 8),
                      Text(
                        'Searching products...',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            } else if (!isSearching) {
              return const Center(child: CircularProgressIndicator());
            }
            return SizedBox.shrink();
          }
          if (index >= displayedProducts.length) return SizedBox.shrink();

          final product = displayedProducts[index];
          return ProductCardWidget(product: product);
        },
      );
    });
  }
}
