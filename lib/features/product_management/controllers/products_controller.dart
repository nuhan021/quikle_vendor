import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductsController extends GetxController {
  var searchText = ''.obs;
  var selectedCategory = 'All Categories'.obs;
  var selectedStockStatus = 'All Status'.obs;

  var showAddProductModal = false.obs;
  var showCreateDiscountModal = false.obs;
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
      'image': '/placeholder.svg?height=80&width=80',
      'category': 'Fruits',
    },
    {
      'id': '2',
      'name': 'Sweet Oranges',
      'rating': 4.8,
      'pack': '1kg Pack',
      'price': 12.00,
      'stock': 15,
      'status': 'Low Stock',
      'image': '/placeholder.svg?height=80&width=80',
      'category': 'Fruits',
    },
    {
      'id': '3',
      'name': 'Fresh Tomatoes',
      'rating': 4.8,
      'pack': '1kg Pack',
      'price': 12.00,
      'stock': 0,
      'status': 'Out of Stock',
      'image': '/placeholder.svg?height=80&width=80',
      'category': 'Vegetables',
    },
  ].obs;

  void onSearchChanged(String value) {
    searchText.value = value;
  }

  void showAddProductDialog() {
    showAddProductModal.value = true;
  }

  void hideAddProductDialog() {
    showAddProductModal.value = false;
  }

  void showCreateDiscountDialog() {
    showCreateDiscountModal.value = true;
  }

  void hideCreateDiscountDialog() {
    showCreateDiscountModal.value = false;
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
    Get.snackbar(
      'Edit Product',
      'Opening edit form for product $productId',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF6366F1),
      colorText: Colors.white,
    );
  }

  void addProduct() {
    Get.snackbar(
      'Product Added',
      'New product has been added to inventory',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF10B981),
      colorText: Colors.white,
    );
    hideAddProductDialog();
  }

  void addDiscount() {
    Get.snackbar(
      'Discount Created',
      'New discount has been created',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF10B981),
      colorText: Colors.white,
    );
    hideCreateDiscountDialog();
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
