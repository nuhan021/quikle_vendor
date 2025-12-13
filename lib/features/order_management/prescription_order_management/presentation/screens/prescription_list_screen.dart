import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/features/order_management/prescription_order_management/controller/prescription_controller.dart';
import 'package:quikle_vendor/features/order_management/prescription_order_management/presentation/widget/prescription_card_widget.dart';
import '../../../../appbar/screen/appbar_screen.dart';

class PrescriptionListScreen extends StatelessWidget {
  const PrescriptionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PrescriptionController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F8),
      appBar: const AppbarScreen(title: "Prescriptions"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Obx(() {
          if (controller.prescriptions.isEmpty) {
            return const Center(child: Text("No prescriptions found"));
          }
          return ListView.separated(
            itemCount: controller.prescriptions.length,
            separatorBuilder: (_, __) => SizedBox(height: 10.h),
            itemBuilder: (context, index) {
              final item = controller.prescriptions[index];
              return PrescriptionCardWidget(item: item);
            },
          );
        }),
      ),
    );
  }
}
