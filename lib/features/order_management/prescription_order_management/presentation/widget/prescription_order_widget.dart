import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';

class PrescriptionOrdersWidget extends StatelessWidget {
  final int pendingCount;
  final VoidCallback? onTap;

  const PrescriptionOrdersWidget({Key? key, this.pendingCount = 5, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.beakYellow.withValues(alpha: 0.2),

          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.beakYellow.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
              child: Stack(
                children: [
                  // Document icon
                  Positioned(
                    top: 2,
                    left: 8,
                    right: 8,
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: AppColors.beakYellow.withValues(alpha: 0.9),
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            height: 2,
                            width: 20,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 2),
                          Container(height: 2, width: 16, color: Colors.black),
                          const SizedBox(height: 2),
                          Container(height: 2, width: 20, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                  // Medicine bottle
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: 24,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            width: 12,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black),
                            ),
                            child: Center(
                              child: Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Prescription Orders',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Review pending requests.',
                    style: TextStyle(fontSize: 14.sp, color: Colors.black),
                  ),
                ],
              ),
            ),
            // Badge and Arrow
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(12),
                //   ),
                //   child: Text(
                //     '$pendingCount New',
                //     style: TextStyle(
                //       fontSize: 13,
                //       fontWeight: FontWeight.w600,
                //       color: Colors.black87,
                //     ),
                //   ),
                // ),
                const SizedBox(height: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.ebonyBlack,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
