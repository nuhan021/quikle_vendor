import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../controller/vendor_selection_controller.dart';
import '../widget/vendor_card.dart';

class VendorSelectionScreen extends StatelessWidget {
  const VendorSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VendorSelectionController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Food Vendor
                  VendorCard(
                    title: "Food Vendor",
                    isSelected:
                        controller.selectedVendor.value == "Food Vendor",
                    onTap: () => controller.selectVendor("Food Vendor"),
                  ),

                  /// Medicine Vendor
                  VendorCard(
                    title: "Medicine Vendor",
                    isSelected:
                        controller.selectedVendor.value == "Medicine Vendor",
                    onTap: () => controller.selectVendor("Medicine Vendor"),
                  ),

                  const SizedBox(height: 40),

                  /// Submit Button
                  CustomButton(
                    text: "Submit",
                    onPressed: controller.submitSelection,
                    height: 48,
                    borderRadius: 10,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
