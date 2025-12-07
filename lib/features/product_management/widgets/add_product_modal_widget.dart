import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../../core/common/styles/global_text_style.dart';
import '../../../core/common/widgets/custom_button.dart';
import '../../../core/common/widgets/custom_textfield.dart';
import '../controllers/add_product_controller.dart';

class AddProductModalWidget extends StatelessWidget {
  const AddProductModalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddProductController>();

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Center(
        child: Container(
          margin: EdgeInsets.all(20),

          // padding: EdgeInsets.only(left: 16, right: 16, top: 16),
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

                // Product Name
                CustomTextField(
                  label: 'Product Name',
                  hintText: controller.vendorType,
                  readOnly: true,
                  controller: controller.productNameController,
                ),
                SizedBox(height: 16),

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
                Obx(
                  () => GestureDetector(
                    onTap: controller.pickProductImage,
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xFFE5E7EB), width: 1),
                      ),
                      child: controller.productImage.value.isEmpty
                          ? Column(
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
                            )
                          : Image.file(
                              File(controller.productImage.value),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Product Name
                CustomTextField(
                  label: 'Product Name',
                  hintText: 'Product Name',
                  controller: controller.productNameController,
                ),
                SizedBox(height: 16),

                // Description
                CustomTextField(
                  label: 'Description',
                  hintText: 'Please describe your issue in detail...',
                  maxLines: 4,
                  controller: controller.descriptionController,
                ),
                SizedBox(height: 16),

                // Product Weight/Quantity
                CustomTextField(
                  label: 'Product Weight/Quantity',
                  hintText: '1kg',
                  controller: controller.weightController,
                ),
                SizedBox(height: 16),

                // Price and Stock Quantity
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Price (\$)',
                        hintText: 'Product Price',
                        controller: controller.priceController,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        label: 'Stock Quantity',
                        hintText: 'Enter quantity',
                        controller: controller.stockQuantityController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Discount
                CustomTextField(
                  label: 'Discount (%)',
                  hintText: 'Enter discount percentage',
                  controller: controller.discountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                ),
                SizedBox(height: 16),

                // // Category
                // Text(
                //   'Category',
                //   style: getTextStyle(
                //     fontSize: 14,
                //     fontWeight: FontWeight.w500,
                //     color: Color(0xFF111827),
                //   ),
                // ),
                // SizedBox(height: 8),
                // Obx(
                //   () => Container(
                //     padding: EdgeInsets.symmetric(horizontal: 12),
                //     decoration: BoxDecoration(
                //       border: Border.all(color: Color(0xFFE5E7EB)),
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //     child: DropdownButton<String>(
                //       value:
                //           controller.categories.contains(
                //             controller.selectedCategory.value,
                //           )
                //           ? controller.selectedCategory.value
                //           : controller.categories.first,
                //       isExpanded: true,
                //       underline: SizedBox(),
                //       items: controller.categories
                //           .map(
                //             (category) => DropdownMenuItem(
                //               value: category,
                //               child: Text(category),
                //             ),
                //           )
                //           .toList(),
                //       onChanged: (value) {
                //         if (value != null) {
                //           controller.changeCategory(value);
                //           if (controller.subCategories[value] != null &&
                //               controller.subCategories[value]!.isNotEmpty) {
                //             controller.selectedSubCategory.value =
                //                 controller.subCategories[value]![0];
                //           }
                //         }
                //       },
                //     ),
                //   ),
                // ),
                // SizedBox(height: 16),

                // Sub Category
                Text(
                  'Sub Category',
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 8),
                Obx(
                  () => GestureDetector(
                    onTap: () {
                      _showSubCategoryDropdown(context, controller);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFE5E7EB)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.selectedSubCategoryName.value.isEmpty
                                ? 'Select Sub Category'
                                : controller.selectedSubCategoryName.value,

                            style: getTextStyle(
                              fontSize: 14,
                              color: Color(0xFF111827),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xFF9CA3AF),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                if (controller.vendorType == 'medicine') ...[
                  // Medicine Type
                  Text(
                    'Medicine Type',
                    style: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 8),

                  Obx(
                    () => Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        children: [
                          // OTC Option
                          GestureDetector(
                            onTap: () =>
                                controller.toggleOtc(!controller.isOtc.value),
                            child: Row(
                              children: [
                                Icon(
                                  controller.isOtc.value
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color: controller.isOtc.value
                                      ? Color(0xFFFFC200)
                                      : Color(0xFF9CA3AF),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "OTC (Over-the-counter)",
                                    style: getTextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF111827),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],

                // Add Product Button
                CustomButton(
                  text: 'Add Product',
                  onPressed: controller.addProduct,
                ),
                // SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSubCategoryDropdown(
    BuildContext context,
    AddProductController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            constraints: BoxConstraints(maxHeight: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Sub Category',
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 16),
                // Search Field
                CustomTextField(
                  label: '',
                  hintText: 'Search sub category...',
                  onChanged: (value) {
                    controller.subCategorySearchText.value = value;
                  },
                ),
                SizedBox(height: 12),
                // Sub Categories List
                Expanded(
                  child: Obx(() {
                    final filtered = controller.subCategoriesList;
                    return ListView(
                      children: filtered.isEmpty
                          ? [
                              Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: Text(
                                    'No sub categories found',
                                    style: getTextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ),
                              ),
                            ]
                          : filtered
                                .map(
                                  (subCategory) => GestureDetector(
                                    onTap: () {
                                      controller.selectedSubCategoryName.value =
                                          subCategory.name;
                                      controller.selectedSubCategoryId.value =
                                          subCategory.id; // IMPORTANT
                                      controller.subCategorySearchText.value =
                                          '';
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 12,
                                      ),
                                      margin: EdgeInsets.only(bottom: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color:
                                              controller
                                                      .selectedSubCategory
                                                      .value ==
                                                  subCategory
                                              ? Colors.black.withValues(
                                                  alpha: 0.5,
                                                )
                                              : Color(0xFFE5E7EB),
                                        ),
                                      ),
                                      child: Text(
                                        subCategory.name,
                                        style: getTextStyle(
                                          fontSize: 14,
                                          fontWeight:
                                              controller
                                                      .selectedSubCategory
                                                      .value ==
                                                  subCategory
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          color: Color(0xFF111827),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      controller.subCategorySearchText.value = '';
    });
  }
}
