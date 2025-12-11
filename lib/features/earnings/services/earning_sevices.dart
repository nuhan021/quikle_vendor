import 'dart:convert';
import 'package:quikle_vendor/core/services/network_caller.dart';
import 'package:quikle_vendor/core/utils/constants/api_constants.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import '../model/earnings_model.dart';

class EarningsService {
  final NetworkCaller _networkCaller = NetworkCaller();

  /// Fetch vendor account / earnings summary
  Future<EarningsModel?> fetchVendorAccount({
    String? period, // e.g. 'this_week', 'this_month', 'this_year'
    String? token,
    bool debug = true,
  }) async {
    try {
      final queryParams = {if (period != null) 'period': period};

      final authHeader =
          token ??
          (StorageService.token != null
              ? 'Bearer ${StorageService.token}'
              : null);

      final response = await _networkCaller.getRequest(
        ApiConstants.vendorAccount,
        queryParams: queryParams.isEmpty ? null : queryParams,
        token: authHeader,
      );

      if (debug) {
        print('--- EarningsService.fetchVendorAccount DEBUG ---');
        print('URL: ${ApiConstants.vendorAccount}');
        print('Query: $queryParams');
        print('Status: ${response.statusCode}');
        print('Success: ${response.isSuccess}');
        print('Body: ${response.responseData}');
      }

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData is String
            ? jsonDecode(response.responseData as String)
                  as Map<String, dynamic>
            : (response.responseData as Map<String, dynamic>);

        return EarningsModel.fromJson(data);
      }

      return null;
    } catch (e) {
      print('Error fetching vendor account: $e');
      return null;
    }
  }
}
