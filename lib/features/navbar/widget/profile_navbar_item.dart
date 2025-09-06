import 'package:flutter/material.dart';
import '../../../core/utils/constants/colors.dart';

class ProfileNavbarItem extends StatelessWidget {
  final String imagePath;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const ProfileNavbarItem({
    super.key,
    required this.imagePath,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 14, backgroundImage: AssetImage(imagePath)),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.primary : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
