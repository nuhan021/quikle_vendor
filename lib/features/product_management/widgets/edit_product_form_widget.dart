import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/common/styles/global_text_style.dart';
import '../../../core/common/widgets/custom_textfield.dart';
import '../controllers/edit_product_controller.dart';

class EditProductFormWidget extends StatelessWidget {
  const EditProductFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EditProductController>();

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image Section
          Text(
            'Product Image',
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF111827),
            ),
          ),
          SizedBox(height: 12),
          Obx(
            () => Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Color(0xFFD1FAE5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  controller.productImage.value,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Color(0xFFD1FAE5),
                      child: Center(
                        child: Image.asset(controller.productImage.value),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 24),

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
            hintText: 'Product description...',
            maxLines: 4,
            controller: controller.descriptionController,
          ),
          SizedBox(height: 16),

          // Product Weight/Quantity
          CustomTextField(
            label: 'Product Weight/Quantity',
            hintText: 'Weight/Quantity',
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
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
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
          SizedBox(height: 20),

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
          Obx(
            () => controller.isLoadingSubcategories.value
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Color(0xFFE5E7EB)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Loading subcategories...',
                          style: getTextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      _showSubCategoryDropdown(context, controller);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0xFFE5E7EB)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.selectedSubCategory.value.isEmpty
                                ? 'Select Sub Category'
                                : controller.selectedSubCategory.value,
                            style: getTextStyle(
                              fontSize: 14,
                              color:
                                  controller.selectedSubCategory.value.isEmpty
                                  ? Color(0xFF9CA3AF)
                                  : Color(0xFF111827),
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
          SizedBox(height: 24),

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

          // Save Changes Button
          GestureDetector(
            onTap: controller.saveChanges,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Color(0xFF111827),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Save Changes',
                style: getTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showSubCategoryDropdown(
    BuildContext context,
    EditProductController controller,
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
                  label: 'Category',
                  hintText: 'Search sub category...',
                  onChanged: (value) {
                    controller.subCategorySearchText.value = value;
                  },
                ),
                SizedBox(height: 12),
                // Sub Categories List
                Expanded(
                  child: Obx(() {
                    final filtered = controller.getFilteredSubCategories();
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
                                      controller.changeSubCategory(
                                        subCategory.name,
                                      );
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
                                                  subCategory.name
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
                                                  subCategory.name
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
