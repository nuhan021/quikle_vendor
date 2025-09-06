import 'package:flutter/material.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';

class AppbarScreen extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppbarScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      centerTitle: false,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        side: BorderSide(
          color: AppColors.primary, // yellow line
          width: 1,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
