import 'package:get/get.dart';

class KycApprovalController extends GetxController {
  /// -------------------- Observables --------------------
  var kycStatus = "approved".obs;

  /// -------------------- Mock Fetch from API --------------------
  Future<void> fetchKycStatus() async {
    // TODO: Replace with real API call later
    await Future.delayed(const Duration(milliseconds: 800));
    kycStatus.value = "approved"; // mock status
  }

  /// -------------------- Simulate Approval for visualization --------------------
  Future<void> simulateApprovalFlow() async {
    kycStatus.value = "pending";
    await Future.delayed(const Duration(seconds: 3));
    kycStatus.value = "approved";
  }
}
