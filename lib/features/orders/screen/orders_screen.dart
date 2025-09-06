import 'package:flutter/material.dart';
import 'package:quikle_vendor/features/appbar/screen/appbar_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarScreen(title: 'Orders Management'),
      body: Center(child: Text('All Orders')),
    );
  }
}
