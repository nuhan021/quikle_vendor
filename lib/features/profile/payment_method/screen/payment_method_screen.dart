import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/common/widgets/custom_button.dart';
import 'package:quikle_vendor/features/appbar/screen/appbar_screen.dart';
import '../controller/payment_method_controller.dart';
import '../widget/payment_method_item.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaymentMethodController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: const AppbarScreen(title: "Payment Method"),
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// Payment Method List
              ...List.generate(controller.methods.length, (index) {
                final method = controller.methods[index];
                return PaymentMethodItem(
                  iconPath: method["icon"]!,
                  name: method["name"]!,
                  onDelete: () => controller.deleteMethod(index),
                );
              }),

              /// Spacing after last payment method
              const SizedBox(height: 30),

              /// Add New Payment Method Button
              CustomButton(
                text: "Add New Payment Method",
                onPressed: () {
                  // Example: Add PayPal
                  controller.addMethod("assets/icons/paypal.png", "PayPal");
                },
                height: 48,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 15,
                borderRadius: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
