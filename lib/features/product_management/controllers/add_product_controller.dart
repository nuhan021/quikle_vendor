import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quikle_vendor/core/utils/logging/logger.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import 'package:quikle_vendor/features/product_management/services/add_product_services.dart';
import '../model/subcategory_model.dart';
import '../model/sub_subcategory_model.dart';
import '../services/subcategory_services.dart';
import '../services/sub_subcategory_services.dart';
import '../widgets/add_product_modal_widget.dart';
import 'products_controller.dart';

class AddProductController extends GetxController {
  // Dependencies
  final SubcategoryServices _subcategoryServices = SubcategoryServices();
  final SubSubcategoryServices _subSubcategoryServices =
      SubSubcategoryServices();
  final ImagePicker _imagePicker = ImagePicker();

  // Vendor data
  final vendorData = StorageService.getVendorDetails();
  late final String? vendorType =
      vendorData != null ? vendorData!['type'] as String? : null;

  // UI state
  final selectedSubCategoryId = 0.obs;
  final selectedSubCategoryName = ''.obs;
  final selectedSubSubCategoryId = 0.obs;
  final selectedSubSubCategoryName = ''.obs;

  final isOtc = false.obs;
  final isLoading = false.obs;

  // Form controllers
  final productNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final weightController = TextEditingController();
  final priceController = TextEditingController();
  final stockQuantityController = TextEditingController();
  final categoryController = TextEditingController();
  final subCategoryController = TextEditingController();
  final discountController = TextEditingController();

  // Category / subcategory dropdowns
  late final RxString selectedCategory;
  late final RxString selectedSubCategory;
  final subCategorySearchText = ''.obs;
  final subSubCategorySearchText = ''.obs;

  final List<String> categories = ['Fruits', 'Vegetables', 'Dairy', 'Bakery'];
  final Map<String, List<String>> subCategories = {
    'Fruits': ['Apple', 'Orange', 'Banana', 'Mango'],
    'Vegetables': ['Tomato', 'Carrot', 'Cucumber', 'Onion'],
    'Dairy': ['Milk', 'Cheese', 'Yogurt', 'Butter'],
    'Bakery': ['Bread', 'Cake', 'Cookie', 'Pastry'],
  };

  // API subcategories and sub subcategories
  final subCategoriesList = <SubcategoryModel>[].obs;
  final subSubCategoriesList = <SubSubcategoryModel>[].obs;

  // Product data
  final productData = <String, dynamic>{}.obs;
  final productImage = ''.obs;

  // ====== Lifecycle ======

  @override
  void onInit() {
    super.onInit();

    if (vendorData != null) {
      log('Vendor type loaded from vendor details: $vendorType');
    }

    final defaultCategory = categories.first;
    selectedCategory = defaultCategory.obs;

    final defaultSubcats = subCategories[defaultCategory] ?? [];
    selectedSubCategory = (defaultSubcats.isNotEmpty
            ? defaultSubcats.first
            : 'All Categories')
        .obs;

    _loadSubcategories();
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

  // ====== Public API ======

  void toggleOtc(bool value) => isOtc.value = value;

  void changeCategory(String value) {
    selectedCategory.value = value;
    final subcats = subCategories[value] ?? [];
    selectedSubCategory.value = subcats.isNotEmpty ? subcats.first : '';
  }

  void changeSubCategory(String value) {
    selectedSubCategory.value = value;
  }

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
    final defaultSubcats = subCategories[categories.first] ?? [];
    selectedSubCategory.value =
        defaultSubcats.isNotEmpty ? defaultSubcats.first : '';

    productImage.value = '';
    subCategorySearchText.value = '';
    subSubCategorySearchText.value = '';
    selectedSubCategoryId.value = 0;
    selectedSubCategoryName.value = '';
    selectedSubSubCategoryId.value = 0;
    selectedSubSubCategoryName.value = '';
    isOtc.value = false;
  }

  Future<void> pickProductImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        productImage.value = pickedFile.path;
      }
    } catch (e) {
      AppLoggerHelper.debug('Error picking image: $e');
    }
  }

  Future<void> addProduct() async {
    log('addProduct called!');

    if (!_validateForm()) return;

    isLoading.value = true;
    log('Loading state set to: ${isLoading.value}');

    try {
      final success = await _submitProductByVendorType();

      isLoading.value = false;

      if (success) {
        // Refresh products list in ProductsController
        try {
          final productsController = Get.find<ProductsController>();
          productsController.products.clear();
          productsController.offset = 0;
          await productsController.fetchProducts();
        } catch (e) {
          log('Error refreshing products list: $e');
        }

        hideAddProductDialog();
      } else {
        // Optional: handle failure silently or via UI
      }
    } catch (e) {
      isLoading.value = false;
      AppLoggerHelper.debug('Error adding product: $e');
    }
  }

  // ====== Private helpers ======

  Future<void> _loadSubcategories() async {
    try {
      final categoryId = _getCategoryIdForVendorType();
      if (categoryId == null) {
        AppLoggerHelper.debug("Unknown or null vendor type: $vendorType");
        return;
      }

      final subcategories =
          await _subcategoryServices.getSubcategories(categoryId);
      subCategoriesList.value = subcategories;
    } catch (e) {
      log('Error loading subcategories: $e');
    }
  }

  Future<void> loadSubSubcategories(int subcategoryId) async {
    try {
      if (subcategoryId == 0) {
        subSubCategoriesList.clear();
        return;
      }

      final subSubcategories =
          await _subSubcategoryServices.getSubSubcategories(subcategoryId);
      subSubCategoriesList.value = subSubcategories;
    } catch (e) {
      log('Error loading sub subcategories: $e');
      AppLoggerHelper.debug('Error loading sub subcategories: $e');
    }
  }

  int? _getCategoryIdForVendorType() {
    switch (vendorType) {
      case 'medicine':
        return 6;
      case 'food':
        return 1;
      default:
        return null;
    }
  }

  bool _validateForm() {
    if (productNameController.text.isEmpty) {
      log('Product name is empty - validation failed');
      return false;
    }

    if (priceController.text.isEmpty) {
      log('Price is empty - validation failed');
      return false;
    }

    if (stockQuantityController.text.isEmpty) {
      log('Stock quantity is empty - validation failed');
      return false;
    }

    if (selectedSubCategoryId.value == 0) {
      log('SubCategory not selected - validation failed');
      return false;
    }

    if (selectedSubSubCategoryId.value == 0) {
      log('Sub SubCategory not selected - validation failed');
      return false;
    }

    log('Validation passed');
    return true;
  }

  Future<bool> _submitProductByVendorType() async {
    final price = double.tryParse(priceController.text) ?? 0.0;
    final discount = int.tryParse(discountController.text) ?? 0;
    final stock = int.tryParse(stockQuantityController.text) ?? 0;
    final weight = weightController.text.isNotEmpty
        ? double.tryParse(weightController.text)
        : null;
    final File? imageFile =
        productImage.value.isNotEmpty ? File(productImage.value) : null;

    switch (vendorType) {
      case 'medicine':
        return AddMedicineProductServices().addProduct(
          title: productNameController.text,
          description: descriptionController.text,
          subcategoryId: selectedSubCategoryId.value,
          price: price,
          discount: discount,
          stock: stock,
          isOTC: isOtc.value,
          weight: weight,
          image: imageFile,
        );
      case 'food':
        return AddFoodProductServices().addProduct(
          title: productNameController.text,
          description: descriptionController.text,
          subcategoryId: selectedSubCategoryId.value,
          price: price,
          discount: discount,
          stock: stock,
          weight: weight,
          image: imageFile,
        );
      default:
        AppLoggerHelper.debug('Unsupported vendor type: $vendorType');
        return false;
    }
  }
}
