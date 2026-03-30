import 'package:flutter/material.dart';
import 'package:quikle_vendor/features/earnings/widget/invoices/action_button.dart';
import '../../../../core/common/styles/global_text_style.dart';

class InvoiceCard extends StatelessWidget {
  final String invoiceId;
  final String orderId;
  final String amount;
  final String customer;
  final String date;
  final String time;
  final String status;
  final List<String> tags;
  final VoidCallback onDownload;
  final VoidCallback onView;

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
    required this.onDownload,
    required this.onView,
  });

  String get normalizedStatus =>
      status.toLowerCase().replaceAll(' ', '').replaceAll('-', '');

  bool get isCompleted =>
      const {'paid', 'completed', 'delivered'}.contains(normalizedStatus);

  bool get isPending => const {
    'pending',
    'processing',
    'confirmed',
    'shipped',
    'prepared',
    'outfordelivery',
  }.contains(normalizedStatus);

  bool get isCancelled =>
      const {'cancelled', 'refunded'}.contains(normalizedStatus);

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  invoiceId,
                  overflow: TextOverflow.ellipsis,
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                amount,
                style: getTextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: Text(
                  "Order: $orderId",
                  overflow: TextOverflow.ellipsis,
                  style: getTextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(width: 12),
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

          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? Colors.green.withValues(alpha: .2)
                            : isCancelled
                            ? Colors.red.withValues(alpha: .12)
                            : Colors.transparent,
                        border: isPending
                            ? Border.all(color: Colors.orange, width: 1)
                            : isCancelled
                            ? Border.all(color: Colors.red, width: 1)
                            : !isCompleted
                            ? Border.all(color: Colors.black12, width: 1)
                            : null,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        status,
                        style: getTextStyle(
                          color: isPending
                              ? Colors.orange
                              : isCancelled
                              ? Colors.red
                              : Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    for (final tag in tags)
                      Container(
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
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Generated: $date",
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  style: getTextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                  ),
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
                onTap: onDownload,
              ),
              const SizedBox(width: 8),
              ActionButton(
                label: "View",
                icon: Icons.visibility,
                onTap: onView,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
