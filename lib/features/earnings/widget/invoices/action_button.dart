import 'package:flutter/material.dart';
import '../../../../core/common/styles/global_text_style.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double borderRadius;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color iconColor;
  final EdgeInsetsGeometry padding;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.borderRadius = 8,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.black12,
    this.textColor = Colors.black,
    this.iconColor = Colors.black,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: getTextStyle(
                fontSize: 13,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 6),
            Icon(icon, size: 16, color: iconColor),
          ],
        ),
      ),
    );
  }
}
