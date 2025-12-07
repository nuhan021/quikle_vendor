import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/routes/app_routes.dart';
import '../widgets/create_discount_modal_widget.dart';
import '../services/get_product_services.dart';
import '../model/products_model.dart';
import '../../../core/services/storage_service.dart';

class ProductsController extends GetxController {
  final vendorData = StorageService.getVendorDetails();
  late final String vendorType = vendorData != null
      ? vendorData!['type'] ?? 'food'
      : 'food';
  var searchText = ''.obs;
  var selectedCategory = 'All Categories'.obs;
  var selectedStockStatus = 'All Status'.obs;
  var selectedStockQuantity = '1'.obs;

  var showFilterProductModal = false.obs;
  var showDeleteDialog = false.obs;
  var productToDelete = ''.obs;
  var isLoading = true.obs;
  var isLoadingMore = false.obs;
  var total = 0.obs;
  int offset = 0;
  final int limit = 20;

  var products = <Product>[].obs;

  final GetProductServices _productServices = GetProductServices();
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      loadMore();
    }
  }

  //fetch products from api and call get product services
  Future<void> fetchProducts({bool isLoadMore = false}) async {
    if (isLoadMore) {
      isLoadingMore.value = true;
    } else {
      isLoading.value = true;
      offset = 0;
    }
    try {
      log(
        '🔄 Fetching products: isLoadMore=$isLoadMore, offset=$offset, vendorType=$vendorType',
      );
      final response = await _productServices.getProducts(
        vendorType: vendorType,
        offset: offset,
        limit: limit,
      );
      log('✅ API Response received: ${response.keys}');
      final List<dynamic> data = response['data'] ?? [];
      total.value = response['total'] ?? 0;
      log(
        '📊 Total products in API: ${total.value}, Current batch: ${data.length}',
      );
      final productList = data
          .whereType<Map<String, dynamic>>()
          .map((json) => Product.fromJson(json))
          .toList();
      log('🏃 Mapped products: ${productList.length}');
      if (isLoadMore) {
        products.addAll(productList);
        offset += limit;
        log(
          '➕ Load more complete. New offset: $offset, Total products: ${products.length}',
        );
      } else {
        products.assignAll(productList);
        log('🆕 Initial load complete. Total products: ${products.length}');
      }
      if (isLoadMore) {
        isLoadingMore.value = false;
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      log('Error fetching products: $e');
      if (isLoadMore) {
        isLoadingMore.value = false;
      } else {
        isLoading.value = false;
      }
      // Handle error, e.g., show snackbar
      try {
        Get.snackbar(
          'Error',
          'Failed to fetch products: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } catch (overlayError) {
        log('Could not show snackbar due to overlay error: $overlayError');
      }
    }
  }

  void loadMore() {
    if (!isLoadingMore.value && products.length < total.value) {
      fetchProducts(isLoadMore: true);
    }
  }

  Product? getProductById(String id) {
    return products.firstWhereOrNull((product) => product.id.toString() == id);
  }

  void onSearchChanged(String value) {
    searchText.value = value;
  }

  void showCreateDiscountDialog() {
    Get.dialog(
      CreateDiscountModalWidget(),
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: Duration.zero,
    );
  }

  void showFilterProductDialog() {
    showFilterProductModal.value = true;
  }

  void hideFilterProductDialog() {
    showFilterProductModal.value = false;
  }

  void showDeleteConfirmation(String productId) {
    productToDelete.value = productId;
    showDeleteDialog.value = true;
  }

  void hideDeleteConfirmation() {
    showDeleteDialog.value = false;
    productToDelete.value = '';
  }

  void deleteProduct() {
    products.removeWhere(
      (product) => product.id.toString() == productToDelete.value,
    );
    hideDeleteConfirmation();
    Get.snackbar(
      'Product Deleted',
      'Product has been removed from inventory',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFFEF4444),
      colorText: Colors.white,
    );
  }

  void editProduct(String productId) {
    Get.toNamed(
      AppRoute.productEditScreen,
      arguments: {'id': productId.toString()},
    );
  }

  void addDiscount() {
    Get.snackbar(
      'Discount Created',
      'New discount has been created',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF10B981),
      colorText: Colors.white,
    );
    Get.back();
  }

  void viewLowStockProducts() {
    Get.snackbar(
      'Low Stock Products',
      'Showing products with low stock',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFFF59E0B),
      colorText: Colors.white,
    );
  }

  void applyFilters() {
    Get.snackbar(
      'Filters Applied',
      'Category: ${selectedCategory.value}, Status: ${selectedStockStatus.value}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF6366F1),
      colorText: Colors.white,
    );
  }

  int get lowStockCount {
    return products
        .where((product) => !product.isInStock || product.stock <= 20)
        .length;
  }
}
