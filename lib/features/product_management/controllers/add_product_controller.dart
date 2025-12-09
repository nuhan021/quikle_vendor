import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quikle_vendor/core/utils/logging/logger.dart';
import 'package:quikle_vendor/features/product_management/services/add_product_services.dart';

import '../../../core/services/storage_service.dart';
import '../model/subcategory_model.dart';
import '../services/subcategory_services.dart';
import '../widgets/add_product_modal_widget.dart';

class AddProductController extends GetxController {
  final vendorData = StorageService.getVendorDetails();
  final SubcategoryServices subcategoryServices = SubcategoryServices();
  //get this value from vendor data
  late final vendorType = vendorData != null ? vendorData!['type'] : null;

  var selectedSubCategoryId = 0.obs;
  var selectedSubCategoryName = ''.obs;

  var isOtc = false.obs;
  var isLoading = false.obs;

  void toggleOtc(bool value) {
    isOtc.value = value;
    // if (value) {
    //   isPrescribed.value = false;
    // }
  }

  // Form Controllers
  final productNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final weightController = TextEditingController();
  final priceController = TextEditingController();
  final stockQuantityController = TextEditingController();
  final categoryController = TextEditingController();
  final subCategoryController = TextEditingController();
  final discountController = TextEditingController();

  // Dropdown values
  late RxString selectedCategory;
  late RxString selectedSubCategory;
  var subCategorySearchText = ''.obs;

  // Categories and Sub-categories
  final List<String> categories = ['Fruits', 'Vegetables', 'Dairy', 'Bakery'];
  final Map<String, List<String>> subCategories = {
    'Fruits': ['Apple', 'Orange', 'Banana', 'Mango'],
    'Vegetables': ['Tomato', 'Carrot', 'Cucumber', 'Onion'],
    'Dairy': ['Milk', 'Cheese', 'Yogurt', 'Butter'],
    'Bakery': ['Bread', 'Cake', 'Cookie', 'Pastry'],
  };

  // Get sub-categories from subcategory services
  var subCategoriesList = <SubcategoryModel>[].obs;

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
      subCategoriesList.value = subcategories;
    } catch (e) {
      log('Error loading subcategories: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();

    if (vendorData != null) {
      log('Vendor type loaded from vendor details: $vendorType');
    }
    selectedCategory = categories.first.obs;
    selectedSubCategory = (subCategories[categories.first] ?? []).isNotEmpty
        ? (subCategories[categories.first]![0]).obs
        : 'All Categories'.obs;

    getSubcategories();
  }

  // Product data
  var productData = {}.obs;
  var productImage = ''.obs;
  final ImagePicker _imagePicker = ImagePicker();

  void showAddProductDialog() {
    Get.dialog(
      AddProductModalWidget(),
      barrierDismissible: false,
      transitionDuration: Duration.zero,
    );
  }

  void hideAddProductDialog() {
    clearForm();
    Navigator.of(Get.context!).pop();
  }

  void clearForm() {
    productNameController.clear();
    descriptionController.clear();
    weightController.clear();
    priceController.clear();
    stockQuantityController.clear();
    categoryController.clear();
    subCategoryController.clear();
    discountController.clear();
    selectedCategory.value = categories.first;
    selectedSubCategory.value =
        (subCategories[categories.first] ?? []).isNotEmpty
        ? subCategories[categories.first]![0]
        : '';
    productImage.value = '';
    subCategorySearchText.value = '';
    selectedSubCategoryId.value = 0;
    selectedSubCategoryName.value = '';
    isOtc.value = false;
  }

  void addProduct() async {
    log('addProduct called!');

    // ========== FORM VALIDATION ==========
    if (productNameController.text.isEmpty) {
      log('Product name is empty - validation failed');
      return;
    }

    if (priceController.text.isEmpty) {
      log('Price is empty - validation failed');
      return;
    }

    if (stockQuantityController.text.isEmpty) {
      log('Stock quantity is empty - validation failed');
      return;
    }

    if (selectedSubCategoryId.value == 0) {
      log('SubCategory not selected - validation failed');
      return;
    }

    log('Validation passed, setting isLoading to true');
    // ========== SET LOADING STATE ==========
    isLoading.value = true;
    log('Loading state set to: ${isLoading.value}');

    if (vendorType == 'medicine') {
      try {
        final success = await AddMedicineProductServices().addProduct(
          title: productNameController.text,
          description: descriptionController.text,
          subcategoryId: selectedSubCategoryId.value,
          price: double.tryParse(priceController.text) ?? 0.0,
          discount: int.tryParse(discountController.text) ?? 0,
          stock: int.tryParse(stockQuantityController.text) ?? 0,
          isOTC: vendorType == "medicine"
              ? isOtc.value
              : false, // only for medicine
          weight: weightController.text.isNotEmpty
              ? double.tryParse(weightController.text)
              : null,
          image: productImage.value.isNotEmpty
              ? File(productImage.value)
              : null,
        );

        if (success) {
          isLoading.value = false;
          hideAddProductDialog(); // close modal & clear form first
        } else {
          isLoading.value = false;
          // Handle failure case without snackbar
        }
      } catch (e) {
        isLoading.value = false;
        // Handle error case without snackbar
      }
    } else if (vendorType == 'food') {
      try {
        final success = await AddFoodProductServices().addProduct(
          title: productNameController.text,
          description: descriptionController.text,
          subcategoryId: selectedSubCategoryId.value,
          price: double.tryParse(priceController.text) ?? 0.0,
          discount: int.tryParse(discountController.text) ?? 0,
          stock: int.tryParse(stockQuantityController.text) ?? 0,
          weight: weightController.text.isNotEmpty
              ? double.tryParse(weightController.text)
              : null,
          image: productImage.value.isNotEmpty
              ? File(productImage.value)
              : null,
        );

        if (success) {
          isLoading.value = false;
          hideAddProductDialog(); // close modal & clear form first
        } else {
          isLoading.value = false;
          // Handle failure case without snackbar
        }
      } catch (e) {
        isLoading.value = false;
        // Handle error case without snackbar
      }
    }
  }

  void changeCategory(String value) {
    selectedCategory.value = value;
  }

  void changeSubCategory(String value) {
    selectedSubCategory.value = value;
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
      // Handle error case without snackbar
    }
  }

  @override
  void onClose() {
    productNameController.dispose();
    descriptionController.dispose();
    weightController.dispose();
    priceController.dispose();
    stockQuantityController.dispose();
    categoryController.dispose();
    subCategoryController.dispose();
    discountController.dispose();
    super.onClose();
  }
}
