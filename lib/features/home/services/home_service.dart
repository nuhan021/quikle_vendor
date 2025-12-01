import 'package:quikle_vendor/core/models/response_data.dart';
import 'package:quikle_vendor/core/services/network_caller.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import 'package:quikle_vendor/core/utils/constants/api_constants.dart';

class HomeService {
  final NetworkCaller _network = NetworkCaller();

  /// Toggle vendor active status (open/closed)
  Future<ResponseData> toggleActiveStatus() async {
    final token = StorageService.token;

    if (token == null || token.isEmpty) {
      return ResponseData(
        isSuccess: false,
        statusCode: 401,
        errorMessage: 'Authentication token not found',
        responseData: null,
      );
    }

    return await _network.putRequest(
      ApiConstants.toggle_active_status,
      token: 'Bearer $token',
    );
  }
}
