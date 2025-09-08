import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../appbar/screen/appbar_screen.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../controller/help_and_support_controller.dart';

class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HelpAndSupportController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: const AppbarScreen(title: "Help & Support"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// --- Report Form ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Report an Issue",
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    /// Subject Dropdown
                    Text(
                      "Subject",
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: controller.selectedSubject.value.isEmpty
                          ? null
                          : controller.selectedSubject.value,
                      items: controller.subjects
                          .map(
                            (s) => DropdownMenuItem(value: s, child: Text(s)),
                          )
                          .toList(),
                      decoration: InputDecoration(
                        hintText: "Select an issue type",
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (val) {
                        if (val != null) controller.setSubject(val);
                      },
                    ),
                    const SizedBox(height: 12),

                    /// Description
                    Text(
                      "Description",
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Please describe your issue in detail...",
                        contentPadding: const EdgeInsets.all(12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: controller.setDescription,
                    ),
                    const SizedBox(height: 12),

                    /// Attachment
                    Text(
                      "Attachment (Optional)",
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () {
                        // TODO: File picker integration
                        controller.setAttachment("demo_screenshot.png");
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              IconPath.upload,
                              width: 28,
                              height: 28,
                              colorFilter: const ColorFilter.mode(
                                Colors.black54,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              controller.attachmentPath.isEmpty
                                  ? "Upload a screenshot or photo"
                                  : controller.attachmentPath.value,
                              style: getTextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    /// Submit Button
                    CustomButton(
                      text: "Submit Issue",
                      onPressed: controller.submitIssue,
                      height: 48,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 15,
                      borderRadius: 8,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// --- Support History ---
              Text(
                "Recent Support History",
                style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              for (final item in controller.supportHistory)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["title"]!,
                        style: getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item["subtitle"]!,
                        style: getTextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
