import 'package:flutter/material.dart';
import 'order_details_header_widget.dart';
import 'order_details_customer_info_widget.dart';
import 'order_details_items_widget.dart';
import 'order_details_actions_widget.dart';

class OrderDetailsContentWidget extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const OrderDetailsContentWidget({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrderDetailsHeaderWidget(orderData: orderData),
          SizedBox(height: 24),
          OrderDetailsCustomerInfoWidget(orderData: orderData),
          SizedBox(height: 24),
          OrderDetailsItemsWidget(orderData: orderData),
          SizedBox(height: 24),
          OrderDetailsActionsWidget(orderData: orderData),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
