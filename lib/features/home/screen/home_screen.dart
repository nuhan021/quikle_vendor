import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/features/appbar/screen/appbar_screen.dart';
import '../controller/home_controller.dart';
import '../widget/store_info_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: Color(0xFF),
      appBar: AppbarScreen(title: 'Home'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            /// Store Info Section
            StoreInfoWidget(),

            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
