import 'package:quikle_vendor/core/models/response_data.dart';
import 'package:quikle_vendor/core/services/network_caller.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import 'package:quikle_vendor/core/utils/constants/api_constants.dart';
import 'package:quikle_vendor/core/utils/logging/logger.dart';

class AddBeneficiaryServices {
  final NetworkCaller networkCaller = NetworkCaller();

  // Add methods related to adding a beneficiary here
  Future<ResponseData> addBeneficiary({
    required String beneficiaryName,
    required String bankAccountNumber,
    required String bankIfsc,
    String? email,
    String? phone,
    String? refreshToken,
  }) async {
    try {
      AppLoggerHelper.info('Adding beneficiary: $beneficiaryName');

      final headers = <String, String>{};
      if (refreshToken != null && refreshToken.isNotEmpty) {
        headers['refresh-token'] = refreshToken;
      }

      final body = {
        'beneficiary_name': beneficiaryName,
        'bank_account_number': bankAccountNumber,
        'bank_ifsc': bankIfsc,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
      };

      final authHeader = StorageService.token != null
          ? 'Bearer ${StorageService.token}'
          : null;

      final response = await networkCaller.postRequest(
        ApiConstants.addBeneficiary,
        body: body,
        token: authHeader,
        headers: headers.isEmpty ? null : headers,
      );

      AppLoggerHelper.debug('Add beneficiary status: ${response.statusCode}');
      AppLoggerHelper.debug(
        'Add beneficiary responseData: ${response.responseData}',
      );
      AppLoggerHelper.debug(
        'Add beneficiary errorMessage: ${response.errorMessage}',
      );

      return response;
    } catch (e) {
      AppLoggerHelper.error('Add beneficiary error', e);
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: {},
        errorMessage: 'Failed to add beneficiary: $e',
      );
    }
  }
}
