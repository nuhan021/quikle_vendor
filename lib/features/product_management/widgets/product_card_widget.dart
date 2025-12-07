import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common/styles/global_text_style.dart';
import '../controllers/products_controller.dart';
import '../model/products_model.dart';

class ProductCardWidget extends StatelessWidget {
  final Product product;

  const ProductCardWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>();

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Product Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _getImageBackgroundColor(_getStatusText()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    product.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: _getImageBackgroundColor(_getStatusText()),
                        child: Icon(Icons.image, size: 40, color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 16),

              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product.title,
                            style: getTextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  controller.editProduct(product.id.toString()),
                              child: Icon(
                                Icons.edit_outlined,
                                color: Color(0xFF6B7280),
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 12),
                            GestureDetector(
                              onTap: () => controller.showDeleteConfirmation(
                                product.id.toString(),
                              ),
                              child: Icon(
                                Icons.delete_outline,
                                color: Color(0xFFEF4444),
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: Color(0xFFFBBF24), size: 16),
                        SizedBox(width: 4),
                        Text(
                          '${product.ratings.toStringAsFixed(1)}',
                          style: getTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF111827),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '• ${product.weight}kg',
                          style: getTextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _getStatusText(),
                          style: getTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _getStatusColor(_getStatusText()),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      '\$${double.tryParse(product.sellPrice)?.toStringAsFixed(2) ?? product.sellPrice}',
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),

          // Stock Info and Progress Bar
          Row(
            children: [
              Icon(Icons.inventory, color: Colors.black, size: 16),
              SizedBox(width: 8),
              Text(
                '${product.stock} units',
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              Spacer(),
              Container(
                width: 120,
                height: 6,
                decoration: BoxDecoration(
                  color: Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _getStockProgress(product.stock),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _getProgressColor(_getStatusText()),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getStatusText() {
    if (!product.isInStock) return 'Out of Stock';
    if (product.stock <= 10) return 'Low Stock';
    return 'In Stock';
  }

  Color _getImageBackgroundColor(String status) {
    switch (status) {
      case 'In Stock':
        return Color(0xFFD1FAE5);
      case 'Low Stock':
        return Color(0xFFFED7AA);
      case 'Out of Stock':
        return Color(0xFFFECACA);
      default:
        return Color(0xFFF3F4F6);
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'In Stock':
        return Color(0xFF10B981);
      case 'Low Stock':
        return Color(0xFFF59E0B);
      case 'Out of Stock':
        return Color(0xFFEF4444);
      default:
        return Color(0xFF6B7280);
    }
  }

  Color _getProgressColor(String status) {
    switch (status) {
      case 'In Stock':
        return Color(0xFF10B981);
      case 'Low Stock':
        return Color(0xFFF59E0B);
      case 'Out of Stock':
        return Color(0xFFEF4444);
      default:
        return Color(0xFF6B7280);
    }
  }

  double _getStockProgress(int stock) {
    if (stock >= 100) return 1.0;
    if (stock >= 50) return 0.8;
    if (stock >= 20) return 0.6;
    if (stock > 0) return 0.3;
    return 0.0;
  }
}
