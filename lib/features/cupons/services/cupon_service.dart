import 'dart:developer';
import 'package:quikle_vendor/core/models/response_data.dart';
import 'package:quikle_vendor/core/services/network_caller.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import 'package:quikle_vendor/core/utils/constants/api_constants.dart';
import 'package:quikle_vendor/features/cupons/network/cupon_network_caller.dart';

class CouponService {
  final NetworkCaller networkCaller = NetworkCaller();
  final CouponNetworkCaller couponNetworkCaller = CouponNetworkCaller();

  Future<ResponseData> createCoupon({
    required String title,
    required String description,
    required int discount,
    List<int>? productIds,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'title': title,
        'description': description,
        'discount': discount,
      };

      // Add product IDs if provided - send as comma-separated string for form data
      if (productIds != null && productIds.isNotEmpty) {
        body['item_ids'] = productIds.join(',');
      }

      log('Creating Coupon with body: $body');
      log('Title: $title, Description: $description, Discount: $discount');

      final response = await networkCaller.postRequest(
        ApiConstants.createCupon,
        token: 'Bearer ${StorageService.token}',
        body: body,
        form: true,
      );

      log('Create Coupon Response: ${response.responseData}');
      log('Status Code: ${response.statusCode}');

      return response;
    } catch (e) {
      log('Create Coupon Error: $e');
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: {},
        errorMessage: e.toString(),
      );
    }
  }

  Future<ResponseData> updateCoupon({
    required int couponId,
    required String title,
    required String description,
    required int discount,
    List<int>? productIds,
  }) async {
    try {
      final String updateUrl = '${ApiConstants.updateCupon}$couponId';

      // Build the body with correct types for form encoding
      final Map<String, dynamic> body = {
        'title': title, // String
        'description': description, // String
        'discount': discount, // int
      };

      // Add product IDs as List<int> - NetworkCaller will encode as repeated keys
      // Backend expects: item_ids=25802&item_ids=25789
      if (productIds != null && productIds.isNotEmpty) {
        body['item_ids'] = productIds; // List<int>
      }

      log('Updating Coupon with body: $body');
      log('Update URL: $updateUrl');

      // Use custom CouponNetworkCaller with proper form array encoding
      // Backend expects: item_ids=25802&item_ids=25789 (repeated keys)
      final response = await couponNetworkCaller.putRequest(
        updateUrl,
        token: 'Bearer ${StorageService.token}',
        body: body,
      );

      log('Update Coupon Response: ${response.responseData}');
      log('Status Code: ${response.statusCode}');

      return response;
    } catch (e) {
      log('Update Coupon Error: $e');
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: {},
        errorMessage: e.toString(),
      );
    }
  }

  Future<ResponseData> fetchCoupons() async {
    try {
      final response = await networkCaller.getRequest(
        ApiConstants.getCupons,
        token: 'Bearer ${StorageService.token}',
      );

      log('Fetch Coupons Response: ${response.responseData}');
      log('Status Code: ${response.statusCode}');

      return response;
    } catch (e) {
      log('Fetch Coupons Error: $e');
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: {},
        errorMessage: e.toString(),
      );
    }
  }

  Future<bool> deleteCoupon(int couponId) async {
    try {
      final String deleteUrl = '${ApiConstants.deleteCupon}$couponId';

      final response = await networkCaller.deleteRequest(
        deleteUrl,
        token: 'Bearer ${StorageService.token}',
      );

      log('Delete Coupon Response: ${response.responseData}');
      log('Status Code: ${response.statusCode}');

      return response.isSuccess;
    } catch (e) {
      log('Delete Coupon Error: $e');
      return false;
    }
  }
}
