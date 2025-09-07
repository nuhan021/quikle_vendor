import 'package:flutter/material.dart';

import 'transaction_card.dart';

class PaymentsTab extends StatelessWidget {
  const PaymentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Recent Transactions",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            OutlinedButton.icon(
              onPressed: () {
                // TODO: export logic
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                side: const BorderSide(color: Colors.black12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.download, size: 18, color: Colors.black),
              label: const Text(
                "Export",
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        /// Transactions List
        Expanded(
          child: ListView(
            children: const [
              TransactionCard(
                orderId: "ORD-FD-001",
                amount: "\$47.40",
                status: "Received",
                time: "10 minutes ago",
                customer: "Anaya Desai",
                tags: ["Food"],
              ),
              TransactionCard(
                orderId: "ORD-GR-087",
                amount: "\$47.40",
                status: "Pending",
                time: "10 minutes ago",
                customer: "Anaya Desai",
                tags: ["Food"],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
