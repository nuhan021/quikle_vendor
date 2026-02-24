import 'dart:developer';
import 'dart:io';

import 'package:quikle_vendor/core/services/network_caller.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import 'package:quikle_vendor/core/utils/constants/api_constants.dart';
import 'package:quikle_vendor/core/utils/logging/logger.dart';
import 'package:quikle_vendor/features/product_management/model/subcategory_model.dart';

class SubcategoryServices {
  final NetworkCaller networkCaller = NetworkCaller();

  Future<List<SubcategoryModel>> getSubcategories(int categoryId) async {
    try {
      AppLoggerHelper.debug(
        'Fetching subcategories for category ID: ${ApiConstants.baseUrl}items/subcategories/?category_id=$categoryId',
      );
      final response = await networkCaller.getRequest(
        ApiConstants.subcategories.replaceFirst(
          '{categoryId}',
          categoryId.toString(),
        ),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.responseData['data'];
        log('Subcategories fetched successfully ${response.responseData}');

        return data.map((json) => SubcategoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load subcategories');
      }
    } catch (e) {
      throw Exception('Failed to load subcategories: $e');
    }
  }

  Future<SubcategoryModel> createSubcategory({
    required int categoryId,
    required String name,
    String? description,
    File? avatar,
  }) async {
    try {
      final response = await networkCaller.postRequest(
        '${ApiConstants.baseUrl}items/subcategories/',
        token: 'Bearer ${StorageService.token}',
        form: true,
        body: {
          'category_id': categoryId,
          'name': name,
          'description': description ?? '',
          'avatar': avatar,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final payload = response.responseData;
        final data = payload is Map<String, dynamic> && payload['data'] != null
            ? payload['data']
            : payload;

        if (data is Map<String, dynamic>) {
          return SubcategoryModel.fromJson(data);
        }
      }

      throw Exception('Failed to create subcategory');
    } catch (e) {
      throw Exception('Failed to create subcategory: $e');
    }
  }
}
