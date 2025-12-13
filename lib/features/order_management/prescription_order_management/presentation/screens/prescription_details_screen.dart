// pubspec.yaml
// dependencies:
//   flutter_screenutil: ^5.9.0

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import '../../../../appbar/screen/appbar_screen.dart';
import '../../../../../core/common/widgets/custom_button.dart';
import '../../../../product_management/controllers/products_controller.dart';

class PrescriptionDetailsScreen extends StatelessWidget {
  const PrescriptionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (_, __) => const _PrescriptionDetailsBody(),
    );
  }
}

class _PrescriptionDetailsBody extends StatefulWidget {
  const _PrescriptionDetailsBody();

  @override
  State<_PrescriptionDetailsBody> createState() =>
      _PrescriptionDetailsBodyState();
}

class _PrescriptionDetailsBodyState extends State<_PrescriptionDetailsBody> {
  final selectedProductIds = <String>[];
  final selectedProductNames = <String>[];
  final searchText = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      appBar: const AppbarScreen(title: 'Prescription Details'),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 96.h),
            children: [
              // Prescription image card
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20.r),
                  // border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8.r,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 3 / 4,
                      child: Ink.image(
                        image: const NetworkImage(
                          'https://imgs.search.brave.com/b8u829GFjpCquGUYPtW6QamhNJt5rugFN_okyzGZVMo/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS5nZXR0eWltYWdl/cy5jb20vaWQvODgx/NjAzMDMvcGhvdG8v/ZG9jdG9ycy1wcmVz/Y3JpcHRpb24tc2xp/cC5qcGc_cz02MTJ4/NjEyJnc9MCZrPTIw/JmM9M2VlWG44UXFI/emk1ekNDbFF6WnJO/VWNnVjdSeEtNenJM/Qk9vNWk1cEZSQT0',
                        ),
                        fit: BoxFit.cover,
                        child: InkWell(onTap: () {}),
                      ),
                    ),
                    // Positioned(
                    //   bottom: 12.h,
                    //   right: 12.w,
                    //   child: Container(
                    //     padding: EdgeInsets.all(6.r),
                    //     decoration: BoxDecoration(
                    //       color: Colors.black54,
                    //       borderRadius: BorderRadius.circular(999.r),
                    //     ),
                    //     child: Icon(
                    //       Icons.zoom_in,
                    //       color: Colors.white,
                    //       size: 20.sp,
                    //     ),
                    //   ),
                    // ),
                    Positioned(
                      top: 12.h,
                      left: 12.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(999.r),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          '#ORD-8921',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF137FEC),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Verification status
              Text(
                'Verification Status',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: 8.h),
              const _VerificationDropdown(),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: AppColors.beakYellow.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info, color: AppColors.beakYellow, size: 18.sp),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        "Please verify the doctor's signature and date before marking as valid.",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.ebonyBlack,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Product Selection section
              Text(
                'Select Products',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: () {
                  _showProductSelectionDialog(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.ebonyBlack),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          selectedProductNames.isEmpty
                              ? 'Choose products'
                              : '${selectedProductNames.length} selected',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: selectedProductNames.isEmpty
                                ? Colors.grey
                                : Colors.black87,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ],
                  ),
                ),
              ),
              if (selectedProductNames.isNotEmpty) ...[
                SizedBox(height: 12.h),
                Column(
                  children: selectedProductNames.asMap().entries.map((entry) {
                    final index = entry.key;
                    final name = entry.value;
                    return Column(
                      children: [
                        Container(
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8.w),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    selectedProductNames.remove(name);
                                    if (selectedProductIds.length > index) {
                                      selectedProductIds.removeAt(index);
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 20.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (index < selectedProductNames.length - 1)
                          SizedBox(height: 8.h),
                      ],
                    );
                  }).toList(),
                ),
              ],
              SizedBox(height: 24.h),

              // Prescribed items

              // Selected items
              // Column(
              //   children: [
              //     _MedicineTile(
              //       icon: Icons.medication,
              //       name: 'Panadol Extra',
              //       details: '500mg • Tablet',
              //       quantity: 2,
              //     ),
              //     SizedBox(height: 8.h),
              //     _MedicineTile(
              //       icon: Icons.sanitizer,
              //       name: 'Betadine Solution',
              //       details: '100ml • Liquid',
              //       quantity: 1,
              //     ),
              //   ],
              // ),
            ],
          ),

          // Bottom button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: const Color(0xFFF6F7F8),
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
              child: CustomButton(
                text: 'Submit',
                onPressed: () {},
                height: 48.h,
                borderRadius: 14,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showProductSelectionDialog(BuildContext context) {
    final ProductsController productsController =
        Get.find<ProductsController>();
    String tempSearchText = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final filtered = productsController.products
                .where(
                  (product) => product.title.toLowerCase().contains(
                    tempSearchText.toLowerCase(),
                  ),
                )
                .toList();

            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Container(
                padding: EdgeInsets.all(16.w),
                constraints: BoxConstraints(maxHeight: 400.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Products',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Search field
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          tempSearchText = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(
                            color: AppColors.ebonyBlack,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(
                            color: AppColors.ebonyBlack,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(
                            color: AppColors.ebonyBlack,
                            width: 1,
                          ),
                        ),
                        prefixIcon: const Icon(Icons.search),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 10.h,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Product list
                    Expanded(
                      child: ListView(
                        children: filtered.isEmpty
                            ? [
                                Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.all(16.w),
                                  child: Center(
                                    child: Text(
                                      'No products found',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: const Color(0xFF9CA3AF),
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                            : filtered
                                  .map(
                                    (product) => GestureDetector(
                                      onTap: () {
                                        final productId = product.id.toString();
                                        final productName = product.title;

                                        if (selectedProductIds.contains(
                                          productId,
                                        )) {
                                          selectedProductIds.remove(productId);
                                          selectedProductNames.remove(
                                            productName,
                                          );
                                        } else {
                                          selectedProductIds.add(productId);
                                          selectedProductNames.add(productName);
                                        }

                                        setState(() {});
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12.h,
                                          horizontal: 12.w,
                                        ),
                                        margin: EdgeInsets.only(bottom: 4.h),
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            6.r,
                                          ),
                                          border: Border.all(
                                            color:
                                                selectedProductIds.contains(
                                                  product.id.toString(),
                                                )
                                                ? Colors.black.withValues(
                                                    alpha: 0.5,
                                                  )
                                                : const Color(0xFFE5E7EB),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              selectedProductIds.contains(
                                                    product.id.toString(),
                                                  )
                                                  ? Icons.check_box
                                                  : Icons
                                                        .check_box_outline_blank,
                                              color:
                                                  selectedProductIds.contains(
                                                    product.id.toString(),
                                                  )
                                                  ? AppColors.primary
                                                  : const Color(0xFF9CA3AF),
                                            ),
                                            SizedBox(width: 10.w),
                                            Expanded(
                                              child: Text(
                                                product.title,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight:
                                                      selectedProductIds
                                                          .contains(
                                                            product.id
                                                                .toString(),
                                                          )
                                                      ? FontWeight.w600
                                                      : FontWeight.w400,
                                                  color: const Color(
                                                    0xFF111827,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Done Button
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Done',
                            onPressed: () {
                              Navigator.pop(context);
                              this.setState(() {});
                            },
                            backgroundColor: AppColors.ebonyBlack,
                            textColor: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            borderRadius: 10.r,
                            height: 45.h,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _VerificationDropdown extends StatefulWidget {
  const _VerificationDropdown();

  @override
  State<_VerificationDropdown> createState() => _VerificationDropdownState();
}

class _VerificationDropdownState extends State<_VerificationDropdown> {
  String value = 'review';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.expand_more, size: 22.sp),
          items: const [
            DropdownMenuItem(value: 'review', child: Text('Under Review')),
            DropdownMenuItem(value: 'valid', child: Text('Valid')),
            DropdownMenuItem(value: 'invalid', child: Text('Invalid')),
          ],
          onChanged: (v) {
            if (v == null) return;
            setState(() => value = v);
          },
        ),
      ),
    );
  }
}

// Add-medicine fake field
class _AddMedicineField extends StatelessWidget {
  const _AddMedicineField();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.h,
      padding: EdgeInsets.only(left: 44.w, right: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Select medicine to add...',
              style: TextStyle(fontSize: 14.sp, color: const Color(0xFF4C739A)),
            ),
          ),
          Positioned(
            left: 12.w,
            top: 0,
            bottom: 0,
            child: Icon(
              Icons.search,
              color: const Color(0xFF4C739A),
              size: 20.sp,
            ),
          ),
          Positioned(
            right: 4.w,
            top: 0,
            bottom: 0,
            child: Icon(
              Icons.add_circle,
              color: const Color(0xFF4C739A),
              size: 22.sp,
            ),
          ),
        ],
      ),
    );
  }
}

// Medicine tile
class _MedicineTile extends StatelessWidget {
  final IconData icon;
  final String name;
  final String details;
  final int quantity;

  const _MedicineTile({
    required this.icon,
    required this.name,
    required this.details,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
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
          // Container(
          //   width: 40.w,
          //   height: 40.w,
          //   decoration: BoxDecoration(
          //     color: const Color(0xFFF1F3F5),
          //     borderRadius: BorderRadius.circular(10.r),
          //   ),
          //   child: Icon(icon, color: Colors.grey[600], size: 22.sp),
          // ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  details,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF4C739A),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          //   decoration: BoxDecoration(
          //     color: const Color(0xFFF5F5F5),
          //     borderRadius: BorderRadius.circular(8.r),
          //     border: Border.all(color: Colors.grey.shade300),
          //   ),
          //   child: Text(
          //     'x$quantity',
          //     style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700),
          //   ),
          // ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.delete, color: Colors.red, size: 20.sp),
          ),
        ],
      ),
    );
  }
}
