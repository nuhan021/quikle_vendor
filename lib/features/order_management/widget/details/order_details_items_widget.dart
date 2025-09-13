import 'package:flutter/material.dart';

import '../../../../core/common/styles/global_text_style.dart';

class OrderDetailsItemsWidget extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const OrderDetailsItemsWidget({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    final items = orderData['items'] as List<Map<String, dynamic>>;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Items',
            style: getTextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          SizedBox(height: 16),

          // Items List
          ...items
              .map(
                (item) => Container(
                  margin: EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      // Item Image
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item['image'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Color(0xFFF3F4F6),
                                child: Image.asset(
                                  item['image'],
                                  height: 24,
                                  width: 24,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 16),

                      // Item Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              style: getTextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF111827),
                              ),
                            ),
                            if (item['description'] != null) ...[
                              SizedBox(height: 4),
                              Text(
                                item['description'],
                                style: getTextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Price
                      Text(
                        '\$${item['price'].toStringAsFixed(2)}',
                        style: getTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),

          // Divider
          Container(
            height: 1,
            color: Color(0xFFE5E7EB),
            margin: EdgeInsets.symmetric(vertical: 16),
          ),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: getTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              Text(
                '\$${orderData['total'].toStringAsFixed(2)}',
                style: getTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Special Instructions
          Text(
            'Special Instructions',
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          SizedBox(height: 8),
          Text(
            orderData['specialInstructions'],
            style: getTextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }
}
