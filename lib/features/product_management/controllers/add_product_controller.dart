import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AddProductController extends GetxController {
  var showAddProductModal = false.obs;

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
  late var selectedCategory;
  late var selectedSubCategory;
  var subCategorySearchText = ''.obs;

  // Categories and Sub-categories
  final List<String> categories = ['Fruits', 'Vegetables', 'Dairy', 'Bakery'];
  final Map<String, List<String>> subCategories = {
    'Fruits': ['Apple', 'Orange', 'Banana', 'Mango'],
    'Vegetables': ['Tomato', 'Carrot', 'Cucumber', 'Onion'],
    'Dairy': ['Milk', 'Cheese', 'Yogurt', 'Butter'],
    'Bakery': ['Bread', 'Cake', 'Cookie', 'Pastry'],
  };

  // Get filtered sub-categories
  List<String> getFilteredSubCategories() {
    final allSubCats = subCategories[selectedCategory.value] ?? [];
    if (subCategorySearchText.value.isEmpty) {
      return allSubCats;
    }
    return allSubCats
        .where(
          (item) => item.toLowerCase().contains(
            subCategorySearchText.value.toLowerCase(),
          ),
        )
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    selectedCategory = categories.first.obs;
    selectedSubCategory = (subCategories[categories.first] ?? []).isNotEmpty
        ? (subCategories[categories.first]![0]).obs
        : 'All Categories'.obs;
  }

  // Product data
  var productData = {}.obs;
  var productImage = ''.obs;
  final ImagePicker _imagePicker = ImagePicker();

  void showAddProductDialog() {
    showAddProductModal.value = true;
  }

  void hideAddProductDialog() {
    clearForm();
    showAddProductModal.value = false;
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
  }

  void addProduct() {
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

    // Create product data
    productData['name'] = productNameController.text;
    productData['description'] = descriptionController.text;
    productData['weight'] = weightController.text;
    productData['price'] = double.tryParse(priceController.text) ?? 0.0;
    productData['stock'] = int.tryParse(stockQuantityController.text) ?? 0;
    productData['discount'] = double.tryParse(discountController.text) ?? 0.0;
    productData['category'] = selectedCategory.value;
    productData['subCategory'] = selectedSubCategory.value;
    productData['image'] = productImage.value;

    Get.snackbar(
      'Product Added',
      'New product has been added to inventory',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF10B981),
      colorText: Colors.white,
    );

    hideAddProductDialog();
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
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFFEF4444),
        colorText: Colors.white,
      );
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
