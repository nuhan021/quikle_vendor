import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';

class ProductFormFields extends StatefulWidget {
  final List<String> selectedProductIds;
  final List<String> selectedProductNames;
  final Map<String, int> productQuantities;
  final Map<String, String> productBrands;
  final Map<String, String> productDosages;
  final Map<String, String> productNotes;
  final bool isMedicineReady;
  final VoidCallback onProductSelectorTap;
  final Function(int) onQuantityChange;
  final Function(int, String) onBrandChange;
  final Function(int, String) onDosageChange;
  final Function(int, String) onNotesChange;
  final Function(int) onDeleteProduct;

  const ProductFormFields({
    super.key,
    required this.selectedProductIds,
    required this.selectedProductNames,
    required this.productQuantities,
    required this.productBrands,
    required this.productDosages,
    required this.productNotes,
    required this.isMedicineReady,
    required this.onProductSelectorTap,
    required this.onQuantityChange,
    required this.onBrandChange,
    required this.onDosageChange,
    required this.onNotesChange,
    required this.onDeleteProduct,
  });

  @override
  State<ProductFormFields> createState() => _ProductFormFieldsState();
}

class _ProductFormFieldsState extends State<ProductFormFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildProductSelector(),
        if (widget.selectedProductNames.isNotEmpty) ...[
          SizedBox(height: 12.h),
          _buildSelectedProductsList(),
        ] else
          SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildProductSelector() {
    return GestureDetector(
      onTap: widget.isMedicineReady ? null : widget.onProductSelectorTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.ebonyBlack),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.selectedProductNames.isEmpty
                    ? 'Choose products'
                    : '${widget.selectedProductNames.length} selected',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: widget.selectedProductNames.isEmpty
                      ? Colors.grey
                      : Colors.black87,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9CA3AF)),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedProductsList() {
    return Column(
      children: widget.selectedProductNames.asMap().entries.map((entry) {
        final index = entry.key;
        final name = entry.value;
        final productId = widget.selectedProductIds[index];

        return Column(
          children: [
            _buildProductCard(index, name, productId),
            _buildProductFields(index, productId),
            if (index < widget.selectedProductNames.length - 1)
              SizedBox(height: 12.h),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildProductCard(int index, String name, String productId) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(width: 10.w),
          Expanded(
            flex: 1,
            child: Text(
              name,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(width: 8.w),
          _buildQuantityButtons(index, productId),
          SizedBox(width: 8.w),
          _buildDeleteButton(index),
        ],
      ),
    );
  }

  Widget _buildQuantityButtons(int index, String productId) {
    return Row(
      children: [
        GestureDetector(
          onTap: widget.isMedicineReady
              ? null
              : () {
                  final currentQty = widget.productQuantities[productId] ?? 1;
                  if (currentQty > 1) {
                    widget.onQuantityChange(currentQty - 1);
                  }
                },
          child: Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: widget.isMedicineReady ? Colors.grey : AppColors.primary,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Icon(Icons.remove, color: Colors.white, size: 16.sp),
          ),
        ),
        SizedBox(width: 6.w),
        SizedBox(
          width: 50.w,
          child: TextField(
            enabled: !widget.isMedicineReady,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            onChanged: (value) {
              final qty = int.tryParse(value) ?? 1;
              widget.onQuantityChange(qty > 0 ? qty : 1);
            },
            decoration: InputDecoration(
              hintText: 'Qty',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 4.h,
              ),
            ),
            controller: TextEditingController(
              text: (widget.productQuantities[productId] ?? 1).toString(),
            ),
          ),
        ),
        SizedBox(width: 6.w),
        GestureDetector(
          onTap: widget.isMedicineReady
              ? null
              : () {
                  final currentQty = widget.productQuantities[productId] ?? 1;
                  widget.onQuantityChange(currentQty + 1);
                },
          child: Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: widget.isMedicineReady ? Colors.grey : AppColors.primary,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Icon(Icons.add, color: Colors.white, size: 16.sp),
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteButton(int index) {
    return IconButton(
      onPressed: widget.isMedicineReady
          ? null
          : () => widget.onDeleteProduct(index),
      icon: Icon(
        Icons.delete,
        color: widget.isMedicineReady ? Colors.grey : Colors.red,
        size: 20.sp,
      ),
    );
  }

  Widget _buildProductFields(int index, String productId) {
    return Column(
      children: [
        SizedBox(height: 10.h),
        Row(
          children: [
            SizedBox(width: 10.w),
            Expanded(
              child: TextField(
                enabled: !widget.isMedicineReady,
                controller: TextEditingController(
                  text: widget.productBrands[productId] ?? '',
                ),
                onChanged: (value) => widget.onBrandChange(index, value),
                decoration: _inputDecoration('Brand'),
                style: TextStyle(fontSize: 12.sp),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: TextField(
                enabled: !widget.isMedicineReady,
                controller: TextEditingController(
                  text: widget.productDosages[productId] ?? '',
                ),
                onChanged: (value) => widget.onDosageChange(index, value),
                decoration: _inputDecoration('Dosage'),
                style: TextStyle(fontSize: 12.sp),
              ),
            ),
            SizedBox(width: 10.w),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            SizedBox(width: 10.w),
            Expanded(
              child: TextField(
                enabled: !widget.isMedicineReady,
                controller: TextEditingController(
                  text: widget.productNotes[productId] ?? '',
                ),
                onChanged: (value) => widget.onNotesChange(index, value),
                maxLines: 2,
                decoration: _inputDecoration('Notes for this medicine'),
                style: TextStyle(fontSize: 12.sp),
              ),
            ),
            SizedBox(width: 10.w),
          ],
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.r),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.r),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      hintStyle: TextStyle(fontSize: 12.sp),
    );
  }
}
