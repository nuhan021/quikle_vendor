import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:quikle_vendor/features/product_management/controllers/products_controller.dart';
import 'package:quikle_vendor/features/product_management/model/subcategory_model.dart';
import 'package:quikle_vendor/features/product_management/services/edit_product_services.dart';
import 'package:quikle_vendor/features/product_management/services/subcategory_services.dart';

import '../../../core/services/storage_service.dart';
import '../../../core/utils/logging/logger.dart';

class EditProductController extends GetxController {
  // Vendor
  final vendorData = StorageService.getVendorDetails();
  late final String? vendorType = vendorData != null
      ? vendorData!['type'] as String?
      : null;

  // UI state
  final showRemoveDiscountDialog = false.obs;
  final showEditProductModal = false.obs;

  // Error messages
  final productNameError = ''.obs;
  final descriptionError = ''.obs;
  final weightError = ''.obs;
  final priceError = ''.obs;
  final stockQuantityError = ''.obs;
  final discountError = ''.obs;
  final subCategoryError = ''.obs;
  final productImageError = ''.obs;

  // Form controllers
  final productNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final weightController = TextEditingController();
  final priceController = TextEditingController();
  final stockQuantityController = TextEditingController();
  final discountController = TextEditingController();

  // Dropdown and selection
  late final RxString selectedCategory;
  final selectedSubCategory = ''.obs;
  final selectedSubCategoryId = 0.obs;
  final subCategorySearchText = ''.obs;
  final selectedStockQuantity = ''.obs;
  final productImage = ''.obs;
  final isDiscount = false.obs;
  final isOtc = false.obs;

  // Categories and subcategories
  final List<Map<String, dynamic>> categories = const [
    {'id': 1, 'name': 'Fruits'},
    {'id': 2, 'name': 'Vegetables'},
    {'id': 6, 'name': 'Medicine'},
  ];

  final subCategories = <SubcategoryModel>[].obs;
  final isLoadingSubcategories = false.obs;
  final isLoading = false.obs;

  // Services
  final SubcategoryServices _subcategoryServices = SubcategoryServices();
  late final EditMedicineProductServices _editMedicineProductServices;
  late final EditFoodProductServices _editFoodProductServices;

  // Product data
  final productData = <String, dynamic>{}.obs;
  final currentProductId = ''.obs;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void onInit() {
    super.onInit();

    _editMedicineProductServices = EditMedicineProductServices();
    _editFoodProductServices = EditFoodProductServices();

    selectedCategory = (categories.first['id'] as int)
        .toString()
        .obs; // default category

    _loadInitialSubcategories();

    _readRouteArgumentsAndLoadProduct();
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

  // ====== Initialization helpers ======

  Future<void> _loadInitialSubcategories() async {
    await getSubcategories();
  }

  void _readRouteArgumentsAndLoadProduct() {
    final args = Get.arguments;
    String? id;

    if (args is Map<String, dynamic>?) {
      id = args?['id']?.toString();
    } else if (args is String) {
      id = args;
    }

    if (id != null) {
      currentProductId.value = id;
      loadProductData(id);
    }
  }

  // ====== Subcategories ======

  Future<void> getSubcategories() async {
    try {
      final categoryId = _getCategoryIdForVendorType();
      if (categoryId == null) {
        AppLoggerHelper.debug("Unknown vendor type: $vendorType");
        return;
      }

      isLoadingSubcategories.value = true;
      final fetched = await _subcategoryServices.getSubcategories(categoryId);
      subCategories.assignAll(fetched);
      isLoadingSubcategories.value = false;

      if (selectedSubCategoryId.value > 0) {
        final selectedSub = fetched.firstWhereOrNull(
          (sub) => sub.id == selectedSubCategoryId.value,
        );
        if (selectedSub != null) {
          selectedSubCategory.value = selectedSub.name;
        }
      }
    } catch (e) {
      isLoadingSubcategories.value = false;
      log('Error loading subcategories: $e');
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

  List<SubcategoryModel> getFilteredSubCategories() {
    if (subCategorySearchText.value.isEmpty) {
      return subCategories;
    }
    final query = subCategorySearchText.value.toLowerCase();
    return subCategories
        .where((item) => item.name.toLowerCase().contains(query))
        .toList();
  }

  // ====== Product load / populate ======

  void loadProductData(String id) {
    final dataController = Get.find<ProductsController>();
    final product = dataController.getProductById(id);

    if (product == null) return;

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

    getSubcategories();
  }

  // ====== Dialog visibility ======

  void showEditProductDialog() {
    showEditProductModal.value = true;
  }

  void hideEditProductDialog() {
    clearForm();
    showEditProductModal.value = false;
  }

  void showRemoveDiscountConfirmation() {
    showRemoveDiscountDialog.value = true;
  }

  void hideRemoveDiscountConfirmation() {
    showRemoveDiscountDialog.value = false;
  }

  // ====== Form helpers ======

  void clearForm() {
    productNameController.clear();
    descriptionController.clear();
    weightController.clear();
    priceController.clear();
    stockQuantityController.clear();
    discountController.clear();

    selectedCategory.value = (categories.first['id'] as int).toString();
    selectedSubCategory.value = '';
    selectedSubCategoryId.value = 0;
    selectedStockQuantity.value = '';
    productImage.value = '';
    subCategorySearchText.value = '';
    isDiscount.value = false;
    isOtc.value = false;
  }

  void changeCategory(String value) {
    selectedCategory.value = value;
    selectedSubCategory.value = '';
    selectedSubCategoryId.value = 0;
    getSubcategories();
  }

  void changeSubCategory(String value) {
    selectedSubCategory.value = value;
    final selectedSub = subCategories.firstWhereOrNull(
      (sub) => sub.name == value,
    );
    if (selectedSub != null) {
      selectedSubCategoryId.value = selectedSub.id;
    }
  }

  void changeStockQuantity(String value) {
    selectedStockQuantity.value = value;
  }

  void toggleOtc(bool value) {
    isOtc.value = value;
  }

  void removeDiscount() {
    isDiscount.value = false;
    discountController.clear();
    hideRemoveDiscountConfirmation();
  }

  // ====== Image ======

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
      AppLoggerHelper.error('Error picking image: $e');
    }
  }

  // ====== Save / update ======

  Future<void> saveChanges() async {
    if (!_validateForm()) return;

    isLoading.value = true;

    try {
      final discountValue = int.tryParse(discountController.text) ?? 0;
      final File? imageFile =
          productImage.value.isNotEmpty && productImage.value.startsWith('/')
          ? File(productImage.value)
          : null;

      final success = await _updateProduct(discountValue, imageFile);

      isLoading.value = false;

      if (success) {
        AppLoggerHelper.info('Product updated successfully');
        // Refresh products list after successful update
        try {
          final productsController = Get.find<ProductsController>();
          productsController.fetchProducts();
        } catch (e) {
          log('Error refreshing products: $e');
        }
        Future.delayed(const Duration(milliseconds: 500), Get.back);
      } else {
        AppLoggerHelper.error('Failed to update product');
      }
    } catch (e) {
      isLoading.value = false;
      AppLoggerHelper.error('Error saving changes: $e');
      log('Error: $e');
    }
  }

  bool _validateForm() {
    bool isValid = true;

    // Clear previous errors
    productNameError.value = '';
    descriptionError.value = '';
    weightError.value = '';
    priceError.value = '';
    stockQuantityError.value = '';
    discountError.value = '';
    subCategoryError.value = '';
    productImageError.value = '';

    if (productNameController.text.trim().isEmpty) {
      productNameError.value = 'Product name is required';
      isValid = false;
    }

    if (descriptionController.text.trim().isEmpty) {
      descriptionError.value = 'Description is required';
      isValid = false;
    }

    if (weightController.text.trim().isEmpty) {
      weightError.value = 'Product weight/quantity is required';
      isValid = false;
    }

    if (priceController.text.trim().isEmpty) {
      priceError.value = 'Price is required';
      isValid = false;
    }

    if (stockQuantityController.text.trim().isEmpty) {
      stockQuantityError.value = 'Stock quantity is required';
      isValid = false;
    }

    if (selectedSubCategoryId.value == 0) {
      subCategoryError.value = 'Sub category is required';
      isValid = false;
    }

    if (productImage.value.isEmpty) {
      productImageError.value = 'Product image is required';
      isValid = false;
    }

    if (currentProductId.value.isEmpty) {
      AppLoggerHelper.error('Product ID is missing');
      isValid = false;
    }

    return isValid;
  }

  Future<bool> _updateProduct(int discountValue, File? imageFile) async {
    final double price = double.tryParse(priceController.text) ?? 0.0;
    final int stock = int.tryParse(stockQuantityController.text) ?? 0;
    final double? weight = double.tryParse(weightController.text);

    switch (vendorType) {
      case 'medicine':
        return _editMedicineProductServices.updateProduct(
          itemId: currentProductId.value,
          title: productNameController.text,
          description: descriptionController.text,
          subcategoryId: selectedSubCategoryId.value,
          price: price,
          discount: discountValue,
          stock: stock,
          isOTC: isOtc.value,
          weight: weight,
          image: imageFile,
        );
      case 'food':
        return _editFoodProductServices.updateProduct(
          itemId: currentProductId.value,
          title: productNameController.text,
          description: descriptionController.text,
          subcategoryId: selectedSubCategoryId.value,
          price: price,
          discount: discountValue,
          stock: stock,
          weight: weight,
          image: imageFile,
        );
      default:
        AppLoggerHelper.error('Unknown vendor type: $vendorType');
        return false;
    }
  }
}
