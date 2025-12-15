import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrescriptionImageCard extends StatelessWidget {
  final String? imagePath;

  const PrescriptionImageCard({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        imagePath ?? 'https://via.placeholder.com/300x400?text=No+Image';

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 3 / 4,
            child: Ink.image(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
              child: InkWell(onTap: () {}),
            ),
          ),
        ],
      ),
    );
  }
}
