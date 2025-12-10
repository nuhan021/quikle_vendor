import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:quikle_vendor/core/models/response_data.dart';
import 'package:quikle_vendor/core/services/network_caller.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import 'package:quikle_vendor/core/utils/constants/api_constants.dart';
import 'package:quikle_vendor/core/utils/logging/logger.dart';

class EditProfileServices {
  final NetworkCaller _network = NetworkCaller();

  /// Update vendor profile with PUT request
  Future<ResponseData> updateVendorProfile({
    required String ownerName,
    required String openTime,
    required String closeTime,
    File? profileImage,
  }) async {
    try {
      AppLoggerHelper.debug('📤 Profile Update Started');
      AppLoggerHelper.info('Owner Name: $ownerName');
      AppLoggerHelper.info('Opening Time: $openTime');
      AppLoggerHelper.info('Closing Time: $closeTime');
      AppLoggerHelper.info('Has Profile Image: ${profileImage != null}');
      if (profileImage != null) {
        AppLoggerHelper.info('Profile Image Path: ${profileImage.path}');
        AppLoggerHelper.info(
          'Profile Image Size: ${File(profileImage.path).lengthSync()} bytes',
        );
      }

      // Build fields map
      final fields = <String, String>{
        'owner_name': ownerName,
        'open_time': openTime,
        'close_time': closeTime,
        'is_completed': 'true',
      };

      // Build files list
      final files = <http.MultipartFile>[];
      if (profileImage != null && !profileImage.path.startsWith('http')) {
        final imageFile = File(profileImage.path);
        if (await imageFile.exists()) {
          AppLoggerHelper.info('Adding photo to request with key: photo');
          files.add(
            http.MultipartFile.fromBytes(
              'photo',
              imageFile.readAsBytesSync(),
              filename: profileImage.path.split('/').last,
            ),
          );
          AppLoggerHelper.info('Photo added successfully');
        } else {
          AppLoggerHelper.error(
            'Image file does not exist at: ${profileImage.path}',
          );
        }
      }

      final response = await _network.multipartRequest(
        ApiConstants.updateVendorProfile,
        fields: fields,
        files: files.isNotEmpty ? files : null,
        token: 'Bearer ${StorageService.token}',
        method: 'PUT',
      );

      AppLoggerHelper.debug('📡 Full API Response:');
      AppLoggerHelper.debug('Status Code: ${response.statusCode}');
      AppLoggerHelper.debug('Is Success: ${response.isSuccess}');
      AppLoggerHelper.debug('Error Message: ${response.errorMessage}');
      AppLoggerHelper.debug('Response Data: ${response.responseData}');

      return response;
    } catch (e) {
      AppLoggerHelper.error('❌ Profile Update Error: $e');
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: {},
        errorMessage: 'Profile Update Failed: $e',
      );
    }
  }
}
