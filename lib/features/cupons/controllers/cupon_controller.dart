import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/features/cupons/models/cupon_model.dart';
import 'package:quikle_vendor/features/cupons/services/cupon_service.dart';

class CouponController extends GetxController {
  final coupons = <CouponModel>[].obs;
  final couponService = CouponService();

  // form fields for modal sheet
  final titleCtrl = ''.obs;
  final descriptionCtrl = ''.obs;
  final discountCtrl = ''.obs;
  final productIdCtrl = ''.obs; // nullable - empty means apply to all
  final editingId = RxnInt();
  final isSaving = false.obs;
  final errorMessage = ''.obs;
  final hasError = false.obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCoupons();
  }

  Future<void> fetchCoupons() async {
    try {
      isLoading.value = true;
      final response = await couponService.fetchCoupons();

      if (response.isSuccess) {
        final data = response.responseData;
        print('DEBUG: Fetch response data: $data');

        // Clear existing coupons
        coupons.clear();

        // Check if data is a list or contains a list
        List<dynamic> couponList = [];
        if (data is List) {
          couponList = data;
        } else if (data is Map && data.containsKey('cupons')) {
          couponList = data['cupons'] ?? [];
        } else if (data is Map && data.containsKey('coupons')) {
          couponList = data['coupons'] ?? [];
        }

        // Parse coupons from response
        for (var item in couponList) {
          if (item is Map<String, dynamic>) {
            print('DEBUG: Coupon item: $item');
            print('DEBUG: created_at field: ${item['created_at']}');

            final createdAt = item['created_at'] != null
                ? DateTime.tryParse(item['created_at'])
                : DateTime.now();

            print('DEBUG: Parsed createdAt: $createdAt');

            coupons.add(
              CouponModel(
                id: item['id'] ?? 0,
                title: item['title'] ?? '',
                description: item['description'] ?? '',
                code: item['cupon'] ?? item['code'] ?? '',
                discount: item['discount'] ?? 0,
                productId: item['product_id'],
                items: item['product_ids'] != null
                    ? List<int>.from(item['product_ids'])
                    : [],
                createdAt: createdAt,
              ),
            );
          }
        }

        // Sort coupons by created date (newest first)
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
    errorMessage.value = '';
    hasError.value = false;
  }

  void openEditForm(CouponModel c) {
    editingId.value = c.id;
    titleCtrl.value = c.title;
    descriptionCtrl.value = c.description;
    discountCtrl.value = c.discount.toString();
    productIdCtrl.value = c.productId?.toString() ?? '';
    errorMessage.value = '';
    hasError.value = false;
  }

  void saveCoupon() async {
    isSaving.value = true;
    errorMessage.value = '';
    hasError.value = false;

    final title = titleCtrl.value.trim();
    final description = descriptionCtrl.value.trim();
    final discountStr = discountCtrl.value.trim();
    final productIdStr = productIdCtrl.value.trim();

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

    // Parse comma-separated product IDs
    List<int> productIds = [];
    if (productIdStr.isNotEmpty) {
      productIds = productIdStr
          .split(',')
          .map((id) => id.trim())
          .where((id) => id.isNotEmpty)
          .map((id) => int.tryParse(id) ?? 0)
          .where((id) => id > 0)
          .toList();
    }

    final productId = productIds.isNotEmpty ? productIds.first : null;

    try {
      if (editingId.value == null) {
        // Create new coupon via API
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
          // Extract coupon data from response
          final responseData = response.responseData;
          final couponCode =
              responseData['cupon'] ?? responseData['code'] ?? '';
          final couponId =
              responseData['id'] ??
              (coupons.isNotEmpty ? coupons.last.id + 1 : 1);

          print('DEBUG: Coupon created with code: $couponCode, id: $couponId');

          // Refresh the coupons list from API
          await fetchCoupons();

          // Close dialog and show success
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
        // Update existing coupon via API
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
            // Extract coupon code from response
            final responseData = response.responseData;
            final couponCode =
                responseData['cupon'] ??
                responseData['code'] ??
                coupons[idx].code;

            coupons[idx] = CouponModel(
              id: coupons[idx].id,
              title: title,
              description: description,
              code: couponCode,
              discount: discount,
              productId: productId,
              items: productIds,
            );
          }

          // Refresh the coupons list from API
          await fetchCoupons();

          // Close dialog and show success
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

      // Reset form fields
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
