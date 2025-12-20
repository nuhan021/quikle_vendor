import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:quikle_vendor/core/services/network_caller.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import '../../../core/utils/constants/api_constants.dart';

class EditMedicineProductServices {
  final NetworkCaller networkCaller = NetworkCaller();

  Future<bool> updateProduct({
    required String itemId,
    required String title,
    String? description,
    int? subcategoryId,
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
    final url = ApiConstants.updateProductMedicine.replaceFirst(
      '{itemId}',
      itemId,
    );

    // Build fields map
    final fields = <String, String>{
      'title': title,
      if (description != null) 'description': description,
      if (subcategoryId != null) 'subcategory_id': subcategoryId.toString(),
      'price': price.toString(),
      'discount': discount.toString(),
      'stock': stock.toString(),
      'popular': popular.toString(),
      'free_delivery': freeDelivery.toString(),
      'hot_deals': hotDeals.toString(),
      'flash_sale': flashSale.toString(),
      'isOTC': isOTC.toString(),
      if (weight != null) 'weight': weight.toString(),
    };

    // Build files list
    final files = <http.MultipartFile>[];
    if (image != null && !image.path.startsWith('http')) {
      files.add(
        http.MultipartFile.fromBytes(
          'image',
          image.readAsBytesSync(),
          filename: image.path.split('/').last,
        ),
      );
    }

    final response = await networkCaller.multipartRequest(
      url,
      fields: fields,
      files: files.isNotEmpty ? files : null,
      token: 'Bearer ${StorageService.token}',
      method: 'PATCH',
    );

    log('Update Product Response: ${response.responseData}');
    log('Status Code: ${response.statusCode}');
    return response.isSuccess;
  }

  Future<bool> stockOutAndDisableProduct({required String itemId}) async {
    final url = ApiConstants.patchMedicineStock.replaceFirst(
      '{itemId}',
      itemId,
    );

    // Build fields map - only change is_stock flag, keep stock quantity unchanged
    final fields = <String, String>{'is_stock': 'false'};

    final response = await networkCaller.multipartRequest(
      url,
      fields: fields,
      token: 'Bearer ${StorageService.token}',
      method: 'PATCH',
    );

    log('Stock Out Response: ${response.responseData}');
    log('Status Code: ${response.statusCode}');
    return response.isSuccess;
  }

  Future<bool> restoreStock({
    required String itemId,
    required int stock,
  }) async {
    final url = ApiConstants.patchMedicineStock.replaceFirst(
      '{itemId}',
      itemId,
    );

    // Build fields map
    final fields = <String, String>{
      'stock': stock.toString(),
      'is_stock': 'true',
    };

    final response = await networkCaller.multipartRequest(
      url,
      fields: fields,
      token: 'Bearer ${StorageService.token}',
      method: 'PATCH',
    );

    log('Restore Stock Response: ${response.responseData}');
    log('Status Code: ${response.statusCode}');
    return response.isSuccess;
  }
}

class EditFoodProductServices {
  final NetworkCaller networkCaller = NetworkCaller();

  Future<bool> updateProduct({
    required String itemId,
    required String title,
    String? description,
    int? subcategoryId,
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
    final url = ApiConstants.updateProductFood.replaceFirst('{itemId}', itemId);

    // Build fields map
    final fields = <String, String>{
      'title': title,
      if (description != null) 'description': description,
      if (subcategoryId != null) 'subcategory_id': subcategoryId.toString(),
      'price': price.toString(),
      'discount': discount.toString(),
      'stock': stock.toString(),
      'popular': popular.toString(),
      'free_delivery': freeDelivery.toString(),
      'hot_deals': hotDeals.toString(),
      'flash_sale': flashSale.toString(),
      if (weight != null) 'weight': weight.toString(),
    };

    // Build files list
    final files = <http.MultipartFile>[];
    if (image != null && !image.path.startsWith('http')) {
      files.add(
        http.MultipartFile.fromBytes(
          'image',
          image.readAsBytesSync(),
          filename: image.path.split('/').last,
        ),
      );
    }

    final response = await networkCaller.multipartRequest(
      url,
      fields: fields,
      files: files.isNotEmpty ? files : null,
      token: 'Bearer ${StorageService.token}',
      method: 'PATCH',
    );

    log('Update Product Response: ${response.responseData}');
    log('Status Code: ${response.statusCode}');
    return response.isSuccess;
  }

  Future<bool> stockOutAndDisableProduct({required String itemId}) async {
    final url = ApiConstants.patchFoodStock.replaceFirst('{itemId}', itemId);

    // Build fields map - only change is_stock flag, keep stock quantity unchanged
    final fields = <String, String>{'is_stock': 'false'};

    final response = await networkCaller.multipartRequest(
      url,
      fields: fields,
      token: 'Bearer ${StorageService.token}',
      method: 'PATCH',
    );

    log('Food Stock Out Response: ${response.responseData}');
    log('Status Code: ${response.statusCode}');
    return response.isSuccess;
  }

  Future<bool> restoreStock({
    required String itemId,
    required int stock,
  }) async {
    final url = ApiConstants.patchFoodStock.replaceFirst('{itemId}', itemId);

    // Build fields map
    final fields = <String, String>{
      'stock': stock.toString(),
      'is_stock': 'true',
    };

    final response = await networkCaller.multipartRequest(
      url,
      fields: fields,
      token: 'Bearer ${StorageService.token}',
      method: 'PATCH',
    );

    log('Food Restore Stock Response: ${response.responseData}');
    log('Status Code: ${response.statusCode}');
    return response.isSuccess;
  }
}
