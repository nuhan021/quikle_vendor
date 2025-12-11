import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common/styles/global_text_style.dart';
import '../controller/home_controller.dart';
import 'pending_action_card_widget.dart';
import 'package:quikle_vendor/features/product_management/controllers/products_controller.dart';

class PendingActionsWidget extends StatelessWidget {
  PendingActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.schedule, size: 22, color: Color(0xFFEF4444)),
            SizedBox(width: 8),
            Text(
              'Pending Actions',
              style: getTextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Obx(() {
          // Try to get products controller if registered
          final hasProductsController = Get.isRegistered<ProductsController>();
          final productsController = hasProductsController
              ? Get.find<ProductsController>()
              : null;

          final lowStockCount = productsController?.lowStockCount ?? 0;

          // Build a list of action cards, but override the subtitle for Update Inventory
          final otherActions = controller.pendingActions
              .where((a) => a['title'] != 'Update Inventory')
              .toList();

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              children: [
                // Update Inventory card (dynamic subtitle)
                PendingActionCardWidget(
                  title: 'Update Inventory',
                  subtitle: '$lowStockCount items low in stock',
                  buttonText: 'Update',
                  buttonColor: const Color(0xFFEF4444),
                  onTap: controller.updateInventory,
                ),

                // Render any other pending actions (if present)
                ...otherActions.map(
                  (action) => PendingActionCardWidget(
                    title: action['title'] as String,
                    subtitle: action['subtitle'] as String,
                    buttonText: action['buttonText'] as String,
                    buttonColor: action['buttonColor'] as Color,
                    onTap: action['title'] == 'Update Inventory'
                        ? controller.updateInventory
                        : controller.assignRider,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
