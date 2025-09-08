import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import '../../../core/common/styles/global_text_style.dart';
import '../../appbar/screen/appbar_screen.dart';
import '../controller/earnings_controller.dart';
import '../widget/invoices/invoices_tab.dart';
import '../widget/overview/overview_tab.dart';
import '../widget/payments/payments_tab.dart';
import '../widget/payouts/payouts_tab.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EarningsController());

    final tabWidgets = [
      OverviewTab(),
      PaymentsTab(),
      InvoicesTab(),
      PayoutsTab(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppbarScreen(title: "Earnings"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Tab Buttons
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(controller.tabs.length, (i) {
                  final isSelected = controller.selectedTab.value == i;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: GestureDetector(
                        onTap: () => controller.changeTab(i),
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.black : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Text(
                            controller.tabs[i],
                            style: getTextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),

            /// Tab Content
            Expanded(
              child: Obx(() => tabWidgets[controller.selectedTab.value]),
            ),
          ],
        ),
      ),
    );
  }
}
