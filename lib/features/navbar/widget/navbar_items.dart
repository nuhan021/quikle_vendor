import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';

class NavbarItems extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const NavbarItems({
    super.key,
    required this.iconPath,
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
          SvgPicture.asset(
            iconPath,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              selected ? AppColors.primary : Colors.white,
              BlendMode.srcIn,
            ),
          ),
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
