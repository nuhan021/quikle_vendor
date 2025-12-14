import 'dart:developer';
import 'package:quikle_vendor/core/services/network_caller.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import 'package:quikle_vendor/core/utils/constants/api_constants.dart';
import 'package:quikle_vendor/core/utils/logging/logger.dart';
import '../models/prescription_model.dart';

class PrescriptionService {
  final NetworkCaller networkCaller = NetworkCaller();

  /// Get all prescription orders
  Future<List<PrescriptionModel>> getAllPrescriptionOrders() async {
    try {
      log(
        '📤 Fetching all prescriptions from: ${ApiConstants.getAllPrescriptionOrders}',
      );

      final response = await networkCaller.getRequest(
        ApiConstants.getAllPrescriptionOrders,
        headers: {'Authorization': 'Bearer ${StorageService.token}'},
      );

      if (response.statusCode == 200 && response.isSuccess) {
        log('✅ Prescriptions fetched successfully');
        final jsonData = response.responseData;

        // Check if data is a list
        if (jsonData is List) {
          return (jsonData)
              .map(
                (item) =>
                    PrescriptionModel.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        } else if (jsonData is Map<String, dynamic>) {
          // If it's wrapped in an object, extract the list
          final data =
              jsonData['data'] ??
              jsonData['results'] ??
              jsonData['prescriptions'] ??
              jsonData['prescriptionOrders'];
          if (data is List) {
            return (data)
                .map(
                  (item) =>
                      PrescriptionModel.fromJson(item as Map<String, dynamic>),
                )
                .toList();
          }
        }

        log('⚠️ Unexpected response format');
        return [];
      } else {
        log(
          '❌ Failed to fetch prescriptions: ${response.statusCode} - ${response.errorMessage}',
        );
        return [];
      }
    } catch (e) {
      log('❌ Error fetching prescriptions: $e');
      return [];
    }
  }

  /// Get prescription order details by ID
  Future<PrescriptionModel?> getPrescriptionOrderById(
    int prescriptionId,
  ) async {
    try {
      final url = '${ApiConstants.getPrescriptionOrderById}/$prescriptionId';
      log('📤 Fetching prescription details from: $url');

      final response = await networkCaller.getRequest(
        url,
        headers: {'Authorization': 'Bearer ${StorageService.token}'},
      );

      if (response.statusCode == 200 && response.isSuccess) {
        log('✅ Prescription details fetched successfully');
        final jsonData = response.responseData;

        if (jsonData is Map<String, dynamic>) {
          return PrescriptionModel.fromJson(jsonData);
        }

        log('⚠️ Unexpected response format');
        return null;
      } else {
        log(
          '❌ Failed to fetch prescription: ${response.statusCode} - ${response.errorMessage}',
        );
        return null;
      }
    } catch (e) {
      log('❌ Error fetching prescription: $e');
      return null;
    }
  }

  /// Change prescription status
  Future<bool> changePrescriptionStatus(
    int prescriptionId,
    String status,
    int userId,
  ) async {
    try {
      final url =
          '${ApiConstants.changePrescriptionStatus}$prescriptionId?status=$status';
      log('📤 Changing prescription $prescriptionId status to: $status');
      log('📤 Full URL: $url');

      final token = StorageService.token;
      AppLoggerHelper.debug('Using token: $token');

      final response = await networkCaller.putRequest(
        url,
        headers: {'Authorization': 'Bearer ${StorageService.token}'},
      );

      log('Response Status Code: ${response.statusCode}');
      log('Response Body: ${response.responseData}');

      if (response.statusCode == 200 && response.isSuccess) {
        log(
          '✅ Prescription $prescriptionId status changed successfully to $status',
        );

        try {
          final response = await networkCaller.postRequest(
            ApiConstants.sendNotification,
            body: {
              "title": "Prescription Status Updated",
              "body":
                  "Your prescription order #$prescriptionId status has been updated to $status.",
              "user_id": userId,
            },
            headers: {'Authorization': 'Bearer ${StorageService.token}'},
          );

          AppLoggerHelper.debug('Notification sent: ${response.responseData}');
        } catch (e) {}

        return true;
      } else {
        log(
          '❌ Failed to change prescription status: ${response.statusCode} - ${response.errorMessage}',
        );
        return false;
      }
    } catch (e) {
      log('❌ Error changing prescription status: $e');
      return false;
    }
  }

  /// Submit vendor response with medicines and notes
  Future<bool> submitVendorResponse({
    required int prescriptionId,
    required List<Map<String, dynamic>> medicines,
    required String prescriptionNotes,
  }) async {
    try {
      final url = ApiConstants.submitVendorResponse;
      log('📤 Submitting vendor response for prescription $prescriptionId');
      log('📤 Full URL: $url');

      final requestBody = {
        'prescription_id': prescriptionId,
        'notes': prescriptionNotes,
        'medicines': medicines,
      };

      log('📤 Request body: $requestBody');

      final response = await networkCaller.postRequest(
        url,
        body: requestBody,
        headers: {'Authorization': 'Bearer ${StorageService.token}'},
      );

      log('Response Status Code: ${response.statusCode}');
      log('Response Body: ${response.responseData}');

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.isSuccess) {
        log(
          '✅ Vendor response submitted successfully for prescription $prescriptionId',
        );

        try {
          await networkCaller.postRequest(
            ApiConstants.sendNotification,
            body: {
              "title": "Prescription Response Received",
              "body":
                  "Vendor has responded to your prescription order #$prescriptionId with medicines.",
              "prescription_id": prescriptionId,
            },
            headers: {'Authorization': 'Bearer ${StorageService.token}'},
          );
          log('✅ Notification sent to user');
        } catch (e) {
          log('⚠️ Failed to send notification: $e');
        }

        return true;
      } else {
        log(
          '❌ Failed to submit vendor response: ${response.statusCode} - ${response.errorMessage}',
        );
        return false;
      }
    } catch (e) {
      log('❌ Error submitting vendor response: $e');
      return false;
    }
  }
}
