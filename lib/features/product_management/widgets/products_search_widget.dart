import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common/styles/global_text_style.dart';
import '../controllers/products_controller.dart';

class ProductsSearchWidget extends StatelessWidget {
  ProductsSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>();

    return Container(
      padding: EdgeInsets.all(14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Color(0xFF9CA3AF), size: 24),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      onChanged: controller.onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        hintStyle: getTextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12),
          // GestureDetector(
          //   onTap: () => controller.showFilterProductDialog(),
          //   child: Container(
          //     width: 55,
          //     height: 55,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(12),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black.withValues(alpha: 0.05),
          //           blurRadius: 6,
          //           offset: Offset(0, 2),
          //         ),
          //       ],
          //     ),
          //     child: Icon(Icons.tune, color: Color(0xFF374151), size: 24),
          //   ),
          // ),
        ],
      ),
    );
  }
}
