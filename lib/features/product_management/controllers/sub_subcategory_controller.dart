import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quikle_vendor/core/utils/logging/logger.dart';
import '../model/sub_subcategory_model.dart';
import '../services/sub_subcategory_services.dart';

class SubSubcategoryController extends GetxController {
  // Dependencies
  final SubSubcategoryServices _subSubcategoryServices = SubSubcategoryServices();
  final ImagePicker _imagePicker = ImagePicker();

  // UI state
  final isLoading = false.obs;
  final isCreating = false.obs;
  final subSubCategoryImage = ''.obs;

  // Form controllers
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  // Data
  final subSubCategoriesList = <SubSubcategoryModel>[].obs;
  final searchText = ''.obs;

  // ====== Lifecycle ======

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  // ====== Public API ======

  Future<void> loadSubSubcategories(int subcategoryId) async {
    if (subcategoryId == 0) {
      subSubCategoriesList.clear();
      return;
    }

    isLoading.value = true;
    try {
      final subSubcategories =
          await _subSubcategoryServices.getSubSubcategories(subcategoryId);
      subSubCategoriesList.value = subSubcategories;
    } catch (e) {
      log('Error loading sub subcategories: $e');
      AppLoggerHelper.debug('Error loading sub subcategories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createSubSubcategory({
    required int subcategoryId,
    required String name,
    String? description,
  }) async {
    if (!_validateForm(name)) {
      return false;
    }

    isCreating.value = true;
    isLoading.value = true;
    try {
      final File? imageFile = subSubCategoryImage.value.isNotEmpty
          ? File(subSubCategoryImage.value)
          : null;

      final newSubSubcategory =
          await _subSubcategoryServices.createSubSubcategory(
        subcategoryId: subcategoryId,
        name: name,
        description: description,
        avatar: imageFile,
      );

      AppLoggerHelper.debug("Created sub subcategory: ${subcategoryId}, ${name}, ${description}");

      // Add to list
      subSubCategoriesList.add(newSubSubcategory);

      // Clear form
      clearForm();

      AppLoggerHelper.debug(
        'Sub subcategory created successfully: ${newSubSubcategory.name}',
      );
      return true;
    } catch (e) {
      log('Error creating sub subcategory: $e');
      AppLoggerHelper.debug('Error creating sub subcategory: $e');
      return false;
    } finally {
      isCreating.value = false;
      isLoading.value = false;
    }
  }

  Future<void> pickSubSubcategoryImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        subSubCategoryImage.value = pickedFile.path;
      }
    } catch (e) {
      AppLoggerHelper.debug('Error picking image: $e');
    }
  }

  void clearForm() {
    nameController.clear();
    descriptionController.clear();
    subSubCategoryImage.value = '';
    searchText.value = '';
  }

  // ====== Private helpers ======

  bool _validateForm(String name) {
    if (name.isEmpty) {
      AppLoggerHelper.debug('Sub subcategory name is empty');
      return false;
    }

    return true;
  }
}
