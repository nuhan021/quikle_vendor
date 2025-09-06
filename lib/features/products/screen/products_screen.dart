import 'package:flutter/material.dart';
import 'package:quikle_vendor/features/appbar/screen/appbar_screen.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarScreen(title: 'Products'),
      body: Center(child: Text('Products')),
    );
  }
}
