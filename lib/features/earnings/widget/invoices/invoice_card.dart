import 'package:flutter/material.dart';
import 'package:quikle_vendor/features/earnings/widget/invoices/action_button.dart';
import '../../../../core/common/styles/global_text_style.dart';

class InvoiceCard extends StatelessWidget {
  final String invoiceId, orderId, amount, customer, date, time, status;
  final List<String> tags;

  const InvoiceCard({
    super.key,
    required this.invoiceId,
    required this.orderId,
    required this.amount,
    required this.customer,
    required this.date,
    required this.time,
    required this.status,
    required this.tags,
  });

  bool get isPaid => status == "Paid";
  bool get isPending => status == "Pending";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Row 1: Invoice ID + Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                invoiceId,
                style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                amount,
                style: getTextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),

          /// Row 2: Order ID + Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order: $orderId",
                style: getTextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                time,
                style: getTextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          /// Row 3: Customer Name
          Text(
            customer,
            style: getTextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),

          /// Row 4: Status + Tags + Generated Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  /// Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isPaid
                          ? Colors.green.withValues(alpha: .2)
                          : Colors.transparent,
                      border: isPending
                          ? Border.all(color: Colors.orange, width: 1)
                          : null,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      status,
                      style: getTextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),

                  /// Tags
                  for (final tag in tags)
                    Container(
                      margin: const EdgeInsets.only(left: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: .2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        tag,
                        style: getTextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              Text(
                "Generated: $date",
                style: getTextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          /// Row 5: Action Buttons
          Row(
            children: [
              ActionButton(
                label: "Download",
                icon: Icons.download,
                onTap: () {
                  // TODO: download action
                },
              ),
              const SizedBox(width: 8),
              ActionButton(
                label: "View",
                icon: Icons.visibility,
                onTap: () {
                  // TODO: view action
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
