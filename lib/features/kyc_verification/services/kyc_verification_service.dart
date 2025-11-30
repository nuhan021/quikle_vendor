import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:quikle_vendor/core/models/response_data.dart';
import 'package:quikle_vendor/core/services/network_caller.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import 'package:quikle_vendor/core/utils/constants/api_constants.dart';
import 'package:quikle_vendor/core/utils/logging/logger.dart';

class KycVerificationService {
  final NetworkCaller _network = NetworkCaller();

  /// Update KYC with multipart (PUT request)
  Future<ResponseData> updateKyc({
    required String nid,
    required String vendorType,
    required double latitude,
    required double longitude,
    File? kycFile,
    String? refreshToken,
  }) async {
    try {
      AppLoggerHelper.debug('📤 KYC Submission Started');
      AppLoggerHelper.info('NID: $nid');
      AppLoggerHelper.info('Vendor Type: $vendorType');
      AppLoggerHelper.info('Latitude: $latitude, Longitude: $longitude');
      AppLoggerHelper.info('Has KYC File: ${kycFile != null}');

      // Prepare headers including refresh-token if provided
      final headers = <String, String>{};
      if (refreshToken != null && refreshToken.isNotEmpty) {
        headers['refresh-token'] = refreshToken;
      }

      final response = await _network.multipartRequest(
        ApiConstants.updateKyc,
        method: 'PUT', // Use PUT method as per API specification
        token: 'Bearer ${StorageService.token}',
        headers: headers,
        fields: {
          'nid': nid,
          'vendor_type': vendorType,
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
        },
        files: kycFile != null
            ? [
                http.MultipartFile(
                  'file',
                  kycFile.readAsBytes().asStream(),
                  kycFile.lengthSync(),
                  filename: kycFile.path.split('/').last,
                ),
              ]
            : null,
      );

      return response;
    } catch (e) {
      AppLoggerHelper.error('❌ KYC Update Error: $e');
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: {},
        errorMessage: 'KYC Update Failed: $e',
      );
    }
  }
}
