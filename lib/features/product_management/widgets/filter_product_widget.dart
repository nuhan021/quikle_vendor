import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/common/widgets/custom_button.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import '../../../core/common/styles/global_text_style.dart';
import '../controllers/products_controller.dart';

class FilterProductWidget extends StatefulWidget {
  @override
  _FilterProductWidgetState createState() => _FilterProductWidgetState();
}

class _FilterProductWidgetState extends State<FilterProductWidget> {
  void _showSubCategoryDropdown(
    BuildContext context,
    ProductsController controller,
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
                  'Select Category',
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 16),
                // Search Field
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search category...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) {
                    controller.subCategorySearchText.value = value;
                  },
                ),
                SizedBox(height: 12),
                // Categories List
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
                                    'No categories found',
                                    style: getTextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ),
                              ),
                            ]
                          : [
                              // "All Categories" option
                              GestureDetector(
                                onTap: () {
                                  controller.changeSubCategory(
                                    'All Categories',
                                  );
                                  controller.subCategorySearchText.value = '';
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
                                              'All Categories'
                                          ? Colors.black.withValues(alpha: 0.5)
                                          : Color(0xFFE5E7EB),
                                    ),
                                  ),
                                  child: Text(
                                    'All Categories',
                                    style: getTextStyle(
                                      fontSize: 14,
                                      fontWeight:
                                          controller
                                                  .selectedSubCategory
                                                  .value ==
                                              'All Categories'
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: Color(0xFF111827),
                                    ),
                                  ),
                                ),
                              ),
                              ...filtered.map(
                                (subCategory) => GestureDetector(
                                  onTap: () {
                                    controller.changeSubCategory(
                                      subCategory['name'],
                                    );
                                    controller.subCategorySearchText.value = '';
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
                                                subCategory['name']
                                            ? Colors.black.withValues(
                                                alpha: 0.5,
                                              )
                                            : Color(0xFFE5E7EB),
                                      ),
                                    ),
                                    child: Text(
                                      subCategory['name'],
                                      style: getTextStyle(
                                        fontSize: 14,
                                        fontWeight:
                                            controller
                                                    .selectedSubCategory
                                                    .value ==
                                                subCategory['name']
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: Color(0xFF111827),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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

  void _showStockStatusDropdown(
    BuildContext context,
    ProductsController controller,
  ) {
    final stockStatusOptions = [
      'All Status',
      'In Stock',
      'Low Stock',
      'Out of Stock',
    ];

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
            constraints: BoxConstraints(maxHeight: 300),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Stock Status',
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 16),
                // Stock Status List
                Expanded(
                  child: ListView(
                    children: stockStatusOptions
                        .map(
                          (status) => GestureDetector(
                            onTap: () {
                              controller.selectedStockStatus.value = status;
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
                                      controller.selectedStockStatus.value ==
                                          status
                                      ? Colors.black.withValues(alpha: 0.5)
                                      : Color(0xFFE5E7EB),
                                ),
                              ),
                              child: Text(
                                status,
                                style: getTextStyle(
                                  fontSize: 14,
                                  fontWeight:
                                      controller.selectedStockStatus.value ==
                                          status
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: Color(0xFF111827),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>();
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filters Section
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Category',
                            style: getTextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF111827),
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFE5E7EB)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: GestureDetector(
                              onTap: () =>
                                  _showSubCategoryDropdown(context, controller),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(
                                    () => Text(
                                      controller.selectedCategory.value,
                                      style: getTextStyle(
                                        fontSize: 12,
                                        color: AppColors.ebonyBlack,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: AppColors.ebonyBlack,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Stock Status',
                                style: getTextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF111827),
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: controller.hideFilterProductDialog,
                                child: Icon(
                                  Icons.close,
                                  color: Color(0xFF6B7280),
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFE5E7EB)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: GestureDetector(
                              onTap: () =>
                                  _showStockStatusDropdown(context, controller),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(
                                    () => Text(
                                      controller.selectedStockStatus.value,
                                      style: getTextStyle(
                                        fontSize: 12,
                                        color: AppColors.ebonyBlack,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: AppColors.ebonyBlack,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Apply Filters Button
                CustomButton(
                  text: 'Apply Filters',
                  onPressed: controller.applyFilters,
                  backgroundColor: AppColors.ebonyBlack,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
