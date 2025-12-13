import 'package:get/get.dart';
import 'package:quikle_vendor/features/order_management/prescription_order_management/models/prescription_model.dart';

class PrescriptionController extends GetxController {
  final prescriptions = <Prescription>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPrescriptions();
  }

  void loadPrescriptions() {
    // Mock data for now - can be replaced with API call
    prescriptions.assignAll([
      Prescription(
        id: 1,
        userId: 101,
        userName: 'Sarah Jenkins',
        imagePath: 'assets/rx-image-1.jpg',
        status: 'pending',
        notes: 'Waiting for pharmacy review',
        uploadedAt: '2023-10-28',
      ),
      Prescription(
        id: 2,
        userId: 102,
        userName: 'David Chen',
        imagePath: 'assets/rx-image-2.jpg',
        status: 'approved',
        notes: 'Approved and ready for fulfillment',
        uploadedAt: '2023-10-25',
      ),
      Prescription(
        id: 3,
        userId: 103,
        userName: 'Maria Rodriguez',
        imagePath: 'assets/rx-image-3.jpg',
        status: 'clarification',
        notes: 'Needs clarification on dosage',
        uploadedAt: '2023-10-25',
      ),
      Prescription(
        id: 4,
        userId: 104,
        userName: 'James Smith',
        imagePath: 'assets/rx-image-4.jpg',
        status: 'approved',
        notes: 'Ready for processing',
        uploadedAt: '2023-10-24',
      ),
      Prescription(
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
}
