import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/products_controller.dart';
import 'product_card_widget.dart';
import '../../../core/widgets/shimmer_widget.dart';
import '../../../core/common/styles/global_text_style.dart';
import 'package:quikle_vendor/features/profile/my_profile/controller/my_profile_controller.dart';

class ProductsListWidget extends StatelessWidget {
  const ProductsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>();

    // Safe access to MyProfileController
    final myProfileController = Get.isRegistered<MyProfileController>()
        ? Get.find<MyProfileController>()
        : null;

    return Obx(() {
      // Check if KYC is submitted - show message instead of products
      if (myProfileController != null &&
          myProfileController.kycStatus.value.toLowerCase() == 'submitted') {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'KYC status is submitted. Wait for approval.',
              textAlign: TextAlign.center,
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
        );
      }

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

      // Apply category filtering
      if (controller.selectedCategoryId.value > 0) {
        displayedProducts = displayedProducts
            .where(
              (product) =>
                  product.categoryId == controller.selectedCategoryId.value,
            )
            .toList();
      }

      // Apply subcategory filtering
      if (controller.selectedSubCategoryId.value > 0) {
        displayedProducts = displayedProducts
            .where(
              (product) =>
                  product.subcategoryId ==
                  controller.selectedSubCategoryId.value,
            )
            .toList();
      }

      // Apply stock status filtering
      if (controller.selectedStockStatus.value != 'All Status') {
        displayedProducts = displayedProducts.where((product) {
          switch (controller.selectedStockStatus.value) {
            case 'In Stock':
              return product.stock > 10;
            case 'Low Stock':
              return product.stock > 0 && product.stock <= 10;
            case 'Out of Stock':
              return product.stock == 0;
            default:
              return true;
          }
        }).toList();
      }

      final isSearching = controller.searchText.value.isNotEmpty;
      final isLoadingSearch = controller.isLoadingSearch.value;

      // Show loading state when searching
      if (isLoadingSearch) {
        return const Padding(
          padding: EdgeInsets.all(12.0),
          child: Center(
            child: ListShimmerSkeleton(itemCount: 3, shrinkWrap: true),
          ),
        );
      }

      // Show empty state when no products
      if (displayedProducts.isEmpty && !isLoadingSearch) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              myProfileController != null &&
                      myProfileController.shouldDisableFeatures.value
                  ? 'Complete your profile or verify KYC to manage products.'
                  : 'No products found. Add your first product to get started.',
              textAlign: TextAlign.center,
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
        );
      }

      return Padding(
        padding: EdgeInsets.only(
          left: 10.w,
          right: 10.w,
          bottom: 65.w,
          top: 10.w,
        ),
        child: Column(
          children: [
            for (final product in displayedProducts)
              ProductCardWidget(product: product),
            if (controller.isLoadingMore.value && !isSearching)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12),
                child: ListShimmerSkeleton(itemCount: 1, shrinkWrap: true),
              ),
          ],
        ),
      );
    });
  }
}
