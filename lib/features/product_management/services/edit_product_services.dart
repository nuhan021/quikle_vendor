import 'dart:developer';
import 'dart:io';
import 'package:quikle_vendor/core/services/network_caller.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import '../../../core/utils/constants/api_constants.dart';

class AddMedicineProductServices {
  final NetworkCaller networkCaller = NetworkCaller();

  Future<bool> addProduct({
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
    final response = await networkCaller.postRequest(
      ApiConstants.addProductMedicine,
      token: 'Bearer ${StorageService.token}',
      form: true,
      body: {
        'title': title,
        'description': description,
        'subcategory_id': subcategoryId,
        'price': price,
        'discount': discount,
        'stock': stock,
        'popular': popular,
        'free_delivery': freeDelivery,
        'hot_deals': hotDeals,
        'flash_sale': flashSale,
        'isOTC': isOTC,
        'weight': weight,
        'image': image,
      },
    );
    log('Add Product Response: ${response.responseData}');
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
    final response = await networkCaller.postRequest(
      ApiConstants.addProductFood,
      token: 'Bearer ${StorageService.token}',
      form: true,
      body: {
        'title': title,
        'description': description,
        'subcategory_id': subcategoryId,
        'price': price,
        'discount': discount,
        'stock': stock,
        'popular': popular,
        'free_delivery': freeDelivery,
        'hot_deals': hotDeals,
        'flash_sale': flashSale,
        'weight': weight,
        'image': image,
      },
    );
    log('Add Product Response: ${response.responseData}');
    log('Status Code: ${response.statusCode}');
    return response.isSuccess;
  }
}
