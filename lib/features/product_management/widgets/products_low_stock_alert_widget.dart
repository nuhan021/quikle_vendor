import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common/styles/global_text_style.dart';
import '../controllers/products_controller.dart';

class ProductsLowStockAlertWidget extends StatelessWidget {
  ProductsLowStockAlertWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>();

    return Obx(
      () => Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFFFECACA), width: 1),
        ),
        child: Row(
          children: [
            Icon(Icons.warning, color: Color(0xFFDC2626), size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                '${controller.lowStockCount} products are running low on stock',
                style: getTextStyle(fontSize: 16, color: Color(0xFF111827)),
              ),
            ),
            GestureDetector(
              onTap: controller.viewLowStockProducts,
              child: Text(
                'View',
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6366F1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
