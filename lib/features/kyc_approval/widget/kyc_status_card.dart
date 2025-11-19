import 'package:flutter/material.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_button.dart';

class StatusCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String? buttonText;
  final VoidCallback? onButtonTap;

  const StatusCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.buttonText,
    this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 70, color: color),
          const SizedBox(height: 20),
          Text(
            title,
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: getTextStyle(fontSize: 14, color: Colors.black54),
          ),
          if (buttonText != null && onButtonTap != null) ...[
            const SizedBox(height: 28),
            CustomButton(
              text: buttonText!,
              onPressed: onButtonTap!,
              height: 48,
              width: 200,
              borderRadius: 10,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 15,
            ),
          ],
        ],
      ),
    );
  }
}
