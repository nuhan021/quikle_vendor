import 'package:flutter/material.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/utils/constants/colors.dart';

class OrderDetailsActionsWidget extends StatelessWidget {
  final String orderId;
  final String status;
  final bool requiresPrescription;
  final Function(String)? onAccept;
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
    this.onAccept,
    this.onReject,
    this.onReview,
    this.onPrepared,
    this.onDispatched,
    this.onViewPrescription,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
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
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Reject',
                      onPressed: () => onReject?.call(orderId),
                      backgroundColor: Colors.white,
                      textColor: AppColors.error,
                      borderColor: AppColors.error,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: 'Accept',
                      onPressed: () => onAccept?.call(orderId),
                    ),
                  ),
                ],
              ),
          ] else if (status == 'accepted')
            CustomButton(
              text: 'Mark as Prepared',
              onPressed: () => onPrepared?.call(orderId),
            )
          else if (status == 'in-progress')
            CustomButton(
              text: 'Mark as Dispatched',
              onPressed: () => onDispatched?.call(orderId),
            ),
        ],
      ),
    );
  }
}
