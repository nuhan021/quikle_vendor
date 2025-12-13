import 'package:flutter/material.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';

import '../../../core/common/styles/global_text_style.dart';

class PendingActionCardWidget extends StatelessWidget {
  final String title;
  final Widget? subtitleWidget; // New: accepts a widget
  final String? subtitle; // Keep for backward compatibility
  final String buttonText;
  final Color buttonColor;
  final VoidCallback onTap;

  const PendingActionCardWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.subtitleWidget,
    required this.buttonText,
    required this.buttonColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 8),
                subtitleWidget ??
                    Text(
                      subtitle ?? '',
                      style: getTextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                buttonText,
                style: getTextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
