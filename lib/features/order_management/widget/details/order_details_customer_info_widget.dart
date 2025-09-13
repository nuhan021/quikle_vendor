import 'package:flutter/material.dart';

import '../../../../core/common/styles/global_text_style.dart';

class OrderDetailsCustomerInfoWidget extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const OrderDetailsCustomerInfoWidget({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Information',
            style: getTextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          SizedBox(height: 16),

          // Customer Name
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Color(0xFF111827),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, color: Colors.white, size: 12),
              ),
              SizedBox(width: 12),
              Text(
                orderData['customerName'],
                style: getTextStyle(fontSize: 16, color: Color(0xFF111827)),
              ),
            ],
          ),
          SizedBox(height: 12),

          // Delivery Time
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Color(0xFF111827),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.access_time, color: Colors.white, size: 12),
              ),
              SizedBox(width: 12),
              Text(
                orderData['deliveryTime'],
                style: getTextStyle(fontSize: 16, color: Color(0xFF111827)),
              ),
            ],
          ),
          SizedBox(height: 12),

          // Address
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Color(0xFF111827),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.location_on, color: Colors.white, size: 12),
              ),
              SizedBox(width: 12),
              Text(
                orderData['address'],
                style: getTextStyle(fontSize: 16, color: Color(0xFF111827)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
