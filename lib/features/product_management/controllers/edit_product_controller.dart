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
  late final EditMedicineProductServices editMedicineProductServices;
  late final EditFoodProductServices editFoodProductServices;

  // Product data
  var productData = {}.obs;
  var currentProductId = ''.obs;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void onInit() {
    super.onInit();

    // Initialize services
    editMedicineProductServices = EditMedicineProductServices();
    editFoodProductServices = EditFoodProductServices();

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
  }

  void saveChanges() async {
    // Validate form
    if (productNameController.text.isEmpty) {
      AppLoggerHelper.error('Product name is required');
      return;
    }

    if (priceController.text.isEmpty) {
      AppLoggerHelper.error('Price is required');
      return;
    }

    if (currentProductId.value.isEmpty) {
      AppLoggerHelper.error('Product ID is missing');
      return;
    }

    try {
      // Get discount value
      final discountValue = int.tryParse(discountController.text) ?? 0;

      // Handle image file
      File? imageFile;
      if (productImage.value.isNotEmpty && productImage.value.startsWith('/')) {
        imageFile = File(productImage.value);
      }

      bool success;

      // Call appropriate service based on vendor type
      if (vendorType == 'medicine') {
        success = await editMedicineProductServices.updateProduct(
          itemId: currentProductId.value,
          title: productNameController.text,
          description: descriptionController.text,
          subcategoryId: selectedSubCategoryId.value,
          price: double.tryParse(priceController.text) ?? 0.0,
          discount: discountValue,
          stock: int.tryParse(stockQuantityController.text) ?? 0,
          isOTC: isOtc.value,
          weight: double.tryParse(weightController.text),
          image: imageFile,
        );
      } else if (vendorType == 'food') {
        success = await editFoodProductServices.updateProduct(
          itemId: currentProductId.value,
          title: productNameController.text,
          description: descriptionController.text,
          subcategoryId: selectedSubCategoryId.value,
          price: double.tryParse(priceController.text) ?? 0.0,
          discount: discountValue,
          stock: int.tryParse(stockQuantityController.text) ?? 0,
          weight: double.tryParse(weightController.text),
          image: imageFile,
        );
      } else {
        AppLoggerHelper.error('Unknown vendor type: $vendorType');
        return;
      }

      if (success) {
        AppLoggerHelper.info('Product updated successfully');
        // Navigate back after a delay
        Future.delayed(Duration(milliseconds: 500), () {
          Get.back();
        });
      } else {
        AppLoggerHelper.error('Failed to update product');
      }
    } catch (e) {
      AppLoggerHelper.error('Error saving changes: $e');
      log('Error: $e');
    }
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
    } catch (e) {}
  }

  void changeCategory(String value) {
    selectedCategory.value = value;
    selectedSubCategory.value = ''; // Reset subcategory when category changes
  }

  void changeSubCategory(String value) {
    selectedSubCategory.value = value;

    // Find and set the subcategoryId based on selected name
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
