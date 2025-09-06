import 'package:flutter/material.dart';
import 'package:quikle_vendor/features/appbar/screen/appbar_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarScreen(title: 'Home'),
      body: Center(child: Text('Home screen')),
    );
  }
}
