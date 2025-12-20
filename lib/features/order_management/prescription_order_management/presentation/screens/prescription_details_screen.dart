import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quikle_vendor/features/order_management/prescription_order_management/models/prescription_model.dart';

import '../../../../appbar/screen/appbar_screen.dart';
import '../../../../../core/common/widgets/custom_button.dart';
import '../../controller/prescription_controller.dart';
import '../widget/common_widgets.dart';
import '../widget/medicine_ready_section.dart';
import '../widget/prescription_image_card.dart';
import '../widget/prescription_status_buttons.dart';
import '../widget/product_form_fields.dart';
import '../widget/product_selection_dialog.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';

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
  final productQuantities = <String, int>{};
  final productBrands = <String, String>{};
  final productDosages = <String, String>{};
  final productNotes = <String, String>{};

  late final TextEditingController _prescriptionNotesController;
  bool _isSubmitting = false;
  bool _isSubmitted = false;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPrescriptionDetails();
    });
  }

  Future<void> _fetchPrescriptionDetails() async {
    if (_prescriptionId != null) {
      final fetchedPrescription = await _prescriptionController
          .getPrescriptionOrderById(_prescriptionId!);

      if (fetchedPrescription != null) {
        _populateFormFieldsFromVendorResponse(fetchedPrescription);
      }
    }
  }

  void _populateFormFieldsFromVendorResponse(PrescriptionModel prescription) {
    if (prescription.vendorResponses != null &&
        prescription.vendorResponses!.isNotEmpty) {
      final response = prescription.vendorResponses!.first;

      if (prescription.notes != null) {
        _prescriptionNotesController.text = prescription.notes!;
      }

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
          return const InitialLoader();
        }

        final prescription = _currentPrescription;
        if (prescription == null) {
          return const SizedBox.shrink();
        }
        final isInvalidStatus =
            (prescription.status ?? '').toLowerCase() == 'invalid';

        final textTheme = Theme.of(context).textTheme;

        return DefaultTextStyle(
          style: GoogleFonts.poppins(
            textStyle: textTheme.bodyMedium ?? const TextStyle(),
          ),
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: _fetchPrescriptionDetails,
                backgroundColor: Colors.white,
                color: Colors.amber,
                displacement:
                    kToolbarHeight + MediaQuery.of(context).padding.top + 8.0,
                child: ListView(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 96.h),
                  children: [
                    PrescriptionImageCard(imagePath: prescription.imagePath),
                    SizedBox(height: 24.h),
                    PrescriptionStatusButtons(prescription: prescription),
                    SizedBox(height: 24.h),
                    if (!isInvalidStatus)
                      GetBuilder<PrescriptionController>(
                        builder: (_) => _buildBottomSection(prescription),
                      ),
                  ],
                ),
              ),
              GetBuilder<PrescriptionController>(
                builder: (_) {
                  final refreshed = _currentPrescription;
                  if (refreshed == null) return const SizedBox.shrink();

                  final isInvalid =
                      (refreshed.status ?? '').toLowerCase() == 'invalid';
                  final isMedReady = _isMedicineReadyStatus(refreshed.status);
                  if (isInvalid || isMedReady || _isSubmitted) {
                    return const SizedBox.shrink();
                  }

                  final isDisabled = _isSubmitting;

                  return Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      color: const Color(0xFFF6F7F8),
                      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                      child: CustomButton(
                        text: _isSubmitting
                            ? 'Submitting...'
                            : 'Submit Response',
                        onPressed: isDisabled ? () {} : () => _submitResponse(),
                        height: 48.h,
                        borderRadius: 14,
                        backgroundColor: isDisabled
                            ? Colors.grey
                            : AppColors.ebonyBlack,
                        textColor: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }),
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

  bool _isMedicineReadyStatus(String? status) {
    final normalized = (status ?? '')
        .toLowerCase()
        .replaceAll(' ', '')
        .replaceAll('_', '');
    return normalized == 'medicineready' || normalized == 'medicinesready';
  }

  Widget _buildBottomSection(PrescriptionModel prescription) {
    final isMedicineReady = _isMedicineReadyStatus(prescription.status);
    final normalizedStatus = (prescription.status ?? '')
        .toLowerCase()
        .replaceAll(' ', '')
        .replaceAll('_', '');

    final formSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle('Prescription Notes'),
        SizedBox(height: 8.h),
        PrescriptionNotesField(
          controller: _prescriptionNotesController,
          hint: 'Add notes about the prescription...',
          enabled: !isMedicineReady,
        ),
        SizedBox(height: 24.h),
        if (normalizedStatus != 'valid' && !isMedicineReady) ...[
          const VerificationWarning(),
          SizedBox(height: 24.h),
        ],
        SectionTitle('Select Products'),
        SizedBox(height: 8.h),
        ProductFormFields(
          selectedProductIds: selectedProductIds,
          selectedProductNames: selectedProductNames,
          productQuantities: productQuantities,
          productBrands: productBrands,
          productDosages: productDosages,
          productNotes: productNotes,
          isMedicineReady: isMedicineReady,
          onProductSelectorTap: () => showProductSelectionDialog(
            context,
            selectedProductIds,
            selectedProductNames,
            () => setState(() {}),
          ),
          onQuantityChange: (index, qty) => setState(() {
            final productId = selectedProductIds[index];
            productQuantities[productId] = qty;
          }),
          onBrandChange: (index, value) => setState(() {
            productBrands[selectedProductIds[index]] = value;
          }),
          onDosageChange: (index, value) => setState(() {
            productDosages[selectedProductIds[index]] = value;
          }),
          onNotesChange: (index, value) => setState(() {
            productNotes[selectedProductIds[index]] = value;
          }),
          onDeleteProduct: (index) => setState(() {
            final productId = selectedProductIds[index];
            selectedProductNames.removeAt(index);
            selectedProductIds.removeAt(index);
            productQuantities.remove(productId);
            productBrands.remove(productId);
            productDosages.remove(productId);
            productNotes.remove(productId);
          }),
        ),
      ],
    );

    if (isMedicineReady) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          formSection,
          SizedBox(height: 32.h),
          MedicineReadySection(prescription: prescription),
        ],
      );
    }

    return formSection;
  }

  Future<void> _submitResponse() async {
    if (selectedProductIds.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please select at least one medicine',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final prescriptionId = Get.arguments?['prescriptionId'] as int?;
    if (prescriptionId == null) {
      setState(() => _isSubmitting = false);
      return;
    }

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

    final success = await _prescriptionController.submitVendorResponse(
      prescriptionId: prescriptionId,
      medicines: medicines,
      prescriptionNotes: _prescriptionNotesController.text,
    );

    if (success) {
      setState(() {
        _isSubmitting = false;
        _isSubmitted = true;
      });
      Future.delayed(const Duration(milliseconds: 800), () {
        // Refresh the prescriptions list before going back
        _prescriptionController.loadPrescriptions();
        Get.back();
      });
    } else {
      setState(() => _isSubmitting = false);
    }
  }
}
