import 'dart:developer';

import 'package:http/http.dart';
import 'package:quikle_vendor/core/services/network_caller.dart';
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
}
