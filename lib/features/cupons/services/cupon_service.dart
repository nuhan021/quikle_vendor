import 'dart:developer';
import 'package:quikle_vendor/core/models/response_data.dart';
import 'package:quikle_vendor/core/services/network_caller.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import 'package:quikle_vendor/core/utils/constants/api_constants.dart';

class CouponService {
  final NetworkCaller networkCaller = NetworkCaller();

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

      // Add product IDs if provided
      if (productIds != null && productIds.isNotEmpty) {
        body['product_ids'] = productIds;
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

      final Map<String, dynamic> body = {
        'title': title,
        'description': description,
        'discount': discount,
      };

      // Add product IDs if provided
      if (productIds != null && productIds.isNotEmpty) {
        body['product_ids'] = productIds;
      }

      log('Updating Coupon with body: $body');
      log('Update URL: $updateUrl');

      final response = await networkCaller.putRequest(
        updateUrl,
        token: 'Bearer ${StorageService.token}',
        body: body,
        form: true,
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
