import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/invoice_controller.dart';
import 'invoice_card.dart';

class InvoicesTab extends StatelessWidget {
  const InvoicesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InvoiceController());

    return Obx(
      () => ListView.builder(
        padding: const EdgeInsets.only(bottom: 16),
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
      ),
    );
  }
}
