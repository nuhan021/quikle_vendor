import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/features/product_management/widgets/filter_product_widget.dart';
import '../../../core/utils/constants/colors.dart';
import '../../appbar/screen/appbar_screen.dart';
import '../controllers/products_controller.dart';
import '../widgets/products_search_widget.dart';
import '../widgets/products_action_buttons_widget.dart';
import '../widgets/products_low_stock_alert_widget.dart';
import '../widgets/products_list_widget.dart';
import '../widgets/add_product_modal_widget.dart';
import '../widgets/create_discount_modal_widget.dart';
import '../widgets/delete_product_dialog_widget.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductsController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppbarScreen(title: "Products"),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                ProductsSearchWidget(),
                ProductsActionButtonsWidget(),
                ProductsLowStockAlertWidget(),
                Expanded(child: ProductsListWidget()),
              ],
            ),

            // Modals and Dialogs
            Obx(
              () => controller.showAddProductModal.value
                  ? AddProductModalWidget()
                  : Container(),
            ),

            Obx(
              () => controller.showFilterProductModal.value
                  ? FilterProductWidget()
                  : Container(),
            ),

            Obx(
              () => controller.showCreateDiscountModal.value
                  ? CreateDiscountModalWidget()
                  : Container(),
            ),

            Obx(
              () => controller.showDeleteDialog.value
                  ? DeleteProductDialogWidget()
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
