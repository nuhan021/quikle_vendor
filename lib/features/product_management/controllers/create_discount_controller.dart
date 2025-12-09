import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'products_controller.dart';
import '../model/products_model.dart';

class CreateDiscountController extends GetxController {
  // Text controllers
  final discountNameController = TextEditingController();
  final discountCodeController = TextEditingController();
  final discountValueController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final productSearchController = TextEditingController();

  // Reactive state
  final selectedProduct = 'Sweet Oranges'.obs;
  final selectedProductId = '2'.obs;
  final startDate = ''.obs;
  final endDate = ''.obs;
  final filteredProducts = <Product>[].obs;

  late final ProductsController productsController;

  @override
  void onInit() {
    super.onInit();
    productsController = Get.find<ProductsController>();
    filteredProducts.assignAll(productsController.products);
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

  // ====== Search & selection ======

  void searchProducts(String query) {
    if (query.isEmpty) {
      filteredProducts.assignAll(productsController.products);
      return;
    }

    final lowerQuery = query.toLowerCase();
    filteredProducts.assignAll(
      productsController.products.where(
        (product) =>
            product.title.toLowerCase().contains(lowerQuery) ||
            product.description.toLowerCase().contains(lowerQuery),
      ),
    );
  }

  void setSelectedProduct(String productName, String productId) {
    selectedProduct.value = productName;
    selectedProductId.value = productId;
    productSearchController.clear();
  }

  // ====== Date handling ======

  void setStartDate(String date) {
    startDate.value = date;
    startDateController.text = date;
  }

  void setEndDate(String date) {
    endDate.value = date;
    endDateController.text = date;
  }

  // ====== Discount handling ======

  void addDiscount() {
    if (!_validateFields()) return;

    // TODO: Implement API call / local save for discount here

    closeDiscountDialog();
  }

  bool _validateFields() {
    if (discountNameController.text.isEmpty) {
      return false;
    }

    if (discountCodeController.text.isEmpty) {
      return false;
    }

    if (discountValueController.text.isEmpty) {
      return false;
    }

    if (startDate.value.isEmpty) {
      return false;
    }

    if (endDate.value.isEmpty) {
      return false;
    }

    return true;
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

    filteredProducts.assignAll(productsController.products);
  }

  void closeDiscountDialog() {
    clearFields();
    Navigator.of(Get.context!).pop();
  }
}
