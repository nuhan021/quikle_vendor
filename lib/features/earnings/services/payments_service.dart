import 'dart:convert';

import 'package:quikle_vendor/core/services/network_caller.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import 'package:quikle_vendor/core/utils/constants/api_constants.dart';

import '../model/payment_transaction_model.dart';

class PaymentsService {
  final NetworkCaller _networkCaller = NetworkCaller();

  Future<PaymentsResponseModel> fetchConfirmedPayments({
    int offset = 0,
    int limit = 5,
    String status = 'confirmed',
    String? token,
  }) async {
    final authHeader =
        token ??
        (StorageService.token != null
            ? 'Bearer ${StorageService.token}'
            : null);

    final useDefaultEndpoint =
        offset == 0 && limit == 5 && status.toLowerCase() == 'confirmed';

    final response = await _networkCaller.getRequest(
      useDefaultEndpoint
          ? ApiConstants.confirmedPaymentOrders
          : ApiConstants.myOrders,
      queryParams: useDefaultEndpoint
          ? null
          : {'offset': offset, 'limit': limit, 'status': status},
      token: authHeader,
    );

    if (!response.isSuccess || response.responseData == null) {
      throw Exception(
        response.errorMessage.isNotEmpty
            ? response.errorMessage
            : 'Failed to load payments.',
      );
    }

    final data = response.responseData is String
        ? jsonDecode(response.responseData as String) as Map<String, dynamic>
        : response.responseData as Map<String, dynamic>;

    return PaymentsResponseModel.fromJson(data);
  }
}
