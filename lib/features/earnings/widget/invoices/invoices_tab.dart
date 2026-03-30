import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../controller/invoice_controller.dart';
import 'invoice_card.dart';

class InvoicesTab extends StatelessWidget {
  const InvoicesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InvoiceController());

    return Obx(() {
      if (controller.invoices.isEmpty) {
        return Center(
          child: Text(
            'No invoices found.',
            style: getTextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: controller.invoices.length,
        itemBuilder: (context, index) {
          final invoice = controller.invoices[index];
          return InvoiceCard(
            invoiceId: invoice["invoiceId"],
            orderId: invoice["orderId"],
            amount: invoice["amount"],
            customer: invoice["customer"],
            date: invoice["date"],
            time: invoice["time"],
            status: invoice["status"],
            tags: List<String>.from(invoice["tags"]),
          );
        },
      );
    });
  }
}
