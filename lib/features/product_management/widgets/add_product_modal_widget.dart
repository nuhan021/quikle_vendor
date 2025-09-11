import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common/styles/global_text_style.dart';
import '../controllers/products_controller.dart';

class AddProductModalWidget extends StatelessWidget {
  AddProductModalWidget({super.key});

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add New Product',
                      style: getTextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.hideAddProductDialog,
                      child: Icon(
                        Icons.close,
                        color: Color(0xFF6B7280),
                        size: 24,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Product Image
                Text(
                  'Product Image',
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xFFE5E7EB), width: 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        color: Color(0xFF9CA3AF),
                        size: 32,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap to upload image',
                        style: getTextStyle(
                          fontSize: 14,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Product Name
                Text(
                  'Product Name',
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Product Name',
                    hintStyle: getTextStyle(color: Color(0xFF9CA3AF)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Color(0xFF6366F1)),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Description
                Text(
                  'Description',
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Please describe your issue in detail...',
                    hintStyle: getTextStyle(color: Color(0xFF9CA3AF)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Color(0xFF6366F1)),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Product Weight/Quantity
                Text(
                  'Product Weight/Quantity',
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: '1kg',
                    hintStyle: getTextStyle(color: Color(0xFF9CA3AF)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Color(0xFF6366F1)),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Price and Stock Quantity
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price (\$)',
                            style: getTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF111827),
                            ),
                          ),
                          SizedBox(height: 8),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Product Name',
                              hintStyle: getTextStyle(color: Color(0xFF9CA3AF)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Color(0xFFE5E7EB),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Color(0xFF6366F1),
                                ),
                              ),
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
                          Text(
                            'Stock Quantity',
                            style: getTextStyle(
                              fontSize: 16,
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
                                  '1',
                                  style: getTextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF111827),
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

                // Category
                Text(
                  'Category',
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'All Categories',
                    hintStyle: getTextStyle(color: Color(0xFF9CA3AF)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Color(0xFF6366F1)),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Sub Category
                Text(
                  'Sub Category',
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'All Categories',
                    hintStyle: getTextStyle(color: Color(0xFF9CA3AF)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Color(0xFF6366F1)),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Product
                Text(
                  'Product',
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'All Categories',
                    hintStyle: getTextStyle(color: Color(0xFF9CA3AF)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Color(0xFF6366F1)),
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Add Product Button
                GestureDetector(
                  onTap: controller.addProduct,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Color(0xFF111827),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Add Product',
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
