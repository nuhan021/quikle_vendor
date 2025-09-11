import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/common/widgets/custom_button.dart';
import '../../../core/common/styles/global_text_style.dart';
import '../controllers/products_controller.dart';

class FilterProductWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>();

    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filters Section
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Category',
                            style: getTextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF111827),
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFE5E7EB)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'All Categories',
                                  style: getTextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Color(0xFF9CA3AF),
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Stock Status',
                                style: getTextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF111827),
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: controller.hideFilterProductDialog,
                                child: Icon(
                                  Icons.close,
                                  color: Color(0xFF6B7280),
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFE5E7EB)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'All Status',
                                  style: getTextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Color(0xFF9CA3AF),
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Apply Filters Button
                CustomButton(
                  text: 'Apply Filters',
                  onPressed: controller.applyFilters,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
