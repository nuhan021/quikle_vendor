import 'package:flutter/material.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';

import '../../../core/common/styles/global_text_style.dart';

class RecentOrderCardWidget extends StatelessWidget {
  final String customer;
  final String items;
  final String amount;
  final String time;
  final String status;
  final Color statusColor;

  const RecentOrderCardWidget({
    super.key,
    required this.customer,
    required this.items,
    required this.amount,
    required this.time,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                customer,
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$items • $amount',
                style: getTextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),
              Text(
                time,
                style: getTextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
