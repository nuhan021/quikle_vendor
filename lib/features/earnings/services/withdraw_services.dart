import 'package:quikle_vendor/core/models/response_data.dart';
import 'package:quikle_vendor/core/services/network_caller.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import 'package:quikle_vendor/core/utils/constants/api_constants.dart';
import 'package:quikle_vendor/core/utils/logging/logger.dart';

class WithdrawServices {
  final NetworkCaller networkCaller = NetworkCaller();

  Future<ResponseData> withdraw({
    required double amount,
    String? refreshToken,
  }) async {
    try {
      final headers = <String, String>{};
      if (refreshToken != null && refreshToken.isNotEmpty) {
        headers['refresh-token'] = refreshToken;
      }

      final requestAmount = amount % 1 == 0
          ? amount.toInt().toString()
          : amount.toStringAsFixed(2);
      final url = Uri.parse(
        ApiConstants.withdraw,
      ).replace(queryParameters: {'amount': requestAmount}).toString();

      final authHeader = StorageService.token != null
          ? 'Bearer ${StorageService.token}'
          : null;

      AppLoggerHelper.debug('Withdraw request url: $url');

      final response = await networkCaller.postRequest(
        url,
        token: authHeader,
        headers: headers.isEmpty ? null : headers,
      );

      AppLoggerHelper.debug('Withdraw status: ${response.statusCode}');
      AppLoggerHelper.debug('Withdraw responseData: ${response.responseData}');
      AppLoggerHelper.debug('Withdraw errorMessage: ${response.errorMessage}');

      return response;
    } catch (e) {
      AppLoggerHelper.error('Withdraw error', e);
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: {},
        errorMessage: 'Failed to withdraw funds: $e',
      );
    }
  }
}
