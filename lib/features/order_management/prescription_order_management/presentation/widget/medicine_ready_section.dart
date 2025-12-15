import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_vendor/features/order_management/prescription_order_management/models/prescription_model.dart';

class MedicineReadySection extends StatelessWidget {
  final PrescriptionModel prescription;

  const MedicineReadySection({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
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
}
