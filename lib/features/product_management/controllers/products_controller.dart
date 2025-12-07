import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/routes/app_routes.dart';
import '../widgets/create_discount_modal_widget.dart';

class ProductsController extends GetxController {
  var searchText = ''.obs;
  var selectedCategory = 'All Categories'.obs;
  var selectedStockStatus = 'All Status'.obs;
  var selectedStockQuantity = '1'.obs;

  var showFilterProductModal = false.obs;
  var showDeleteDialog = false.obs;
  var productToDelete = ''.obs;

  // Products Data
  var products = [
    {
      'id': '1',
      'name': 'Organic Green Apples',
      'rating': 4.8,
      'pack': '1kg Pack',
      'price': 12.00,
      'stock': 200,
      'status': 'In Stock',
      'image': 'assets/images/green_apple.png',
      'category': 'Fruits',
      'hasDiscount': true,
    },
    {
      'id': '2',
      'name': 'Sweet Oranges',
      'rating': 4.8,
      'pack': '1kg Pack',
      'price': 12.00,
      'stock': 15,
      'status': 'Low Stock',
      'image': 'assets/images/orange.png',
      'category': 'Fruits',
      'hasDiscount': false,
    },
    {
      'id': '3',
      'name': 'Fresh Tomatoes',
      'rating': 4.8,
      'pack': '1kg Pack',
      'price': 12.00,
      'stock': 0,
      'status': 'Out of Stock',
      'image': 'assets/images/tomato.png',
      'category': 'Vegetables',
      'hasDiscount': true,
    },
  ].obs;

  Map<String, dynamic>? getProductById(String id) {
    return products.firstWhereOrNull((product) => product['id'] == id);
  }

  void onSearchChanged(String value) {
    searchText.value = value;
  }

  void showCreateDiscountDialog() {
    Get.dialog(
      CreateDiscountModalWidget(),
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
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
    products.removeWhere((product) => product['id'] == productToDelete.value);
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
        .where(
          (product) =>
              product['status'] == 'Low Stock' ||
              product['status'] == 'Out of Stock',
        )
        .length;
  }
}
