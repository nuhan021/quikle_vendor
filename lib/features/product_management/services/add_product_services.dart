import 'dart:developer';
import 'dart:io';
import 'package:quikle_vendor/core/services/network_caller.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import 'package:quikle_vendor/core/utils/logging/logger.dart';
import '../../../core/utils/constants/api_constants.dart';

class AddMedicineProductServices {
  final NetworkCaller networkCaller = NetworkCaller();

  Future<bool> addProduct({
    required String title,
    String? description,
    int? subcategoryId,
    int? subSubcategoryId,
    required double price,
    int discount = 0,
    int stock = 0,
    bool popular = false,
    bool freeDelivery = false,
    bool hotDeals = false,
    bool flashSale = false,
    bool isOTC = false,
    double? weight,
    File? image,
  }) async {
    final body = <String, dynamic>{
      'title': title,
      'price': price,
      'discount': discount,
      'stock': stock,
      'popular': popular,
      'free_delivery': freeDelivery,
      'hot_deals': hotDeals,
      'flash_sale': flashSale,
      'isOTC': isOTC,
      if (description != null && description.trim().isNotEmpty)
        'description': description.trim(),
      if (subcategoryId != null) 'subcategory_id': subcategoryId,
      if (subSubcategoryId != null) 'sub_subcategory_id': subSubcategoryId,
      if (weight != null) 'weight': weight,
      if (image != null) 'image': image,
    };

    final response = await networkCaller.postRequest(
      ApiConstants.addProductMedicine,
      token: 'Bearer ${StorageService.token}',
      form: true,
      body: body,
    );
    log('Add Product Response: ${response.responseData}');
    AppLoggerHelper.debug('Add Product full body: $response');
    log('Status Code: ${response.statusCode}');
    return response.isSuccess;
  }
}

class AddFoodProductServices {
  final NetworkCaller networkCaller = NetworkCaller();

  Future<bool> addProduct({
    required String title,
    String? description,
    int? subcategoryId,
    int? subSubcategoryId,
    required double price,
    int discount = 0,
    int stock = 0,
    bool popular = false,
    bool freeDelivery = false,
    bool hotDeals = false,
    bool flashSale = false,
    double? weight,
    File? image,
  }) async {
    final body = <String, dynamic>{
      'title': title,
      'price': price,
      'discount': discount,
      'stock': stock,
      'popular': popular,
      'free_delivery': freeDelivery,
      'hot_deals': hotDeals,
      'flash_sale': flashSale,
      if (description != null && description.trim().isNotEmpty)
        'description': description.trim(),
      if (subcategoryId != null) 'subcategory_id': subcategoryId,
      if (subSubcategoryId != null) 'sub_subcategory_id': subSubcategoryId,
      if (weight != null) 'weight': weight,
      if (image != null) 'image': image,
    };

    final response = await networkCaller.postRequest(
      ApiConstants.addProductFood,
      token: 'Bearer ${StorageService.token}',
      form: true,
      body: body,
    );
    log('Add Product Response: ${response.responseData}');
    log('Status Code: ${response.statusCode}');
    return response.isSuccess;
  }
}
