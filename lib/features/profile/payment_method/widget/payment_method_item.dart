import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/common/styles/global_text_style.dart';

class PaymentMethodItem extends StatelessWidget {
  final String iconPath;
  final String name;
  final VoidCallback? onDelete;

  const PaymentMethodItem({
    super.key,
    required this.iconPath,
    required this.name,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          /// Logo (always 24x24)
          iconPath.endsWith(".svg")
              ? SvgPicture.asset(iconPath, width: 24, height: 24)
              : Image.asset(iconPath, width: 24, height: 24),

          const SizedBox(width: 12),

          /// Name
          Expanded(
            child: Text(
              name,
              style: getTextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),

          /// Delete button (24x24 for consistency)
          if (onDelete != null)
            GestureDetector(
              onTap: onDelete,
              child: const SizedBox(
                width: 24,
                height: 24,
                child: Icon(Icons.close, color: Colors.red, size: 24),
              ),
            ),
        ],
      ),
    );
  }
}
