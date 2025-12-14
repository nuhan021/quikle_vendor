import 'dart:developer';
import 'package:get/get.dart';
import 'package:quikle_vendor/features/order_management/prescription_order_management/models/prescription_model.dart';
import 'package:quikle_vendor/features/order_management/prescription_order_management/services/prescription_service.dart';

class PrescriptionController extends GetxController {
  final prescriptions = <PrescriptionModel>[].obs;
  final isLoading = false.obs;
  final PrescriptionService prescriptionService = PrescriptionService();

  @override
  void onInit() {
    super.onInit();
    loadPrescriptions();
  }

  Future<void> loadPrescriptions() async {
    try {
      isLoading.value = true;
      log('Loading prescriptions...');

      final data = await prescriptionService.getAllPrescriptionOrders();

      if (data.isNotEmpty) {
        prescriptions.assignAll(data);
        log('✅ Loaded ${data.length} prescriptions from API');
      } else {
        log('⚠️ No prescriptions found, loading mock data');
        // Fallback to mock data if API returns empty
        _loadMockData();
      }
    } catch (e) {
      log('❌ Error loading prescriptions: $e');
      _loadMockData();
    } finally {
      isLoading.value = false;
    }
  }

  void _loadMockData() {
    // Mock data for development/fallback
    prescriptions.assignAll([
      PrescriptionModel(
        id: 1,
        userId: 101,
        userName: 'Sarah Jenkins',
        imagePath: 'assets/rx-image-1.jpg',
        status: 'pending',
        notes: 'Waiting for pharmacy review',
        uploadedAt: '2023-10-28',
      ),
      PrescriptionModel(
        id: 2,
        userId: 102,
        userName: 'David Chen',
        imagePath: 'assets/rx-image-2.jpg',
        status: 'approved',
        notes: 'Approved and ready for fulfillment',
        uploadedAt: '2023-10-25',
      ),
      PrescriptionModel(
        id: 3,
        userId: 103,
        userName: 'Maria Rodriguez',
        imagePath: 'assets/rx-image-3.jpg',
        status: 'clarification',
        notes: 'Needs clarification on dosage',
        uploadedAt: '2023-10-25',
      ),
      PrescriptionModel(
        id: 4,
        userId: 104,
        userName: 'James Smith',
        imagePath: 'assets/rx-image-4.jpg',
        status: 'approved',
        notes: 'Ready for processing',
        uploadedAt: '2023-10-24',
      ),
      PrescriptionModel(
        id: 5,
        userId: 105,
        userName: 'Linda Kim',
        imagePath: 'assets/rx-image-5.jpg',
        status: 'rejected',
        notes: 'Expired prescription',
        uploadedAt: '2023-12-24',
      ),
    ]);
  }

  /// Get prescription order details by ID
  Future<PrescriptionModel?> getPrescriptionOrderById(
    int prescriptionId,
  ) async {
    try {
      isLoading.value = true;
      log('Fetching prescription details for ID: $prescriptionId...');

      final prescription = await prescriptionService.getPrescriptionOrderById(
        prescriptionId,
      );

      if (prescription != null) {
        log('✅ Prescription details fetched successfully');
        // Update the prescription in the list or add it if not exists
        final index = prescriptions.indexWhere((p) => p.id == prescriptionId);
        if (index >= 0) {
          prescriptions[index] = prescription;
        } else {
          prescriptions.add(prescription);
        }
        // Trigger UI rebuild
        update();
        return prescription;
      } else {
        log('❌ Failed to fetch prescription details');
        return null;
      }
    } catch (e) {
      log('❌ Error fetching prescription: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Change prescription status
  /// Different rules for different status changes
  Future<void> changePrescriptionStatus(
    int prescriptionId,
    String newStatus,
    int userId,
  ) async {
    try {
      isLoading.value = true;
      log('Changing prescription status to $newStatus...');

      final success = await prescriptionService.changePrescriptionStatus(
        prescriptionId,
        newStatus,
        userId,
      );

      if (success) {
        log('✅ Status changed successfully');
        // Update the prescription in the list
        final index = prescriptions.indexWhere((p) => p.id == prescriptionId);
        if (index != -1) {
          prescriptions[index].status = newStatus;
          prescriptions.refresh();
        }
        Get.snackbar(
          'Success',
          'Prescription status updated to $newStatus',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        log('❌ Failed to change status');
        Get.snackbar(
          'Error',
          'Failed to update prescription status',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      log('❌ Error changing prescription status: $e');
      Get.snackbar(
        'Error',
        'An error occurred while updating status',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Submit vendor response with medicines and notes
  /// Only available if prescription status is valid
  Future<bool> submitVendorResponse({
    required int prescriptionId,
    required List<Map<String, dynamic>> medicines,
    required String prescriptionNotes,
  }) async {
    try {
      isLoading.value = true;
      log('Submitting vendor response for prescription $prescriptionId...');

      final success = await prescriptionService.submitVendorResponse(
        prescriptionId: prescriptionId,
        medicines: medicines,
        prescriptionNotes: prescriptionNotes,
      );

      if (success) {
        log('✅ Vendor response submitted successfully');
        Get.snackbar(
          'Success',
          'Your response has been sent to the customer',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      } else {
        log('❌ Failed to submit vendor response');
        Get.snackbar(
          'Error',
          'Failed to submit your response',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      log('❌ Error submitting vendor response: $e');
      Get.snackbar(
        'Error',
        'An error occurred while submitting your response',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
