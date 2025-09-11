import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common/styles/global_text_style.dart';
import '../../../core/common/widgets/custom_button.dart';
import '../controllers/edit_product_controller.dart';

class RemoveDiscountDialogWidget extends StatelessWidget {
  RemoveDiscountDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EditProductController>();

    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Do You Want To ',
                      style: getTextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                    TextSpan(
                      text: 'Remove',
                      style: getTextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                    TextSpan(
                      text: '\nDiscount From This\nProduct ?',
                      style: getTextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Discount will be removed from this product permanently if you select yes',
                style: getTextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'No',
                      onPressed: controller.hideRemoveDiscountConfirmation,
                      textColor: Colors.black,
                      backgroundColor: Colors.white,
                      borderColor: Colors.black,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      text: 'Yes',
                      onPressed: controller.removeDiscount,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
