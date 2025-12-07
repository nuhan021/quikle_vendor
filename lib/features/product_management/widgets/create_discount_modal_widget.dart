import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common/styles/global_text_style.dart';
import '../../../core/common/widgets/custom_button.dart';
import '../../../core/common/widgets/custom_textfield.dart';
import '../controllers/create_discount_controller.dart';
import '../model/products_model.dart';

class CreateDiscountModalWidget extends StatelessWidget {
  const CreateDiscountModalWidget({super.key});

  Future<void> _selectStartDateTime(
    BuildContext context,
    CreateDiscountController controller,
  ) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.white,
            cardColor: Colors.white,
            colorScheme: ColorScheme.light(
              primary: Colors.black,
              surface: Colors.white,
              onSurface: Colors.black,
              outline: Colors.grey,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      final dateStr =
          '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
      controller.setStartDate(dateStr);
    }
  }

  Future<void> _selectEndDateTime(
    BuildContext context,
    CreateDiscountController controller,
  ) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.white,
            cardColor: Colors.white,
            colorScheme: ColorScheme.light(
              primary: Colors.black,
              surface: Colors.white,
              onSurface: Colors.black,
              outline: Colors.grey,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      final dateStr =
          '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
      controller.setEndDate(dateStr);
    }
  }

  void _showProductSelectionDialog(
    BuildContext context,
    CreateDiscountController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Product',
                      style: getTextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        color: Color(0xFF6B7280),
                        size: 24,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Search Field
                CustomTextField(
                  controller: controller.productSearchController,
                  label: 'Search Products',
                  hintText: 'Search by name or category',
                  onChanged: (value) {
                    controller.searchProducts(value);
                  },
                ),
                SizedBox(height: 16),

                // Products List
                Expanded(
                  child: Obx(
                    () => ListView.builder(
                      itemCount: controller.filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = controller.filteredProducts[index];
                        return GestureDetector(
                          onTap: () {
                            controller.setSelectedProduct(
                              product.title,
                              product.id.toString(),
                            );
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 12),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFE5E7EB)),
                              borderRadius: BorderRadius.circular(8),
                              color:
                                  controller.selectedProductId.value ==
                                      product.id.toString()
                                  ? Color(0xFFFFC200).withAlpha(25)
                                  : Colors.white,
                            ),
                            child: Row(
                              children: [
                                // Product Image
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: NetworkImage(product.image),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),

                                // Product Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.title,
                                        style: getTextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF111827),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            'Category ${product.categoryId}',
                                            style: getTextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF6B7280),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            '• ${_getStatusText(product)}',
                                            style: getTextStyle(
                                              fontSize: 12,
                                              color:
                                                  _getStatusText(product) ==
                                                      'In Stock'
                                                  ? Color(0xFF10B981)
                                                  : _getStatusText(product) ==
                                                        'Low Stock'
                                                  ? Color(0xFFF59E0B)
                                                  : Color(0xFFEF4444),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Checkmark
                                if (controller.selectedProductId.value ==
                                    product.id.toString())
                                  Icon(
                                    Icons.check_circle,
                                    color: Color(0xFFFFC200),
                                    size: 24,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
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
    final controller = Get.put(CreateDiscountController());

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
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
              // Create Discount Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Create Discount',
                    style: getTextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.closeDiscountDialog,
                    child: Icon(
                      Icons.close,
                      color: Color(0xFF6B7280),
                      size: 24,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Discount Name
              CustomTextField(
                controller: controller.discountNameController,
                label: 'Discount Name',
                hintText: 'Product Name',
              ),
              SizedBox(height: 16),

              // Discount Code
              CustomTextField(
                controller: controller.discountCodeController,
                label: 'Discount Code',
                hintText: 'SUMMER20',
              ),
              SizedBox(height: 16),

              // Discount Value
              CustomTextField(
                controller: controller.discountValueController,
                label: 'Discount Value',
                hintText: '\$19',
              ),
              SizedBox(height: 16),

              // Choose Product
              Text(
                'Choose Product',
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF111827),
                ),
              ),
              SizedBox(height: 8),
              Obx(
                () => GestureDetector(
                  onTap: () => _showProductSelectionDialog(context, controller),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFE5E7EB)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            controller.selectedProduct.value,
                            style: getTextStyle(
                              fontSize: 16,
                              color: Color(0xFF111827),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF9CA3AF),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Start Date & Time and End Date & Time
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Start Date',
                          style: getTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF111827),
                          ),
                        ),
                        SizedBox(height: 8),
                        GestureDetector(
                          onTap: () =>
                              _selectStartDateTime(context, controller),
                          child: Obx(
                            () => Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFE5E7EB)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      controller.startDate.value.isEmpty
                                          ? 'mm/dd/yyyy'
                                          : controller.startDate.value,
                                      style: getTextStyle(
                                        fontSize: 14,
                                        color:
                                            controller.startDate.value.isEmpty
                                            ? Color(0xFF9CA3AF)
                                            : Color(0xFF111827),
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.calendar_today,
                                    color: Color(0xFF9CA3AF),
                                    size: 16,
                                  ),
                                ],
                              ),
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
                        Text(
                          'End Date',
                          style: getTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF111827),
                          ),
                        ),
                        SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _selectEndDateTime(context, controller),
                          child: Obx(
                            () => Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFE5E7EB)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      controller.endDate.value.isEmpty
                                          ? 'mm/dd/yyyy'
                                          : controller.endDate.value,
                                      style: getTextStyle(
                                        fontSize: 14,
                                        color: controller.endDate.value.isEmpty
                                            ? Color(0xFF9CA3AF)
                                            : Color(0xFF111827),
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.calendar_today,
                                    color: Color(0xFF9CA3AF),
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Add Discount Button
              CustomButton(
                text: 'Add Discount',
                onPressed: controller.addDiscount,
                height: 50,
                backgroundColor: Color(0xFF111827),
                textColor: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusText(Product product) {
    if (!product.isInStock) return 'Out of Stock';
    if (product.stock <= 10) return 'Low Stock';
    return 'In Stock';
  }
}
