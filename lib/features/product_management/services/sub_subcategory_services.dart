import 'dart:developer';
import 'dart:io';
import 'package:quikle_vendor/core/services/network_caller.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import 'package:quikle_vendor/core/utils/constants/api_constants.dart';
import 'package:quikle_vendor/core/utils/logging/logger.dart';
import '../model/sub_subcategory_model.dart';

class SubSubcategoryServices {
  final NetworkCaller networkCaller = NetworkCaller();

  // Fetch sub-subcategories by subcategory ID

  Future<List<SubSubcategoryModel>> getSubSubcategories(int subcategoryId) async {
    try {
      AppLoggerHelper.debug(
        'Fetching sub subcategories for subcategory ID: $subcategoryId',
      );
      
      // Construct the URL with query parameter
      final url = '${ApiConstants.baseUrl}items/sub-subcategories/?subcategory_id=$subcategoryId';
      
      final response = await networkCaller.getRequest(
        url,
        token: 'Bearer ${StorageService.token}',
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.responseData['data'] ?? [];
        log('Sub subcategories fetched successfully: ${response.responseData}');

        return data
            .map((json) => SubSubcategoryModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load sub subcategories');
      }
    } catch (e) {
      AppLoggerHelper.debug('Error loading sub subcategories: $e');
      throw Exception('Failed to load sub subcategories: $e');
    }
  }

  // Create a new sub-subcategory

  Future<SubSubcategoryModel> createSubSubcategory({
    required int subcategoryId,
    required String name,
    String? description,
    File? avatar,
  }) async {
    try {
      AppLoggerHelper.debug(
        'Creating sub subcategory: $name for subcategory ID: $subcategoryId',
      );
      final response = await networkCaller.postRequest(
        // 'https://caditya619-backend-ng0e.onrender.com/items/sub-subcategories/',
        ApiConstants.createSubSubcategory,
        token: 'Bearer ${StorageService.token}',
        form: true,
        body: {
          'subcategory_id': subcategoryId,
          'name': name,
          'description': description,
          'avatar': avatar,
        },
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.responseData['data'];
        log('Sub subcategory created successfully: $data');

        return SubSubcategoryModel.fromJson(data);
      } else {
        throw Exception('Failed to create sub subcategory');
      }
    } catch (e) {
      AppLoggerHelper.debug('Error creating sub subcategory: $e');
      throw Exception('Failed to create sub subcategory: $e');
    }
  }
}
