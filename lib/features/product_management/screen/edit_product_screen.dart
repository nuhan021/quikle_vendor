import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/constants/colors.dart';
import '../../appbar/screen/appbar_screen.dart';
import '../controllers/edit_product_controller.dart';
import '../widgets/edit_product_form_widget.dart';
import '../widgets/remove_discount_dialog_widget.dart';

class EditProductScreen extends StatelessWidget {
  const EditProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProductController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppbarScreen(title: "Products"),
      body: SafeArea(
        child: Stack(
          children: [
            Column(children: [Expanded(child: EditProductFormWidget())]),

            // Remove Discount Dialog
            Obx(
              () => controller.showRemoveDiscountDialog.value
                  ? RemoveDiscountDialogWidget()
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
