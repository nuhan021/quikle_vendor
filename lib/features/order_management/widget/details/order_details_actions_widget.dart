import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/services/storage_service.dart';
import '../../../vendor/models/vendor_model.dart';
import '../../controller/order_management_controller.dart';

class OrderDetailsActionsWidget extends StatelessWidget {
  final String orderId;
  final String status;
  final bool requiresPrescription;
  final Function(String)? onConfirm;
  final Function(String)? onReject;
  final Function(String)? onReview;
  final Function(String)? onPrepared;
  final Function(String)? onDispatched;
  final Function(String)? onViewPrescription;

  const OrderDetailsActionsWidget({
    super.key,
    required this.orderId,
    required this.status,
    required this.requiresPrescription,
    this.onConfirm,
    this.onReject,
    this.onReview,
    this.onPrepared,
    this.onDispatched,
    this.onViewPrescription,
  });

  @override
  Widget build(BuildContext context) {
    // Check if vendor type is medicine
    final vendorData = StorageService.getVendorDetails();
    final vendorDetails = vendorData != null
        ? VendorDetailsModel.fromJson(vendorData)
        : null;
    final isMedicineVendor = vendorDetails?.type == 'medicine';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Show View Prescription button for medicine vendors
          if (isMedicineVendor) ...[
            CustomButton(
              text: 'View Prescription',
              onPressed: () => onViewPrescription?.call(orderId),
              backgroundColor: AppColors.backgroundLight,
              textColor: AppColors.backgroundDark,
              borderColor: AppColors.textSecondary,
            ),
            const SizedBox(height: 10),
          ],

          if (requiresPrescription) ...[
            CustomButton(
              text: 'View Prescription',
              onPressed: () => onViewPrescription?.call(orderId),
              backgroundColor: AppColors.backgroundLight,
              textColor: AppColors.backgroundDark,
              borderColor: AppColors.textSecondary,
            ),
            const SizedBox(height: 10),
          ],

          if (status == 'new') ...[
            if (requiresPrescription)
              CustomButton(
                text: 'Review',
                onPressed: () => onReview?.call(orderId),
              )
            else
              Obx(() {
                final controller = Get.find<OrderManagementController>();
                final isConfirmed = controller.confirmedOrders.contains(
                  orderId,
                );
                return isConfirmed
                    ? CustomButton(
                        text: 'Confirmed',
                        onPressed: () {},
                        backgroundColor: const Color(0xFFD1D5DB),
                        textColor: Colors.black54,
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'Cancel',
                              onPressed: () => onReject?.call(orderId),
                              backgroundColor: Colors.white,
                              textColor: AppColors.error,
                              borderColor: AppColors.error,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomButton(
                              text: 'Confirm',
                              onPressed: () {
                                controller.confirmedOrders.add(orderId);
                                onConfirm?.call(orderId);
                              },
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                            ),
                          ),
                        ],
                      );
              }),
          ] else if (status == 'confirmed')
            Obx(() {
              final controller = Get.find<OrderManagementController>();
              final isDisabled = controller.disabledButtons.contains(orderId);
              return CustomButton(
                text: 'Mark as Prepared',
                onPressed: isDisabled ? () {} : () => onPrepared?.call(orderId),
                backgroundColor: isDisabled
                    ? const Color(0xFFD1D5DB)
                    : Colors.black,
                textColor: Colors.white,
              );
            })
          else if (status == 'in-progress')
            Obx(() {
              final controller = Get.find<OrderManagementController>();
              final isDisabled = controller.disabledButtons.contains(orderId);
              return CustomButton(
                text: isDisabled ? 'Dispatched...' : 'Mark as Dispatched',
                onPressed: isDisabled
                    ? () {}
                    : () {
                        controller.disabledButtons.add(orderId);
                        onDispatched?.call(orderId);
                      },
                backgroundColor: isDisabled
                    ? const Color(0xFFD1D5DB)
                    : Colors.black,
                textColor: isDisabled ? Colors.black54 : Colors.white,
              );
            }),
        ],
      ),
    );
  }
}
