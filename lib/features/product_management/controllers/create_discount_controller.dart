import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'products_controller.dart';
import '../model/products_model.dart';

class CreateDiscountController extends GetxController {
  final discountNameController = TextEditingController();
  final discountCodeController = TextEditingController();
  final discountValueController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final productSearchController = TextEditingController();

  var selectedProduct = 'Sweet Oranges'.obs;
  var selectedProductId = '2'.obs;
  var startDate = ''.obs;
  var endDate = ''.obs;
  var filteredProducts = <Product>[].obs;

  late ProductsController productsController;

  @override
  void onInit() {
    super.onInit();
    productsController = Get.find<ProductsController>();
    filteredProducts.value = productsController.products;
  }

  @override
  void onClose() {
    discountNameController.dispose();
    discountCodeController.dispose();
    discountValueController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    productSearchController.dispose();
    super.onClose();
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      filteredProducts.value = productsController.products;
    } else {
      filteredProducts.value = productsController.products
          .where(
            (product) =>
                product.title.toLowerCase().contains(query.toLowerCase()) ||
                product.description.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
  }

  void setSelectedProduct(String productName, String productId) {
    selectedProduct.value = productName;
    selectedProductId.value = productId;
    productSearchController.clear();
  }

  void setStartDate(String date) {
    startDate.value = date;
    startDateController.text = date;
  }

  void setEndDate(String date) {
    endDate.value = date;
    endDateController.text = date;
  }

  void addDiscount() {
    // Validate fields
    if (discountNameController.text.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter discount name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFFEF4444),
        colorText: Colors.white,
      );
      return;
    }

    if (discountCodeController.text.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter discount code',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFFEF4444),
        colorText: Colors.white,
      );
      return;
    }

    if (discountValueController.text.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter discount value',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFFEF4444),
        colorText: Colors.white,
      );
      return;
    }

    if (startDate.value.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please select start date',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFFEF4444),
        colorText: Colors.white,
      );
      return;
    }

    if (endDate.value.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please select end date',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFFEF4444),
        colorText: Colors.white,
      );
      return;
    }

    // Success message
    Get.snackbar(
      'Success',
      'Discount created successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF10B981),
      colorText: Colors.white,
    );

    // Clear all fields and close dialog
    closeDiscountDialog();
  }

  void clearFields() {
    discountNameController.clear();
    discountCodeController.clear();
    discountValueController.clear();
    startDateController.clear();
    endDateController.clear();
    productSearchController.clear();
    startDate.value = '';
    endDate.value = '';
    selectedProduct.value = 'Sweet Oranges';
    selectedProductId.value = '2';
    filteredProducts.value = productsController.products;
  }

  void closeDiscountDialog() {
    clearFields();
    Navigator.of(Get.context!).pop();
  }
}
