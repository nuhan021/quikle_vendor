import 'package:flutter/material.dart';

import '../../../core/common/styles/global_text_style.dart';

class ProductsHeaderWidget extends StatelessWidget {
  ProductsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFFBBF24), width: 3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Products',
            style: getTextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          Icon(
            Icons.notifications_outlined,
            size: 24,
            color: Color(0xFF374151),
          ),
        ],
      ),
    );
  }
}
