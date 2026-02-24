import 'package:get/get.dart';
import '../model/support_history_model.dart';

class HelpAndSupportController extends GetxController {
  var selectedSubject = "".obs;
  var description = "".obs;
  var attachmentPath = "".obs;

  var supportHistory = <SupportHistoryModel>[].obs;

  final subjects = ["Order Issue", "Payment Problem", "App Bug", "Other"];

  @override
  void onInit() {
    super.onInit();

    /// TODO: Replace with API call -> fetch support history from backend
    supportHistory.addAll([
      SupportHistoryModel(
        title: "Order #12345 Issue",
        subtitle: "Submitted on May 15, 2023",
      ),
      SupportHistoryModel(
        title: "Payment Method Update",
        subtitle: "Submitted on June 2, 2023",
      ),
    ]);
  }

  void setSubject(String value) => selectedSubject.value = value;
  void setDescription(String value) => description.value = value;
  void setAttachment(String path) {
    attachmentPath.value = path;
    // TODO: Handle file upload to server if required
  }

  void submitIssue() {
    if (selectedSubject.isEmpty || description.isEmpty) {
      return;
    }

    /// TODO: Send submitted issue to API
    supportHistory.insert(
      0,
      SupportHistoryModel(
        title: selectedSubject.value,
        subtitle:
            "Submitted on ${DateTime.now().toLocal().toString().split('.')[0]}",
      ),
    );

    selectedSubject.value = "";
    description.value = "";
    attachmentPath.value = "";
  }
}
