import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/features/product_management/controllers/products_controller.dart';

class EditProductController extends GetxController {
  var showRemoveDiscountDialog = false.obs;

  // Form Controllers
  final productNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final weightController = TextEditingController();
  final priceController = TextEditingController();

  // Dropdown values
  var selectedStockQuantity = '102'.obs;
  var selectedCategory = 'All Categories'.obs;
  var productName = ''.obs;
  var productPrice = 0.0.obs;
  var productStock = 0.obs;
  var productStatus = ''.obs;
  var productImage = ''.obs;
  var productPack = ''.obs;
  var isDiscount = false.obs;

  // Product data
  var productData = {}.obs;

  @override
  void onInit() {
    super.onInit();
    dynamic args = Get.arguments;
    String? id;

    if (args is Map<String, dynamic>?) {
      id = args?['id']?.toString();
    } else if (args is String) {
      id = args.toString();
    }

    if (id != null) {
      loadProductData(id);
    }
  }

  void loadProductData(String id) {
    final dataController = Get.find<ProductsController>();
    var product = dataController.getProductById(id);
    if (product != null) {
      productName.value = product['name'] ?? '';
      productPrice.value = product['price'] ?? 0.0;
      selectedStockQuantity.value = product['stock'].toString();
      productStatus.value = product['status'] ?? '';
      selectedCategory.value = product['category'] ?? '';
      productImage.value = product['image'] ?? '';
      productPack.value = product['pack'] ?? '';
      isDiscount.value = product['hasDiscount'];
    }
    // Populate form controllers
    productNameController.text = productName.value.toString();
    descriptionController.text = 'This is a dummy description';
    weightController.text = productPack.value.toString();
    priceController.text = productPrice.value.toString();
    selectedStockQuantity.value = selectedStockQuantity.value.toString();
    selectedCategory.value = selectedCategory.value.toString();
  }

  void showRemoveDiscountConfirmation() {
    showRemoveDiscountDialog.value = true;
  }

  void hideRemoveDiscountConfirmation() {
    showRemoveDiscountDialog.value = false;
  }

  void removeDiscount() {
    isDiscount.value = false;
    hideRemoveDiscountConfirmation();
    Get.snackbar(
      'Discount Removed',
      'Discount offer has been removed from this product',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFFEF4444),
      colorText: Colors.white,
    );
  }

  void saveChanges() {
    // Update product data
    productData['name'] = productNameController.text;
    productData['description'] = descriptionController.text;
    productData['weight'] = weightController.text;
    productData['price'] = priceController.text;
    productData['stock'] = selectedStockQuantity.value;
    productData['category'] = selectedCategory.value;

    Get.snackbar(
      'Changes Saved',
      'Product has been updated successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF10B981),
      colorText: Colors.white,
    );

    // Navigate back after a delay
    Future.delayed(Duration(seconds: 1), () {
      Get.back();
    });
  }

  void changeStockQuantity(String value) {
    selectedStockQuantity.value = value;
  }

  void changeCategory(String value) {
    selectedCategory.value = value;
  }

  @override
  void onClose() {
    productNameController.dispose();
    descriptionController.dispose();
    weightController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
