import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                  VendorCard(
                    title: "Food Vendor",
                    isSelected: controller.selectedVendor.value == "food",
                    onTap: () => controller.selectVendor("food"),
                  ),

                  VendorCard(
                    title: "Medicine Vendor",
                    isSelected: controller.selectedVendor.value == "medicine",
                    onTap: () => controller.selectVendor("medicine"),
                  ),

                  const SizedBox(height: 40),

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
