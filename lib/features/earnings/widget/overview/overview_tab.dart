import 'package:flutter/material.dart';

import '../../../../core/common/styles/global_text_style.dart';
import 'stat_card.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Earnings Overview",
                style: getTextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  border: Border.all(color: Colors.black38),
                ),
                child: Text(
                  "This Week",
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          /// Earnings Card
          Container(
            height: 164,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.black, Color(0xFF333333)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                SizedBox(height: 8),
                Text(
                  "\$ Total Earnings",
                  style: getTextStyle(color: Colors.white70, fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  "\$4,250.80",
                  style: getTextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Net \$325.72",
                  style: getTextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          /// Stats Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: const [
              StatCard("Payment Received", "\$3,890.40", "142 orders"),
              StatCard("Pending", "\$360.40", "Processing"),
              StatCard("Commission", "\$425.08", "Platform fee"),
              StatCard("Avg Order", "\$29.93", "Per order"),
            ],
          ),
        ],
      ),
    );
  }
}
