import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quikle_vendor/features/product_management/controllers/products_controller.dart';
import 'package:quikle_vendor/features/product_management/model/subcategory_model.dart';
import 'package:quikle_vendor/features/product_management/services/subcategory_services.dart';

import '../../../core/services/storage_service.dart';
import '../../../core/utils/logging/logger.dart';

class EditProductController extends GetxController {
  final vendorData = StorageService.getVendorDetails();
  late final String vendorType = vendorData!['type'];
  var showRemoveDiscountDialog = false.obs;
  var showEditProductModal = false.obs;

  // Form Controllers
  final productNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final weightController = TextEditingController();
  final priceController = TextEditingController();
  final stockQuantityController = TextEditingController();
  final discountController = TextEditingController();

  // Dropdown values
  late var selectedCategory;
  late var selectedSubCategory;
  var selectedSubCategoryId = 0.obs;
  var subCategorySearchText = ''.obs;
  var selectedStockQuantity = ''.obs;
  var productImage = ''.obs;
  var isDiscount = false.obs;
  var isOtc = false.obs;

  // Categories and Sub-categories (dynamic from API)
  final List<Map<String, dynamic>> categories = [
    {'id': 1, 'name': 'Fruits'},
    {'id': 2, 'name': 'Vegetables'},
    {'id': 6, 'name': 'Medicine'},
  ];
  var subCategories = <SubcategoryModel>[].obs;
  var isLoadingSubcategories = false.obs;

  // Services
  final SubcategoryServices subcategoryServices = SubcategoryServices();

  // Product data
  var productData = {}.obs;
  var currentProductId = ''.obs;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    selectedCategory = (categories.first['id'] as int).toString().obs;
    selectedSubCategory = ''.obs;

    // Load subcategories for the default category
    getSubcategories();

    dynamic args = Get.arguments;
    String? id;

    if (args is Map<String, dynamic>?) {
      id = args?['id']?.toString();
    } else if (args is String) {
      id = args.toString();
    }

    if (id != null) {
      currentProductId.value = id;
      loadProductData(id);
    }
  }

  // Get sub-categories from subcategory services
  Future<void> getSubcategories() async {
    try {
      int categoryId;

      // Determine category ID based on vendor type
      if (vendorType == 'medicine') {
        categoryId = 6;
      } else if (vendorType == 'food') {
        categoryId = 1;
      } else {
        AppLoggerHelper.debug("Unknown vendor type: $vendorType");
        return;
      }
      final subcategories = await subcategoryServices.getSubcategories(
        categoryId,
      );
      subCategories.value = subcategories;

      // Set the selected subcategory name if we have a selected ID
      if (selectedSubCategoryId.value > 0) {
        final selectedSub = subcategories.firstWhereOrNull(
          (sub) => sub.id == selectedSubCategoryId.value,
        );
        if (selectedSub != null) {
          selectedSubCategory.value = selectedSub.name;
        }
      }
    } catch (e) {
      log('Error loading subcategories: $e');
    }
  }

  void loadProductData(String id) {
    final dataController = Get.find<ProductsController>();
    var product = dataController.getProductById(id);
    if (product != null) {
      productNameController.text = product.title;
      descriptionController.text = product.description;
      weightController.text = product.weight.toString();
      priceController.text = product.sellPrice;
      stockQuantityController.text = product.stock.toString();
      discountController.text = product.discount.toString();
      selectedCategory.value = product.categoryId.toString();
      selectedSubCategoryId.value = product.subcategoryId;
      selectedStockQuantity.value = product.stock.toString();
      productImage.value = product.image;
      isDiscount.value = product.discount > 0;
      isOtc.value = product.isOTC;

      // Load subcategories for the product's category
      getSubcategories();
    }
  }

  void showEditProductDialog() {
    showEditProductModal.value = true;
  }

  void hideEditProductDialog() {
    clearForm();
    showEditProductModal.value = false;
  }

  void clearForm() {
    productNameController.clear();
    descriptionController.clear();
    weightController.clear();
    priceController.clear();
    stockQuantityController.clear();
    discountController.clear();
    selectedCategory.value = (categories.first['id'] as int).toString();
    selectedSubCategory.value = '';
    selectedStockQuantity.value = '';
    productImage.value = '';
    subCategorySearchText.value = '';
  }

  List<SubcategoryModel> getFilteredSubCategories() {
    if (subCategorySearchText.value.isEmpty) {
      return subCategories;
    }
    return subCategories
        .where(
          (item) => item.name.toLowerCase().contains(
            subCategorySearchText.value.toLowerCase(),
          ),
        )
        .toList();
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
    // Validate form
    if (productNameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter product name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFFEF4444),
        colorText: Colors.white,
      );
      return;
    }

    if (priceController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter product price',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFFEF4444),
        colorText: Colors.white,
      );
      return;
    }

    // Update product data
    productData['name'] = productNameController.text;
    productData['description'] = descriptionController.text;
    productData['weight'] = weightController.text;
    productData['price'] = double.tryParse(priceController.text) ?? 0.0;
    productData['stock'] = int.tryParse(stockQuantityController.text) ?? 0;
    productData['discount'] = double.tryParse(discountController.text) ?? 0.0;
    productData['category'] = selectedCategory.value;
    productData['image'] = productImage.value;

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

  void pickProductImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        productImage.value = pickedFile.path;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFFEF4444),
        colorText: Colors.white,
      );
    }
  }

  void changeCategory(String value) {
    selectedCategory.value = value;
    selectedSubCategory.value = ''; // Reset subcategory when category changes
  }

  void changeSubCategory(String value) {
    selectedSubCategory.value = value;
  }

  void changeStockQuantity(String value) {
    selectedStockQuantity.value = value;
  }

  void toggleOtc(bool value) {
    isOtc.value = value;
  }

  @override
  void onClose() {
    productNameController.dispose();
    descriptionController.dispose();
    weightController.dispose();
    priceController.dispose();
    stockQuantityController.dispose();
    discountController.dispose();
    super.onClose();
  }
}
