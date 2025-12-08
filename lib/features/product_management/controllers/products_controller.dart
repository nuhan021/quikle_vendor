import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/routes/app_routes.dart';
import '../widgets/create_discount_modal_widget.dart';
import '../services/get_product_services.dart';
import '../services/delete_product_services.dart';
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
  final int searchLimit = 100; // Load more products for search

  var products = <Product>[].obs; // Main products list for normal viewing
  var allProductsLoaded =
      false.obs; // Track if all products are loaded for search
  var isLoadingSearch = false.obs; // Prevent concurrent search loads
  var searchResults = <Product>[].obs; // Separate list for search results
  var hasMoreSearchResults =
      true.obs; // Track if there might be more search results

  final GetProductServices _productServices = GetProductServices();
  late final DeleteMedicineProductServices deleteMedicineProductServices;
  late final DeleteFoodProductServices deleteFoodProductServices;
  final ScrollController scrollController = ScrollController();
  Timer? _searchDebounceTimer;

  @override
  void onInit() {
    super.onInit();

    // Initialize delete services
    deleteMedicineProductServices = DeleteMedicineProductServices();
    deleteFoodProductServices = DeleteFoodProductServices();

    fetchProducts();
    scrollController.addListener(_scrollListener);
  }

  void onSearchChanged(String value) {
    // Cancel previous timer
    _searchDebounceTimer?.cancel();

    // Update the search text immediately for UI
    searchText.value = value;

    // Set new timer for debounced search
    _searchDebounceTimer = Timer(Duration(milliseconds: 500), () {
      _handleSearch(value);
    });
  }

  Future<void> _performIncrementalSearch(String searchValue) async {
    // If already loading search, don't start again
    if (isLoadingSearch.value) {
      return;
    }

    log(
      '🔍 Starting incremental search for: "$searchValue" (10 products per batch, 15s timeout, 2 retries)',
    );
    isLoadingSearch.value = true;
    searchResults.clear();
    hasMoreSearchResults.value = true;

    // First, search through already loaded products
    final alreadyLoadedMatches = products
        .where(
          (product) =>
              product.title.toLowerCase().contains(searchValue.toLowerCase()),
        )
        .toList();

    if (alreadyLoadedMatches.isNotEmpty) {
      searchResults.addAll(alreadyLoadedMatches);
      log(
        '✅ Found ${alreadyLoadedMatches.length} matches in already loaded products. Total results: ${searchResults.length}',
      );
    }

    int searchOffset = 0;
    const int batchSize = 10; // Even smaller batches for very slow networks
    int consecutiveEmptyBatches = 0;
    const int maxEmptyBatches = 3; // Stop after 3 empty batches

    try {
      while (hasMoreSearchResults.value &&
          consecutiveEmptyBatches < maxEmptyBatches) {
        log('🔍 Loading search batch ${searchOffset ~/ batchSize + 1}...');

        try {
          // Retry logic for failed requests
          const int maxRetries = 2;
          Map<String, dynamic>? response;

          for (int attempt = 0; attempt <= maxRetries; attempt++) {
            try {
              response = await _productServices
                  .getProducts(
                    vendorType: vendorType,
                    offset: searchOffset,
                    limit: batchSize,
                  )
                  .timeout(
                    const Duration(seconds: 15),
                  ); // Increased timeout for slower networks
              break; // Success, exit retry loop
            } catch (e) {
              if (attempt == maxRetries) {
                rethrow; // All retries failed
              }
              log('⚠️ Search batch attempt ${attempt + 1} failed, retrying...');
              await Future.delayed(
                Duration(seconds: 1),
              ); // Wait 1 second before retry
            }
          }

          if (response == null) {
            log('❌ No response received after retries');
            break;
          }

          final List<dynamic> data = response['data'] ?? [];
          final productList = data
              .whereType<Map<String, dynamic>>()
              .map((json) => Product.fromJson(json))
              .toList();

          if (productList.isNotEmpty) {
            // Filter products that match the search term
            final matchingProducts = productList
                .where(
                  (product) => product.title.toLowerCase().contains(
                    searchValue.toLowerCase(),
                  ),
                )
                .toList();

            if (matchingProducts.isNotEmpty) {
              searchResults.addAll(matchingProducts);
              consecutiveEmptyBatches = 0; // Reset counter when we find matches
              log(
                '✅ Found ${matchingProducts.length} matching products in batch. Total results: ${searchResults.length}',
              );
            } else {
              consecutiveEmptyBatches++;
              log(
                '⏭️ No matches in batch ${searchOffset ~/ batchSize + 1}, consecutive empty: $consecutiveEmptyBatches',
              );
            }

            // Check if we've reached the end
            if (productList.length < batchSize) {
              hasMoreSearchResults.value = false;
              log('🎯 Reached end of products');
              break;
            }

            searchOffset += batchSize;

            // If we have enough results (e.g., 50+), stop loading more
            if (searchResults.length >= 50) {
              log(
                '🎯 Found sufficient results (${searchResults.length}), stopping search',
              );
              break;
            }
          } else {
            // No more products to load
            hasMoreSearchResults.value = false;
            log('🎯 No more products to load');
            break;
          }
        } catch (e) {
          log('❌ Error loading search batch: $e');
          if (e.toString().contains('timeout')) {
            log('⏰ Search batch timed out, stopping search');
          }
          break;
        }
      }
    } finally {
      isLoadingSearch.value = false;
      log(
        '🔍 Incremental search complete. Found ${searchResults.length} results',
      );
    }
  }

  void _handleSearch(String searchValue) {
    if (searchValue.isNotEmpty) {
      // Perform incremental search that loads and searches in batches
      _performIncrementalSearch(searchValue);
    } else {
      // When search is cleared, reset search state
      clearSearch();
    }
  }

  void clearSearch() {
    searchText.value = '';
    searchResults.clear();
    isLoadingSearch.value = false;
    hasMoreSearchResults.value = true;
    _searchDebounceTimer?.cancel();
  }

  void _scrollListener() {
    // Only load more if not searching
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        searchText.value.isEmpty) {
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

  void deleteProduct() async {
    try {
      String productId = productToDelete.value;
      bool success;

      // Call appropriate service based on vendor type
      if (vendorType == 'medicine') {
        success = await deleteMedicineProductServices.deleteProduct(
          itemId: productId,
        );
      } else if (vendorType == 'food') {
        success = await deleteFoodProductServices.deleteProduct(
          itemId: productId,
        );
      } else {
        log('Unknown vendor type: $vendorType');
        hideDeleteConfirmation();
        return;
      }

      if (success) {
        // Remove product from list
        products.removeWhere((product) => product.id.toString() == productId);
        log('Product deleted successfully');
      } else {
        log('Failed to delete product');
      }
    } catch (e) {
      log('Error deleting product: $e');
    } finally {
      hideDeleteConfirmation();
    }
  }

  void editProduct(String productId) {
    Get.toNamed(
      AppRoute.productEditScreen,
      arguments: {'id': productId.toString()},
    );
  }

  void addDiscount() {
    Get.back();
  }

  void viewLowStockProducts() {}

  void applyFilters() {}

  int get lowStockCount {
    return products
        .where((product) => !product.isInStock || product.stock <= 20)
        .length;
  }

  @override
  void onClose() {
    _searchDebounceTimer?.cancel();
    scrollController.dispose();
    super.onClose();
  }
}
