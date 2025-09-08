import 'package:flutter/material.dart';

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
    return Card(
      color: Colors.white,
      elevation: 2, // Fixed elevation for a consistent card look
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ), // Adjusted margin for spacing
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 20,
        ), // Adjusted padding for better content spacing
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(image),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
