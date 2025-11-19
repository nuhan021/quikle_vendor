import 'package:flutter/material.dart';
import '../../../../core/common/styles/global_text_style.dart';

class VendorCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const VendorCard({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 0),
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 28),
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.black,
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Join As",
              style: getTextStyle(
                fontSize: 15,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: getTextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            if (isSelected)
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Icon(Icons.check_circle, color: Colors.white, size: 22),
              ),
          ],
        ),
      ),
    );
  }
}
