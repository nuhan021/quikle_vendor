import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../controller/vendor_selection_controller.dart';
import '../widget/vendor_card.dart';

class VendorSelectionScreen extends StatelessWidget {
  const VendorSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VendorSelectionController());
    // Check if coming from profile
    final fromProfile = Get.arguments?['fromProfile'] == true;

    return Scaffold(
      appBar: fromProfile
          ? AppBar(
              title: Text(
                "Select Vendor Type",
                style: getTextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              centerTitle: false,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Get.back(),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            )
          : null,
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
                    isSelected: controller.selectedVendor.value == "food",
                    onTap: () => controller.selectVendor("food"),
                  ),

                  /// Medicine Vendor
                  VendorCard(
                    title: "Medicine Vendor",
                    isSelected: controller.selectedVendor.value == "medicine",
                    onTap: () => controller.selectVendor("medicine"),
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
