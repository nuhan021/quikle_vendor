import 'package:get/get.dart';
import 'package:quikle_vendor/core/models/response_data.dart';
import 'package:quikle_vendor/core/services/network_caller.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import 'package:quikle_vendor/core/utils/constants/api_constants.dart';
import 'package:quikle_vendor/core/utils/logging/logger.dart';

class HomeServices extends GetxService {
  final NetworkCaller _network = NetworkCaller();

  /// Toggle Active (Open/Close) Vendor Shop
  Future<ResponseData> toggleActiveStatus() async {
    final token = StorageService.token;
    AppLoggerHelper.info('🔄 Toggling vendor active status...');

    final response = await _network.putRequest(
      ApiConstants.toggleActiveStatus,
      token: "Bearer $token",
    );

    return response;
  }
}
