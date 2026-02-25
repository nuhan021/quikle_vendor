import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quikle_vendor/features/cupons/models/cupon_model.dart';
import 'package:quikle_vendor/features/cupons/services/cupon_service.dart';
import 'package:quikle_vendor/features/product_management/controllers/products_controller.dart';

class CouponController extends GetxController {
  final coupons = <CouponModel>[].obs;
  final couponService = CouponService();

  final titleCtrl = ''.obs;
  final descriptionCtrl = ''.obs;
  final discountCtrl = ''.obs;
  final productIdCtrl = ''.obs; 
  final editingId = RxnInt();
  final isSaving = false.obs;
  final errorMessage = ''.obs;
  final hasError = false.obs;

  final selectedProductIds = <String>[].obs;
  final selectedProductNames = <String>[].obs;
  final productSearchText = ''.obs;

  final isLoading = false.obs;

  static const String _couponItemsKey = 'coupon_items_map';

  @override
  void onInit() {
    super.onInit();
    fetchCoupons();
  }

  Future<List<int>> _loadCouponItemsLocally(int couponId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingDataJson = prefs.getString(_couponItemsKey) ?? '{}';
      print('DEBUG: Raw local storage data: $existingDataJson');
      final Map<String, dynamic> itemsMap = json.decode(existingDataJson);
      print('DEBUG: Parsed items map: $itemsMap');

      final items = itemsMap[couponId.toString()];
      print('DEBUG: Items for coupon $couponId: $items');
      if (items != null && items is List) {
        final result = List<int>.from(items);
        print('DEBUG: Returning items: $result');
        return result;
      }
    } catch (e) {
      print('ERROR: Failed to load coupon items locally: $e');
    }
    print('DEBUG: No items found for coupon $couponId, returning empty list');
    return [];
  }

  Future<void> fetchCoupons() async {
    try {
      isLoading.value = true;
      final response = await couponService.fetchCoupons();

      if (response.isSuccess) {
        final data = response.responseData;
        print('DEBUG: Fetch response data: $data');

        coupons.clear();

        List<dynamic> couponList = [];
        if (data is List) {
          couponList = data;
        } else if (data is Map && data.containsKey('cupons')) {
          couponList = data['cupons'] ?? [];
        } else if (data is Map && data.containsKey('coupons')) {
          couponList = data['coupons'] ?? [];
        }

        for (var item in couponList) {
          if (item is Map<String, dynamic>) {
            print('DEBUG: Coupon item: $item');
            print('DEBUG: created_at field: ${item['created_at']}');

            final createdAt = item['created_at'] != null
                ? DateTime.tryParse(item['created_at'])
                : DateTime.now();

            print('DEBUG: Parsed createdAt: $createdAt');

            final couponId = item['id'] ?? 0;

            // Get items from API response
            List<int> items = [];
            if (item['items'] != null &&
                item['items'] is List &&
                (item['items'] as List).isNotEmpty) {
              items = List<int>.from(item['items']);
            } else if (item['product_ids'] != null &&
                item['product_ids'] is List &&
                (item['product_ids'] as List).isNotEmpty) {
              items = List<int>.from(item['product_ids']);
            } else {
              items = await _loadCouponItemsLocally(couponId);
              print(
                'DEBUG: Loaded items from local storage for coupon $couponId: $items',
              );
            }

            coupons.add(
              CouponModel(
                id: couponId,
                title: item['title'] ?? '',
                description: item['description'] ?? '',
                code: item['cupon'] ?? item['code'] ?? '',
                discount: item['discount'] ?? 0,
                productId: item['product_id'],
                items: items,
                createdAt: createdAt,
              ),
            );
          }
        }

        coupons.sort((a, b) {
          if (a.createdAt == null && b.createdAt == null) return 0;
          if (a.createdAt == null) return 1;
          if (b.createdAt == null) return -1;
          return b.createdAt!.compareTo(a.createdAt!);
        });

        print('DEBUG: Loaded ${coupons.length} coupons');
        if (coupons.isNotEmpty) {
          print('DEBUG: First coupon created at: ${coupons.first.createdAt}');
          print('DEBUG: Last coupon created at: ${coupons.last.createdAt}');
        }
      } else {
        print('Failed to fetch coupons: ${response.errorMessage}');
      }
    } catch (e) {
      print('Error fetching coupons: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void openCreateForm() {
    editingId.value = null;
    titleCtrl.value = '';
    descriptionCtrl.value = '';
    discountCtrl.value = '';
    productIdCtrl.value = '';
    selectedProductIds.clear();
    selectedProductNames.clear();
    productSearchText.value = '';
    errorMessage.value = '';
    hasError.value = false;
  }

  void openEditForm(CouponModel c) {
    editingId.value = c.id;
    titleCtrl.value = c.title;
    descriptionCtrl.value = c.description;
    discountCtrl.value = c.discount.toString();

    selectedProductIds.clear();
    selectedProductNames.clear();

    print(
      'DEBUG: openEditForm - Coupon ID: ${c.id}, Items from backend: ${c.items}',
    );

    _populateSelectedProducts(List<int>.from(c.items));
  }

  void _populateSelectedProducts(List<int> items) {
    if (items.isNotEmpty) {
      try {
        final productsController = Get.find<ProductsController>();

        for (var itemId in items) {
          final productIdStr = itemId.toString();
          selectedProductIds.add(productIdStr);
          print('DEBUG: Added product ID: $productIdStr');

          final product = productsController.products.firstWhereOrNull(
            (p) => p.id == itemId,
          );
          if (product != null) {
            selectedProductNames.add(product.title);
            print('DEBUG: Added product name: ${product.title}');
          } else {
            print('DEBUG: Product not found for ID: $itemId');
          }
        }

        productIdCtrl.value = selectedProductIds.join(',');
        print('DEBUG: Final selectedProductIds: $selectedProductIds');
        print('DEBUG: Final selectedProductNames: $selectedProductNames');
      } catch (e) {
        print('Error loading products: $e');
      }
    } else {
      productIdCtrl.value = '';
    }
  }

  void saveCoupon() async {
    isSaving.value = true;
    errorMessage.value = '';
    hasError.value = false;

    final title = titleCtrl.value.trim();
    final description = descriptionCtrl.value.trim();
    final discountStr = discountCtrl.value.trim();

    if (title.isEmpty) {
      errorMessage.value = 'Title is required';
      hasError.value = true;
      isSaving.value = false;
      update();
      return;
    }

    if (description.isEmpty) {
      errorMessage.value = 'Description is required';
      hasError.value = true;
      isSaving.value = false;
      update();
      return;
    }

    if (discountStr.isEmpty) {
      errorMessage.value = 'Discount is required';
      hasError.value = true;
      isSaving.value = false;
      update();
      return;
    }

    final discount = int.tryParse(discountStr) ?? 0;

    print('DEBUG: title = "$title"');
    print('DEBUG: description = "$description"');
    print('DEBUG: discount = $discount');

    List<int> productIds = selectedProductIds
        .map((id) => int.tryParse(id) ?? 0)
        .where((id) => id > 0)
        .toList();

    print('DEBUG: Selected product IDs: $productIds');

    final productId = productIds.isNotEmpty ? productIds.first : null;

    try {
      if (editingId.value == null) {
        print(
          'DEBUG: Calling createCoupon with title="$title", description="$description", discount=$discount',
        );
        final response = await couponService.createCoupon(
          title: title,
          description: description,
          discount: discount,
          productIds: productIds.isNotEmpty ? productIds : null,
        );

        if (response.isSuccess) {
          final responseData = response.responseData;
          final couponCode =
              responseData['cupon'] ?? responseData['code'] ?? '';
          final couponId =
              responseData['id'] ??
              (coupons.isNotEmpty ? coupons.last.id + 1 : 1);

          print('DEBUG: Coupon created with code: $couponCode, id: $couponId');

          List<int> itemsFromResponse = [];
          if (responseData['items'] != null && responseData['items'] is List) {
            itemsFromResponse = List<int>.from(responseData['items']);
          }

          final newCoupon = CouponModel(
            id: couponId,
            title: responseData['title'] ?? title,
            description: responseData['description'] ?? description,
            code: couponCode,
            discount: responseData['discount'] ?? discount,
            productId: productId,
            items: itemsFromResponse,
            createdAt: DateTime.now(),
          );

          coupons.insert(0, newCoupon);

          Get.back();
          Get.snackbar(
            'Success',
            'Coupon created successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          errorMessage.value = 'Failed to create coupon. Please try again.';
          hasError.value = true;
        }
      } else {
        final response = await couponService.updateCoupon(
          couponId: editingId.value!,
          title: title,
          description: description,
          discount: discount,
          productIds: productIds.isNotEmpty ? productIds : null,
        );

        if (response.isSuccess) {
          final idx = coupons.indexWhere((c) => c.id == editingId.value);
          if (idx != -1) {
            final responseData = response.responseData;
            final couponCode =
                responseData['cupon'] ??
                responseData['code'] ??
                coupons[idx].code;

            List<int> itemsFromResponse = [];
            if (responseData['items'] != null &&
                responseData['items'] is List) {
              itemsFromResponse = List<int>.from(responseData['items']);
            }

            final updatedCoupon = CouponModel(
              id: coupons[idx].id,
              title: responseData['title'] ?? title,
              description: responseData['description'] ?? description,
              code: couponCode,
              discount: responseData['discount'] ?? discount,
              productId: productId,
              items: itemsFromResponse,
              createdAt: coupons[idx].createdAt,
            );

            coupons[idx] = updatedCoupon;
            coupons.refresh(); 
          }

          await fetchCoupons();

          Get.back();
          Get.snackbar(
            'Success',
            'Coupon updated successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          errorMessage.value = 'Failed to update coupon. Please try again.';
          hasError.value = true;
        }
      }

      titleCtrl.value = '';
      descriptionCtrl.value = '';
      discountCtrl.value = '';
      productIdCtrl.value = '';
      editingId.value = null;

      update();
    } catch (e) {
      print('Error saving coupon: $e');
      errorMessage.value = 'An error occurred: $e';
      hasError.value = true;
      update();
    } finally {
      isSaving.value = false;
      update();
    }
  }

  void deleteCoupon(int id) async {
    try {
      final success = await couponService.deleteCoupon(id);
      if (success) {
        coupons.removeWhere((c) => c.id == id);
        Get.snackbar(
          'Success',
          'Coupon deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete coupon',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error deleting coupon: $e');
      Get.snackbar(
        'Error',
        'An error occurred while deleting coupon',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
