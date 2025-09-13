import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/rider_assignment_controller.dart';
import 'find_rider_initial_dialog.dart';
import 'find_rider_loading_dialog.dart';
import 'rider_assigned_success_dialog.dart';
import 'select_rider_dialog.dart';

class RiderAssignmentDialogsWidget extends StatelessWidget {
  RiderAssignmentDialogsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RiderAssignmentController>();

    return Obx(() {
      switch (controller.currentDialogState.value) {
        case 'initial':
          return FindRiderInitialDialog();
        case 'loading':
          return FindRiderLoadingDialog();
        case 'selection':
          return SelectRiderDialog();
        case 'success':
          return RiderAssignedSuccessDialog();
        default:
          return Container();
      }
    });
  }
}
