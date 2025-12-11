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
  // Vendor
  final vendorData = StorageService.getVendorDetails();
  late final String vendorType = vendorData != null
      ? (vendorData!['type'] ?? 'food')
      : 'food';

  // Filters / search
  final searchText = ''.obs;
  final selectedCategory = 'All Categories'.obs;
  final selectedStockStatus = 'All Status'.obs;
  final selectedStockQuantity = '1'.obs;

  // UI state
  final showFilterProductModal = false.obs;
  final showDeleteDialog = false.obs;
  final showLowStockFilter = false.obs;
  final isDeleting = false.obs;
  final productToDelete = ''.obs;
  final isLoading = true.obs;
  final isLoadingMore = false.obs;

  // Pagination
  final total = 0.obs;
  static bool _isDataInitialized = false;
  int offset = 0;
  final int limit = 20;
  final int searchLimit = 100; // Reserved for future if needed

  // Data
  final products = <Product>[].obs;
  final allProductsLoaded = false.obs;
  final isLoadingSearch = false.obs;
  final searchResults = <Product>[].obs;
  final hasMoreSearchResults = true.obs;
  final lowStockCountValue = 0.obs; // Observable for low stock count

  // Services
  final GetProductServices _productServices = GetProductServices();
  late final DeleteMedicineProductServices _deleteMedicineProductServices;
  late final DeleteFoodProductServices _deleteFoodProductServices;

  // Controllers / timers
  final ScrollController scrollController = ScrollController();
  Timer? _searchDebounceTimer;
  Timer? _autoLoadTimer;

  @override
  void onInit() {
    super.onInit();

    _deleteMedicineProductServices = DeleteMedicineProductServices();
    _deleteFoodProductServices = DeleteFoodProductServices();

    if (!_isDataInitialized) {
      fetchProducts();
      _isDataInitialized = true;
    }

    _startAutoLoadTimer();
    scrollController.addListener(_scrollListener);
  }

  @override
  void onClose() {
    _searchDebounceTimer?.cancel();
    _autoLoadTimer?.cancel();
    scrollController.dispose();
    super.onClose();
  }

  // ====== Search ======

  void onSearchChanged(String value) {
    _searchDebounceTimer?.cancel();
    searchText.value = value;
    // log('🔎 User typing search: "$value"');

    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      _handleSearch(value);
    });
  }

  void _handleSearch(String searchValue) {
    if (searchValue.isNotEmpty) {
      // log('🔍 SEARCH INITIATED: Searching for "$searchValue"');
      _performIncrementalSearch(searchValue);
    } else {
      // log('🔄 Search cleared');
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

  Future<void> _performIncrementalSearch(String searchValue) async {
    if (isLoadingSearch.value) return;

    // log(
    //   '🔍 Starting incremental search for: "$searchValue" (10 products per batch, 15s timeout, 2 retries)',
    // );
    isLoadingSearch.value = true;
    searchResults.clear();
    hasMoreSearchResults.value = true;

    final lowerQuery = searchValue.toLowerCase();

    // Search already loaded products first
    final alreadyLoadedMatches = products
        .where((product) => product.title.toLowerCase().contains(lowerQuery))
        .toList();

    if (alreadyLoadedMatches.isNotEmpty) {
      searchResults.addAll(alreadyLoadedMatches);
      // log('✅ Found ${alreadyLoadedMatches.length} matches in already loaded products:');
      // for (final product in alreadyLoadedMatches) {
      //   log('   • ${product.title} (ID: ${product.id})');
      // }
      // log('Total results so far: ${searchResults.length}');
    }

    int searchOffset = 0;
    const int batchSize = 10;
    int consecutiveEmptyBatches = 0;
    const int maxEmptyBatches = 3;

    try {
      while (hasMoreSearchResults.value &&
          consecutiveEmptyBatches < maxEmptyBatches) {
        // log('🔍 Loading search batch ${searchOffset ~/ batchSize + 1}...');

        try {
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
                  .timeout(const Duration(seconds: 15));
              break;
            } catch (e) {
              if (attempt == maxRetries) rethrow;
              // log('⚠️ Search batch attempt ${attempt + 1} failed, retrying...');
              await Future.delayed(const Duration(seconds: 1));
            }
          }

          if (response == null) {
            // log('❌ No response received after retries');
            break;
          }

          final List<dynamic> data = response['data'] ?? [];
          final productList = data
              .whereType<Map<String, dynamic>>()
              .map(Product.fromJson)
              .toList();

          if (productList.isNotEmpty) {
            final matchingProducts = productList
                .where(
                  (product) => product.title.toLowerCase().contains(lowerQuery),
                )
                .toList();

            if (matchingProducts.isNotEmpty) {
              searchResults.addAll(matchingProducts);
              consecutiveEmptyBatches = 0;
              // log(
              //   '✅ Found ${matchingProducts.length} matching products in batch ${searchOffset ~/ batchSize + 1}:',
              // );
              // for (final product in matchingProducts) {
              //   log('   • ${product.title} (ID: ${product.id})');
              // }
              // log('Total results: ${searchResults.length}');
            } else {
              consecutiveEmptyBatches++;
              // log(
              //   '⏭️ No matches in batch ${searchOffset ~/ batchSize + 1}, consecutive empty: $consecutiveEmptyBatches',
              // );
            }

            if (productList.length < batchSize) {
              hasMoreSearchResults.value = false;
              // log('🎯 Reached end of products');
              break;
            }

            searchOffset += batchSize;

            if (searchResults.length >= 50) {
              // log(
              //   '🎯 Found sufficient results (${searchResults.length}), stopping search',
              // );
              break;
            }
          } else {
            hasMoreSearchResults.value = false;
            // log('🎯 No more products to load');
            break;
          }
        } catch (e) {
          // log('❌ Error loading search batch: $e');
          if (e.toString().contains('timeout')) {
            // log('⏰ Search batch timed out, stopping search');
          }
          break;
        }
      }
    } finally {
      isLoadingSearch.value = false;
      // log(
      //   '🔍 Incremental search complete. Found ${searchResults.length} results',
      // );
    }
  }

  // ====== Pagination & auto-load ======

  void _scrollListener() {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        searchText.value.isEmpty) {
      loadMore();
    }
  }

  void _startAutoLoadTimer() {
    _autoLoadTimer?.cancel();

    _autoLoadTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (searchText.value.isEmpty &&
          !isLoadingMore.value &&
          products.length < total.value) {
        // log('⏱️ Auto-loading next batch...');
        loadMore;
      }
    });
  }

  Future<void> fetchProducts({bool isLoadMore = false}) async {
    if (isLoadMore) {
      isLoadingMore.value = true;
    } else {
      isLoading.value = true;
      offset = 0;
    }

    try {
      // log(
      //   '🔄 Fetching products: isLoadMore=$isLoadMore, offset=$offset, vendorType=$vendorType',
      // );
      final response = await _productServices.getProducts(
        vendorType: vendorType,
        offset: offset,
        limit: limit,
      );

      log('✅ API Response received: ${response.keys}');
      final List<dynamic> data = response['data'] ?? [];
      total.value = response['total'] ?? 0;
      // log(
      //   '📊 Total products in API: ${total.value}, Current batch: ${data.length}',
      // );

      final productList = data
          .whereType<Map<String, dynamic>>()
          .map(Product.fromJson)
          .toList();
      // log('🏃 Mapped products: ${productList.length}');

      if (isLoadMore) {
        products.addAll(productList);
        offset += limit;
        // log(
        //   '➕ Load more complete. New offset: $offset, Total products: ${products.length}',
        // );
      } else {
        products.assignAll(productList);
        // log('🆕 Initial load complete. Total products: ${products.length}');
      }

      // Update low stock count
      lowStockCountValue.value = products.where((p) => p.stock <= 10).length;
    } catch (e) {
      // log('Error fetching products: $e');
    } finally {
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

  // ====== CRUD helpers ======

  Product? getProductById(String id) {
    return products.firstWhereOrNull((p) => p.id.toString() == id);
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

  Future<void> deleteProduct() async {
    isDeleting.value = true;
    try {
      final productId = productToDelete.value;
      bool success;

      if (vendorType == 'medicine') {
        success = await _deleteMedicineProductServices.deleteProduct(
          itemId: productId,
        );
      } else if (vendorType == 'food') {
        success = await _deleteFoodProductServices.deleteProduct(
          itemId: productId,
        );
      } else {
        // log('Unknown vendor type: $vendorType');
        return;
      }

      if (success) {
        products.removeWhere((p) => p.id.toString() == productId);
        // log('Product deleted successfully');
      } else {
        // log('Failed to delete product');
      }
    } catch (e) {
      // log('Error deleting product: $e');
    } finally {
      isDeleting.value = false;
      hideDeleteConfirmation();
    }
  }

  void editProduct(String productId) {
    Get.toNamed(AppRoute.productEditScreen, arguments: {'id': productId});
  }

  void addDiscount() {
    Get.back();
  }

  // ====== Low stock ======

  void viewLowStockProducts() {
    showLowStockFilter.value = !showLowStockFilter.value;

    if (showLowStockFilter.value) {
      // log('🔴 LOW STOCK & OUT OF STOCK FILTER ACTIVATED');
      // final productsToFilter = searchText.value.isNotEmpty
      //     ? searchResults
      //     : products;
      // final lowStockProducts = productsToFilter
      //     .where((p) => p.stock <= 10)
      //     .toList();

      // log('📦 Showing ${lowStockProducts.length} products (stock 0-10):');
      // for (final product in lowStockProducts) {
      //   final status = product.stock == 0 ? 'OUT OF STOCK' : 'LOW STOCK';
      //   log('   • ${product.title} (Stock: ${product.stock}) - $status');
      // }
    } else {
      // log(
      //   '🟢 LOW STOCK & OUT OF STOCK FILTER DEACTIVATED - Showing all products',
      // );
    }
  }

  void applyFilters() {
    // Implement category / status / quantity filter logic here if needed
  }

  int get lowStockCount {
    final productsToCheck = searchText.value.isNotEmpty
        ? searchResults
        : products;
    return productsToCheck.where((p) => p.stock <= 10).length;
  }
}
