import 'package:flutter/material.dart';

import 'invoice_card.dart' show InvoiceCard;

class InvoicesTab extends StatelessWidget {
  const InvoicesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 16),
      children: const [
        InvoiceCard(
          invoiceId: "INV-2024-001",
          orderId: "ORD-ED-OO1",
          amount: "\$47.40",
          customer: "Anaya Desai",
          date: "Jan 15, 2024",
          time: "10 minutes ago",
          status: "Paid",
          tags: ["Food"],
        ),
        InvoiceCard(
          invoiceId: "INV-2024-002",
          orderId: "ORD-ED-OO2",
          amount: "\$47.40",
          customer: "Anaya Desai",
          date: "Jan 15, 2024",
          time: "10 minutes ago",
          status: "Paid",
          tags: ["Food"],
        ),
      ],
    );
  }
}
