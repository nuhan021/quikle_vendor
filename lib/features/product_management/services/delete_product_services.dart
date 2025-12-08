import 'dart:developer';
import 'package:quikle_vendor/core/services/network_caller.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import '../../../core/utils/constants/api_constants.dart';

class DeleteMedicineProductServices {
  final NetworkCaller networkCaller = NetworkCaller();

  Future<bool> deleteProduct({required String itemId}) async {
    final url = ApiConstants.deleteProductMedicine.replaceFirst(
      '{itemId}',
      itemId,
    );

    try {
      final response = await networkCaller.deleteRequest(
        url,
        token: 'Bearer ${StorageService.token}',
      );

      log('Delete Product Response: ${response.responseData}');
      log('Status Code: ${response.statusCode}');
      return response.isSuccess;
    } catch (e) {
      log('Error deleting product: $e');
      return false;
    }
  }
}

class DeleteFoodProductServices {
  final NetworkCaller networkCaller = NetworkCaller();

  Future<bool> deleteProduct({required String itemId}) async {
    final url = ApiConstants.deleteProductFood.replaceFirst('{itemId}', itemId);

    try {
      final response = await networkCaller.deleteRequest(
        url,
        token: 'Bearer ${StorageService.token}',
      );

      log('Delete Product Response: ${response.responseData}');
      log('Status Code: ${response.statusCode}');
      return response.isSuccess;
    } catch (e) {
      log('Error deleting product: $e');
      return false;
    }
  }
}
