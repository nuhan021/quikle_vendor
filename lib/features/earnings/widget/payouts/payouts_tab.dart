import 'package:flutter/material.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_button.dart';

class PayoutsTab extends StatelessWidget {
  const PayoutsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Available Balance Card
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 8),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Available Balance",
                      style: getTextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "\$47.40",
                      style: getTextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Next auto-withdrawal: Every Friday",
                      style: getTextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),

                /// Custom Withdraw Button
                CustomButton(
                  height: 32,
                  width: 87,
                  text: "Withdraw",
                  onPressed: () {
                    // TODO: Withdraw logic
                  },
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 12,
                  borderRadius: 8,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// Withdrawal Configuration
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
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
                  "Withdrawal Configuration",
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                /// Minimum Withdrawal Amount
                Text(
                  "Minimum Withdrawal Amount",
                  style: getTextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  initialValue: "\$100",
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                /// Auto Withdrawal Day
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Auto Withdrawal Day",
                      style: getTextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    SizedBox(
                      height: 28,
                      width: 36,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Switch(
                          value: true,
                          onChanged: (val) {
                            // TODO: toggle auto withdrawal
                          },
                          activeColor: Colors.white, // thumb
                          activeTrackColor: Colors.green, // track when active
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor:
                              Colors.grey.shade300, // track when inactive
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: "Friday",
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: "Monday",
                      child: Text(
                        "Monday",
                        style: getTextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: "Friday",
                      child: Text(
                        "Friday",
                        style: getTextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (val) {
                    // TODO: change withdrawal day
                  },
                ),
                const SizedBox(height: 16),

                /// Payment Method
                Text(
                  "Payment Method",
                  style: getTextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: "Bank Transfer",
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: "Bank Transfer",
                      child: Text(
                        "Bank Transfer",
                        style: getTextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: "PayPal",
                      child: Text(
                        "PayPal",
                        style: getTextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (val) {
                    // TODO: change payment method
                  },
                ),
                const SizedBox(height: 16),

                /// Bank Account
                Text(
                  "Bank Account",
                  style: getTextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  initialValue: "123456789",
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
