import 'package:flutter/material.dart';

import '../../../core/common/styles/global_text_style.dart';

class OrderStatusBadgeWidget extends StatelessWidget {
  final String tag;
  final bool isUrgent;
  final bool isPrescription;

  const OrderStatusBadgeWidget({
    super.key,
    required this.tag,
    this.isUrgent = false,
    this.isPrescription = false,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    Color borderColor;

    if (isUrgent || isPrescription) {
      backgroundColor = Color(0xFFFEF2F2);
      textColor = Color(0xFFDC2626);
      borderColor = Color(0xFFFECACA);
    } else {
      backgroundColor = Color(0xFFF3F4F6);
      textColor = Color(0xFF374151);
      borderColor = Color(0xFFE5E7EB);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Text(
        tag,
        style: getTextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}
