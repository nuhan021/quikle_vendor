import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import 'package:quikle_vendor/features/order_management/prescription_order_management/models/prescription_model.dart';

import '../../../../appbar/screen/appbar_screen.dart';
import '../../../../../core/common/widgets/custom_button.dart';
import '../../../../product_management/controllers/products_controller.dart';
import '../../controller/prescription_controller.dart';

class PrescriptionDetailsScreen extends StatelessWidget {
  const PrescriptionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) => const _PrescriptionDetailsBody();
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
  final productQuantities = <String, int>{}; // Product ID -> Quantity mapping
  final productBrands = <String, String>{}; // Product ID -> Brand mapping
  final productDosages = <String, String>{}; // Product ID -> Dosage mapping
  final productNotes = <String, String>{}; // Product ID -> Notes mapping

  late final TextEditingController _prescriptionNotesController;

  String?
  _actionInProgress; // 'validating', 'invalidating', 'validated', 'invalidated'

  PrescriptionController get _prescriptionController =>
      Get.find<PrescriptionController>();
  int? get _prescriptionId => Get.arguments?['prescriptionId'] as int?;

  @override
  void initState() {
    super.initState();
    _prescriptionNotesController = TextEditingController();

    if (!Get.isRegistered<PrescriptionController>()) {
      Get.put(PrescriptionController());
    }

    // Defer the fetch until after the build phase completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPrescriptionDetails();
    });
  }

  Future<void> _fetchPrescriptionDetails() async {
    if (_prescriptionId != null) {
      final fetchedPrescription = await _prescriptionController
          .getPrescriptionOrderById(_prescriptionId!);

      // Populate form fields from the fetched prescription data
      if (fetchedPrescription != null) {
        _populateFormFieldsFromVendorResponse(fetchedPrescription);
      }
    }
  }

  void _populateFormFieldsFromVendorResponse(PrescriptionModel prescription) {
    // Check if there's vendor response data
    if (prescription.vendorResponses != null &&
        prescription.vendorResponses!.isNotEmpty) {
      final response = prescription.vendorResponses!.first;

      // Populate prescription notes
      if (prescription.notes != null) {
        _prescriptionNotesController.text = prescription.notes!;
      }

      // Populate selected medicines and their details
      if (response.medicines != null && response.medicines!.isNotEmpty) {
        selectedProductIds.clear();
        selectedProductNames.clear();
        productBrands.clear();
        productDosages.clear();
        productQuantities.clear();
        productNotes.clear();

        for (final medicine in response.medicines!) {
          final itemId =
              medicine.itemId?.toString() ?? medicine.id?.toString() ?? '';
          if (itemId.isNotEmpty) {
            selectedProductIds.add(itemId);
            selectedProductNames.add(
              medicine.name ?? medicine.brand ?? 'Unknown',
            );
            productBrands[itemId] = medicine.brand ?? '';
            productDosages[itemId] = medicine.dosage ?? '';
            productQuantities[itemId] = medicine.quantity ?? 1;
            productNotes[itemId] = medicine.notes ?? '';
          }
        }

        // Trigger UI rebuild
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _prescriptionNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      appBar: const AppbarScreen(title: 'Prescription Details'),
      body: Obx(() {
        if (_prescriptionController.isLoading.value &&
            _prescriptionController.prescriptions.isEmpty) {
          return _buildInitialLoader();
        }

        final prescription = _currentPrescription;
        if (prescription == null) {
          return const SizedBox.shrink();
        }

        final currentStatus = (prescription.status ?? '')
            .toLowerCase()
            .replaceAll(' ', '')
            .replaceAll('_', '');

        return Stack(
          children: [
            ListView(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 96.h),
              children: [
                _buildImageCard(prescription.imagePath),
                SizedBox(height: 24.h),
                _buildStatusButtons(prescription),
                SizedBox(height: 24.h),
                // Bottom content hidden when invalid or medicineready
                if (currentStatus != 'invalid' &&
                    currentStatus != 'medicineready')
                  GetBuilder<PrescriptionController>(
                    builder: (_) => _buildBottomSection(prescription),
                  ),
              ],
            ),
            // Submit button hidden when invalid or medicineready
            GetBuilder<PrescriptionController>(
              builder: (_) {
                final refreshed = _currentPrescription;
                if (refreshed == null) return const SizedBox.shrink();

                final status = (refreshed.status ?? '')
                    .toLowerCase()
                    .replaceAll(' ', '')
                    .replaceAll('_', '');
                if (status == 'invalid' || status == 'medicineready')
                  return const SizedBox.shrink();

                return _buildSubmitButton();
              },
            ),
          ],
        );
      }),
    );
  }

  // Helpers

  Widget _buildInitialLoader() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading prescription data...',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  PrescriptionModel? get _currentPrescription {
    final id = _prescriptionId;
    if (id == null || _prescriptionController.prescriptions.isEmpty) {
      return null;
    }
    return _prescriptionController.prescriptions.firstWhere(
      (p) => p.id == id,
      orElse: () => _prescriptionController.prescriptions.first,
    );
  }

  Widget _buildImageCard(String? imagePath) {
    final imageUrl =
        imagePath ?? 'https://via.placeholder.com/300x400?text=No+Image';

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
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
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
              child: InkWell(onTap: () {}),
            ),
          ),
          // Positioned(
          //   top: 12.h,
          //   left: 12.w,
          //   child: Container(
          //     padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          //     decoration: BoxDecoration(
          //       color: Colors.white.withOpacity(0.9),
          //       borderRadius: BorderRadius.circular(999.r),
          //       border: Border.all(color: Colors.grey.shade300),
          //     ),
          //     child: Text(
          //       '#ORD-8921',
          //       style: TextStyle(
          //         fontSize: 11.sp,
          //         fontWeight: FontWeight.bold,
          //         color: const Color(0xFF137FEC),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildStatusButtons(PrescriptionModel prescription) {
    final rawStatus = prescription.status ?? '';
    final currentStatus = rawStatus
        .toLowerCase()
        .replaceAll(' ', '')
        .replaceAll('_', '');

    // Debug: print to see what status is coming from API
    print(
      '🔍 Prescription Status - Raw: "$rawStatus" | Normalized: "$currentStatus"',
    );

    // Hide buttons if prescription status is medicine ready
    if (currentStatus == 'medicineready' ||
        currentStatus.contains('medicine') && currentStatus.contains('ready')) {
      print('✅ Hiding buttons - Medicine is ready (prescription status)');
      return const SizedBox.shrink();
    }

    if (currentStatus == 'valid') {
      return CustomButton(
        text: 'Validated',
        onPressed: () {},
        height: 48.h,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        borderRadius: 12,
      );
    }

    if (currentStatus == 'invalid') {
      return CustomButton(
        text: 'Invalid',
        onPressed: () {},
        height: 48.h,
        backgroundColor: Colors.white,
        textColor: const Color(0xFFF44336),
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        borderRadius: 12,
        borderColor: const Color(0xFFF44336),
      );
    }

    return StatefulBuilder(
      builder: (context, setButtonState) {
        return Row(
          children: [
            Expanded(
              child: CustomButton(
                text: _actionInProgress == 'invalidating'
                    ? 'Invalidating...'
                    : _actionInProgress == 'invalidated'
                    ? 'Invalidated'
                    : 'Invalid',
                onPressed: () {
                  if (_actionInProgress != null) return;
                  setButtonState(() => _actionInProgress = 'invalidating');

                  _prescriptionController
                      .changePrescriptionStatus(
                        prescription.id ?? 0,
                        'invalid',
                        prescription.userId ?? 0,
                      )
                      .then((_) {
                        setButtonState(() => _actionInProgress = 'invalidated');
                        Future.delayed(
                          const Duration(milliseconds: 500),
                          Get.back,
                        );
                      });
                },
                height: 48.h,
                backgroundColor: _isInvalidActionActive
                    ? const Color(0xFFF44336)
                    : Colors.white,
                textColor: _isInvalidActionActive
                    ? Colors.white
                    : const Color(0xFFF44336),
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                borderRadius: 12,
                borderColor: const Color(0xFFF44336),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: CustomButton(
                text: _actionInProgress == 'validating'
                    ? 'Validating...'
                    : _actionInProgress == 'validated'
                    ? 'Validated'
                    : 'Valid',
                onPressed: () {
                  if (_actionInProgress != null) return;
                  setButtonState(() => _actionInProgress = 'validating');

                  _prescriptionController
                      .changePrescriptionStatus(
                        prescription.id ?? 0,
                        'valid',
                        prescription.userId ?? 0,
                      )
                      .then((_) {
                        setButtonState(() => _actionInProgress = 'validated');
                        Future.delayed(
                          const Duration(milliseconds: 500),
                          Get.back,
                        );
                      });
                },
                height: 48.h,
                backgroundColor: _isValidActionActive
                    ? AppColors.ebonyBlack.withOpacity(0.5)
                    : AppColors.ebonyBlack,
                textColor: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                borderRadius: 12,
              ),
            ),
          ],
        );
      },
    );
  }

  bool get _isInvalidActionActive =>
      _actionInProgress == 'invalidating' || _actionInProgress == 'invalidated';

  bool get _isValidActionActive =>
      _actionInProgress == 'validating' || _actionInProgress == 'validated';

  /// Build the medicine ready section - displays vendor response without editing
  Widget _buildMedicineReadySection(PrescriptionModel prescription) {
    // Use the prescription data that was already fetched in initState
    final details = prescription;

    if (details.vendorResponses == null || details.vendorResponses!.isEmpty) {
      return Center(
        child: Text(
          'Unable to load prescription details',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Vendor Notes
        _buildSectionTitle('Vendor Notes'),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            details.notes ?? 'No notes provided',
            style: TextStyle(fontSize: 13.sp, color: Colors.grey[800]),
          ),
        ),
        SizedBox(height: 24.h),

        // Medicines Response
        _buildSectionTitle('Prescribed Medicines'),
        SizedBox(height: 12.h),
        if (details.vendorResponses != null &&
            details.vendorResponses!.isNotEmpty) ...[
          ...details.vendorResponses!.expand((response) {
            if (response.medicines == null || response.medicines!.isEmpty) {
              return [
                Text(
                  'No medicines provided',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
              ];
            }

            return response.medicines!.map((medicine) {
              return Container(
                padding: EdgeInsets.all(12.w),
                margin: EdgeInsets.only(bottom: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          medicine.brand ?? 'N/A',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Qty: ${medicine.quantity ?? 1}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Dosage: ${medicine.dosage ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                    if (medicine.notes != null &&
                        (medicine.notes as String).isNotEmpty) ...[
                      SizedBox(height: 8.h),
                      Text(
                        'Notes: ${medicine.notes}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }).toList();
          }).toList(),
        ] else
          Text(
            'No medicines provided',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
          ),
      ],
    );
  }

  Widget _buildBottomSection(PrescriptionModel prescription) {
    final currentStatus = (prescription.status ?? '')
        .toLowerCase()
        .replaceAll(' ', '')
        .replaceAll('_', '');
    final isMedicineReady = currentStatus == 'medicineready';
    // Show form fields (either for editing or viewing vendor response)
    final formSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Prescription Notes'),
        SizedBox(height: 8.h),
        _buildNotesField(
          controller: _prescriptionNotesController,
          hint: 'Add notes about the prescription...',
          enabled: !isMedicineReady,
        ),
        SizedBox(height: 24.h),

        if (currentStatus != 'valid' && !isMedicineReady) ...[
          _buildVerificationWarning(),
          SizedBox(height: 24.h),
        ],

        _buildSectionTitle('Select Products'),
        SizedBox(height: 8.h),
        if (isMedicineReady) Container() else _buildProductSelector(),

        if (selectedProductNames.isNotEmpty) ...[
          SizedBox(height: 12.h),
          _buildSelectedProductsList(isMedicineReady),
        ] else
          SizedBox(height: 24.h),
      ],
    );

    // If medicine is ready, show vendor response section below form
    if (isMedicineReady) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          formSection,
          SizedBox(height: 32.h),
          _buildMedicineReadySection(prescription),
        ],
      );
    }

    return formSection;
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildNotesField({
    required TextEditingController controller,
    required String hint,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: AppColors.ebonyBlack, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: AppColors.ebonyBlack, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: AppColors.ebonyBlack, width: 1.5),
        ),
        contentPadding: EdgeInsets.all(12.w),
      ),
    );
  }

  Widget _buildVerificationWarning() {
    return Container(
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
              style: TextStyle(fontSize: 14.sp, color: AppColors.ebonyBlack),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductSelector() {
    return GestureDetector(
      onTap: () => _showProductSelectionDialog(context),
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
            const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9CA3AF)),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedProductsList([bool isReadOnly = false]) {
    return Column(
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
                  // Product name
                  Expanded(
                    flex: 1,
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // Minus button
                  GestureDetector(
                    onTap: isReadOnly
                        ? null
                        : () {
                            setState(() {
                              final productId = selectedProductIds[index];
                              final currentQty =
                                  productQuantities[productId] ?? 1;
                              if (currentQty > 1) {
                                productQuantities[productId] = currentQty - 1;
                              }
                            });
                          },
                    child: Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        color: isReadOnly ? Colors.grey : AppColors.primary,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  // Quantity input field
                  SizedBox(
                    width: 50.w,
                    child: TextField(
                      enabled: !isReadOnly,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        setState(() {
                          final productId = selectedProductIds[index];
                          final qty = int.tryParse(value) ?? 1;
                          productQuantities[productId] = qty > 0 ? qty : 1;
                        });
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
                        text:
                            (productQuantities[selectedProductIds[index]] ?? 1)
                                .toString(),
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  // Plus button
                  GestureDetector(
                    onTap: isReadOnly
                        ? null
                        : () {
                            setState(() {
                              final productId = selectedProductIds[index];
                              final currentQty =
                                  productQuantities[productId] ?? 1;
                              productQuantities[productId] = currentQty + 1;
                            });
                          },
                    child: Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        color: isReadOnly ? Colors.grey : AppColors.primary,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 16.sp),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // Delete button
                  IconButton(
                    onPressed: isReadOnly
                        ? null
                        : () {
                            setState(() {
                              final productId = selectedProductIds[index];
                              selectedProductNames.remove(name);
                              if (selectedProductIds.length > index) {
                                selectedProductIds.removeAt(index);
                              } else {
                                selectedProductIds.remove(productId);
                              }
                              // Also remove related data
                              productQuantities.remove(productId);
                              productBrands.remove(productId);
                              productDosages.remove(productId);
                              productNotes.remove(productId);
                            });
                          },
                    icon: Icon(
                      Icons.delete,
                      color: isReadOnly ? Colors.grey : Colors.red,
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
            ),
            // Brand, Dosage, and Notes fields
            SizedBox(height: 10.h),
            Row(
              children: [
                SizedBox(width: 10.w),
                // Brand field
                Expanded(
                  child: TextField(
                    enabled: !isReadOnly,
                    controller: TextEditingController(
                      text: productBrands[selectedProductIds[index]] ?? '',
                    ),
                    onChanged: (value) {
                      setState(() {
                        productBrands[selectedProductIds[index]] = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Brand',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.r),
                        borderSide: const BorderSide(
                          color: Color(0xFFE5E7EB),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.r),
                        borderSide: const BorderSide(
                          color: Color(0xFFE5E7EB),
                          width: 1,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 8.h,
                      ),
                      hintStyle: TextStyle(fontSize: 12.sp),
                    ),
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
                SizedBox(width: 8.w),
                // Dosage field
                Expanded(
                  child: TextField(
                    enabled: !isReadOnly,
                    controller: TextEditingController(
                      text: productDosages[selectedProductIds[index]] ?? '',
                    ),
                    onChanged: (value) {
                      setState(() {
                        productDosages[selectedProductIds[index]] = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Dosage',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.r),
                        borderSide: const BorderSide(
                          color: Color(0xFFE5E7EB),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.r),
                        borderSide: const BorderSide(
                          color: Color(0xFFE5E7EB),
                          width: 1,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 8.h,
                      ),
                      hintStyle: TextStyle(fontSize: 12.sp),
                    ),
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
                SizedBox(width: 10.w),
              ],
            ),
            SizedBox(height: 8.h),
            // Medicine notes field
            Row(
              children: [
                SizedBox(width: 10.w),
                Expanded(
                  child: TextField(
                    enabled: !isReadOnly,
                    controller: TextEditingController(
                      text: productNotes[selectedProductIds[index]] ?? '',
                    ),
                    onChanged: (value) {
                      setState(() {
                        productNotes[selectedProductIds[index]] = value;
                      });
                    },
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Notes for this medicine',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.r),
                        borderSide: const BorderSide(
                          color: Color(0xFFE5E7EB),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.r),
                        borderSide: const BorderSide(
                          color: Color(0xFFE5E7EB),
                          width: 1,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 8.h,
                      ),
                      hintStyle: TextStyle(fontSize: 12.sp),
                    ),
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
                SizedBox(width: 10.w),
              ],
            ),
            if (index < selectedProductNames.length - 1) SizedBox(height: 12.h),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSubmitButton() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: GetBuilder<PrescriptionController>(
        builder: (controller) {
          final prescriptionId = Get.arguments?['prescriptionId'] as int?;
          if (prescriptionId == null || controller.prescriptions.isEmpty) {
            return const SizedBox.shrink();
          }

          final prescription = controller.prescriptions.firstWhere(
            (p) => p.id == prescriptionId,
            orElse: () => controller.prescriptions.first,
          );

          final currentStatus = (prescription.status?.toLowerCase() ?? '')
              .replaceAll(' ', '')
              .replaceAll('_', '');
          final isMedicineReady = currentStatus == 'medicineready';
          final isInvalid = currentStatus == 'invalid';

          // Hide submit button if prescription is invalid or medicineReady
          if (isInvalid || isMedicineReady) {
            return const SizedBox.shrink();
          }

          return Container(
            color: const Color(0xFFF6F7F8),
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
            child: CustomButton(
              text: isMedicineReady ? 'Submitted' : 'Submit Response',
              onPressed: isMedicineReady
                  ? () {}
                  : () async {
                      // Validate that at least one medicine is selected
                      if (selectedProductIds.isEmpty) {
                        Get.snackbar(
                          'Validation Error',
                          'Please select at least one medicine',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }

                      // Build medicines list with all required data
                      final medicines = <Map<String, dynamic>>[];
                      for (int i = 0; i < selectedProductIds.length; i++) {
                        final productId = selectedProductIds[i];
                        medicines.add({
                          'item_id': int.tryParse(productId) ?? 0,
                          'brand': productBrands[productId] ?? '',
                          'dosage': productDosages[productId] ?? '',
                          'quantity': productQuantities[productId] ?? 1,
                          'notes': productNotes[productId] ?? '',
                        });
                      }

                      // Submit vendor response
                      final success = await _prescriptionController
                          .submitVendorResponse(
                            prescriptionId: prescriptionId,
                            medicines: medicines,
                            prescriptionNotes:
                                _prescriptionNotesController.text,
                          );

                      if (success) {
                        // Clear form and go back
                        Future.delayed(const Duration(milliseconds: 800), () {
                          Get.back();
                        });
                      }
                    },
              height: 48.h,
              borderRadius: 14,
              backgroundColor: isMedicineReady
                  ? Colors.grey
                  : AppColors.primary,
              textColor: Colors.white,
              fontSize: 14.sp,
            ),
          );
        },
      ),
    );
  }

  void _showProductSelectionDialog(BuildContext context) {
    final productsController = Get.find<ProductsController>();
    String tempSearchText = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
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
                    TextField(
                      onChanged: (value) =>
                          setDialogState(() => tempSearchText = value),
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        border: _dialogBorder,
                        enabledBorder: _dialogBorder,
                        focusedBorder: _dialogBorder,
                        prefixIcon: const Icon(Icons.search),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 10.h,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Expanded(
                      child: filtered.isEmpty
                          ? Center(
                              child: Text(
                                'No products found',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF9CA3AF),
                                ),
                              ),
                            )
                          : ListView(
                              children: filtered.map((product) {
                                final productId = product.id.toString();
                                final productName = product.title;
                                final isSelected = selectedProductIds.contains(
                                  productId,
                                );

                                return GestureDetector(
                                  onTap: () {
                                    if (isSelected) {
                                      selectedProductIds.remove(productId);
                                      selectedProductNames.remove(productName);
                                    } else {
                                      selectedProductIds.add(productId);
                                      selectedProductNames.add(productName);
                                    }
                                    setDialogState(() {});
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12.h,
                                      horizontal: 12.w,
                                    ),
                                    margin: EdgeInsets.only(bottom: 4.h),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(6.r),
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.black.withValues(
                                                alpha: 0.5,
                                              )
                                            : const Color(0xFFE5E7EB),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          isSelected
                                              ? Icons.check_box
                                              : Icons.check_box_outline_blank,
                                          color: isSelected
                                              ? AppColors.primary
                                              : const Color(0xFF9CA3AF),
                                        ),
                                        SizedBox(width: 10.w),
                                        Expanded(
                                          child: Text(
                                            productName,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w400,
                                              color: const Color(0xFF111827),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                    ),
                    SizedBox(height: 12.h),
                    CustomButton(
                      text: 'Done',
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {});
                      },
                      backgroundColor: AppColors.ebonyBlack,
                      textColor: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      borderRadius: 10.r,
                      height: 45.h,
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

  OutlineInputBorder get _dialogBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.r),
    borderSide: const BorderSide(color: AppColors.ebonyBlack, width: 1),
  );
}
