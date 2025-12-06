import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../controller/overview_controller.dart';
import 'stat_card.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OverviewController());

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header Row (Title + Dropdown)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Earnings Overview",
                style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Obx(
                () => GestureDetector(
                  onTap: () {}, // Dropdown handled by DropdownButton
                  child: Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black12, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: controller.selectedRange.value,
                        icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                        dropdownColor: Colors.white,
                        style: getTextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        items: controller.ranges
                            .map(
                              (range) => DropdownMenuItem(
                                value: range,
                                child: Text(
                                  range,
                                  style: getTextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) controller.changeRange(value);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          /// Earnings Card
          Obx(
            () => Container(
              height: 172,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.black, Color(0xFF333333)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "\$ Total Earnings",
                    style: getTextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "\$${controller.totalEarnings.value.toStringAsFixed(2)}",
                    style: getTextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Net \$${controller.netEarnings.value.toStringAsFixed(2)}",
                    style: getTextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          /// Stats Grid
          Obx(
            () => GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.0,
              children: [
                StatCard(
                  "Payment Received",
                  "\$${controller.paymentReceived.value.toStringAsFixed(2)}",
                  "${controller.ordersCount.value} orders",
                ),
                StatCard(
                  "Pending",
                  "\$${controller.pending.value.toStringAsFixed(2)}",
                  "Processing",
                ),
                StatCard(
                  "Commission",
                  "\$${controller.commission.value.toStringAsFixed(2)}",
                  "Platform fee",
                ),
                StatCard(
                  "Avg Order",
                  "\$${controller.avgOrder.value.toStringAsFixed(2)}",
                  "Per order",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
