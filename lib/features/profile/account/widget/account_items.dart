import 'package:flutter/material.dart';
import '../../../../core/common/styles/global_text_style.dart';

class AccountItems extends StatelessWidget {
  final List<Map<String, Object>> items;
  final double iconSize;

  const AccountItems({super.key, required this.items, this.iconSize = 24});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          return Column(
            children: [
              ListTile(
                leading: SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: item['icon'] as Widget,
                ),
                title: Text(
                  item['text'] as String,
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: item['textColor'] as Color? ?? Colors.black87,
                  ),
                ),
                onTap: item['onTap'] as VoidCallback?,
              ),
              if (index != items.length - 1)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Divider(height: 1, thickness: 0.8),
                ),
            ],
          );
        }),
      ),
    );
  }
}
