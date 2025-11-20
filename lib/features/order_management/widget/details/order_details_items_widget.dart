import 'package:flutter/material.dart';
import '../../../../core/common/styles/global_text_style.dart';

class OrderDetailsItemsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final double total;
  final String specialInstructions;

  const OrderDetailsItemsWidget({
    super.key,
    required this.items,
    required this.total,
    required this.specialInstructions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Items',
            style: getTextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 16),

          /// 🔹 Items list
          ...items.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  // Image
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item['image'],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Center(
                          child: Icon(Icons.image_not_supported, size: 24),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'],
                          style: getTextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF111827),
                          ),
                        ),
                        if (item['description'] != null &&
                            item['description'].toString().isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            item['description'],
                            style: getTextStyle(
                              fontSize: 14,
                              color: const Color(0xFF6B7280),
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
                      color: const Color(0xFF111827),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          const Divider(color: Color(0xFFE5E7EB), height: 32),

          /// 🔹 Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: getTextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: getTextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// 🔹 Special Instructions
          Text(
            'Special Instructions',
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0x1AB8B8B8),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              specialInstructions,
              style: getTextStyle(fontSize: 14, color: const Color(0xFF6B7280)),
            ),
          ),
        ],
      ),
    );
  }
}
