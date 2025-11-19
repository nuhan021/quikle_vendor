import 'package:flutter/material.dart';
import '../../../../core/common/styles/global_text_style.dart';

class OrderDetailsCustomerInfoWidget extends StatelessWidget {
  final String name;
  final String deliveryTime;
  final String address;

  const OrderDetailsCustomerInfoWidget({
    super.key,
    required this.name,
    required this.deliveryTime,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    Widget infoRow(IconData icon, String text) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Color(0xFF111827),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 12),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: getTextStyle(
                  fontSize: 16,
                  color: const Color(0xFF111827),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Information',
            style: getTextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 16),
          infoRow(Icons.person, name),
          infoRow(Icons.access_time, deliveryTime),
          infoRow(Icons.location_on, address),
        ],
      ),
    );
  }
}
