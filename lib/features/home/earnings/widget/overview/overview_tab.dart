import 'package:flutter/material.dart';

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
            children: const [
              Text(
                "Earnings Overview",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text("This Week"),
            ],
          ),
          const SizedBox(height: 12),

          /// Earnings Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.black, Colors.black87],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: const [
                Text(
                  "\$ Total Earnings",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  "\$4,250.80",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Net \$325.72",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
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
