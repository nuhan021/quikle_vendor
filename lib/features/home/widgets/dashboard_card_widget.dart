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
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(image),
            const SizedBox(height: 6),
            FittedBox(
              child: Text(
                title,
                style: getTextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
