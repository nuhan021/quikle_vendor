import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/constants/icon_path.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../controller/payments_controller.dart';
import 'transaction_card.dart';

class PaymentsTab extends StatelessWidget {
  const PaymentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaymentsController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recent Transactions",
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: Implement export functionality
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black12, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Export",
                      style: getTextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset(IconPath.export, width: 14, height: 14),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        /// Transactions List (reactive)
        Expanded(
          child: Obx(
            () => ListView.builder(
              itemCount: controller.transactions.length,
              itemBuilder: (context, index) {
                final tx = controller.transactions[index];
                return TransactionCard(
                  orderId: tx["orderId"],
                  amount: tx["amount"],
                  status: tx["status"],
                  time: tx["time"],
                  customer: tx["customer"],
                  delivery: tx["delivery"],
                  tags: List<String>.from(tx["tags"]),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
