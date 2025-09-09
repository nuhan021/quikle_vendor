import 'package:flutter/material.dart';
import 'package:quikle_vendor/core/common/styles/global_text_style.dart';
import '../controller/home_controller.dart';

class DashboardCardWidget extends StatelessWidget {
  final String title;
  final String image;
  final HomeController controller;

  const DashboardCardWidget({
    super.key,
    required this.title,
    required this.image,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.navigateDashboard(title),
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(image),
              SizedBox(height: 6),
              Text(
                title,
                style: getTextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
