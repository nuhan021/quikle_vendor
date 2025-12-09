import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/products_controller.dart';
import 'product_card_widget.dart';
import '../../../core/widgets/shimmer_widget.dart';

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
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount:
            displayedProducts.length +
            ((controller.isLoadingMore.value && !isSearching) || isLoadingSearch
                ? 1
                : 0),
        itemBuilder: (context, index) {
          if (index == displayedProducts.length) {
            if (isLoadingSearch) {
              return const Padding(
                padding: EdgeInsets.all(12.0),
                child: Center(
                  child: ListShimmerSkeleton(itemCount: 3, shrinkWrap: true),
                ),
              );
            } else if (!isSearching) {
              // Load-more shimmer placeholder (use same skeleton but non-scrollable)
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12),
                child: ListShimmerSkeleton(itemCount: 1, shrinkWrap: true),
              );
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
