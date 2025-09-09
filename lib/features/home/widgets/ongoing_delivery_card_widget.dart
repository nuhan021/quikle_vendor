import 'package:flutter/material.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';

import '../../../core/common/styles/global_text_style.dart';

class OngoingDeliveryCardWidget extends StatelessWidget {
  final String orderId;
  final String status;

  const OngoingDeliveryCardWidget({
    super.key,
    required this.orderId,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  orderId,
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),

                child: Text(
                  status,
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.backgroundDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18), // Space between status and progress bar
          // Progress bar below status
          LinearProgressIndicator(
            value: 0.5, // Adjust based on status (e.g., 0.5 for "On the Way")
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color(0xFFF59E0B),
            ), // Yellow progress
            minHeight: 4, // Thin line-like bar
          ),
        ],
      ),
    );
  }
}
