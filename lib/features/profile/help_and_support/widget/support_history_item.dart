import 'package:flutter/material.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../model/support_history_model.dart';

class SupportHistoryItem extends StatelessWidget {
  final SupportHistoryModel item;

  const SupportHistoryItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            item.subtitle,
            style: getTextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
