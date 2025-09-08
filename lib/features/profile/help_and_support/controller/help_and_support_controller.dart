import 'package:get/get.dart';

class HelpAndSupportController extends GetxController {
  /// Form fields
  var selectedSubject = "".obs;
  var description = "".obs;
  var attachmentPath = "".obs;

  /// Support history
  var supportHistory = <Map<String, String>>[].obs;

  /// Available issue subjects (will come from API later)
  final subjects = ["Order Issue", "Payment Problem", "App Bug", "Other"];

  /// Pick subject
  void setSubject(String value) {
    selectedSubject.value = value;
  }

  /// Update description
  void setDescription(String value) {
    description.value = value;
  }

  /// Upload attachment
  void setAttachment(String path) {
    attachmentPath.value = path;
  }

  /// Submit issue
  void submitIssue() {
    if (selectedSubject.isEmpty || description.isEmpty) {
      Get.snackbar("Error", "Please fill all required fields");
      return;
    }

    // TODO: send data to API
    supportHistory.insert(0, {
      "title": selectedSubject.value,
      "subtitle": "Submitted on ${DateTime.now().toLocal()}",
    });

    // Reset form
    selectedSubject.value = "";
    description.value = "";
    attachmentPath.value = "";

    Get.snackbar("Success", "Your issue has been submitted!");
  }
}
