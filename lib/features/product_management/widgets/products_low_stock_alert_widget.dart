import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common/styles/global_text_style.dart';
import '../controllers/products_controller.dart';

class ProductsLowStockAlertWidget extends StatelessWidget {
  const ProductsLowStockAlertWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>();

    return Obx(() {
      // Only show alert if there are low stock products
      if (controller.lowStockCount == 0) {
        return SizedBox.shrink();
      }

      return Container(
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Color.fromARGB(255, 233, 233, 233),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.warning, color: Color(0xFFDC2626), size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                '${controller.lowStockCount} products are running low on stock',
                style: getTextStyle(fontSize: 14, color: Color(0xFF111827)),
              ),
            ),
            GestureDetector(
              onTap: controller.viewLowStockProducts,
              child: Obx(
                () => Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: controller.showLowStockFilter.value
                        ? Color(0xFFDC2626)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: Color(0xFFDC2626), width: 1),
                  ),
                  child: Text(
                    'View',
                    style: getTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: controller.showLowStockFilter.value
                          ? Colors.white
                          : Color(0xFFDC2626),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
