import 'package:flutter/material.dart';

import '../../../core/common/styles/global_text_style.dart';

class OrderStatusBadgeWidget extends StatelessWidget {
  final String tag;
  final String status;

  const OrderStatusBadgeWidget({
    super.key,
    required this.tag,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    Color borderColor;

    if (tag == 'Urgent' || tag == 'Prescription Required') {
      backgroundColor = Color(0xFFFEF2F2);
      textColor = Color(0xFFDC2626);
      borderColor = Color(0xFFFECACA);
    } else if (tag == 'Accepted') {
      backgroundColor = Color(0xFFD1FAE5);
      textColor = Color(0xFF065F46);
      borderColor = Color(0xFFA7F3D0);
    } else if (tag == 'In Progress') {
      backgroundColor = Color(0xFFFED7AA);
      textColor = Color(0xFF9A3412);
      borderColor = Color(0xFFFBBF24);
    } else if (tag == 'Completed') {
      backgroundColor = Color(0xFFF3F4F6);
      textColor = Color(0xFF374151);
      borderColor = Color(0xFFE5E7EB);
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
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}
