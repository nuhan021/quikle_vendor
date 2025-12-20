import 'dart:developer';
import '../../../core/services/network_caller.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/constants/api_constants.dart';

class GetProductServices {
  final NetworkCaller networkCaller = NetworkCaller();

  Future<Map<String, dynamic>> getProducts({
    required String vendorType,
    int offset = 0,
    int limit = 20,
    int? categoryId,
    int? subcategoryId,
  }) async {
    try {
      final String url;
      if (vendorType == 'medicine') {
        url = ApiConstants.getMedicineProducts;
      } else {
        url = ApiConstants.getFoodProducts;
      }

      log(
        '🌐 Fetching products from URL: $url for vendorType: $vendorType, offset: $offset, limit: $limit, categoryId: $categoryId, subcategoryId: $subcategoryId',
      );

      final Map<String, String> queryParams = {
        'offset': offset.toString(),
        'limit': limit.toString(),
      };

      if (categoryId != null) {
        queryParams['categoryId'] = categoryId.toString();
      }
      if (subcategoryId != null) {
        queryParams['subcategoryId'] = subcategoryId.toString();
      }

      final response = await networkCaller.getRequest(
        url,
        headers: {'Authorization': 'Bearer ${StorageService.token}'},
        queryParams: queryParams,
      );

      if (response.statusCode == 200) {
        log('✅ API Status: ${response.statusCode}');
        final data = response.responseData;
        log('📦 Response data keys: ${data.keys}');
        log('📊 Total in response: ${data['total']}, Count: ${data['count']}');
        return data;
      } else {
        log('❌ API Error: ${response.statusCode}');
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
