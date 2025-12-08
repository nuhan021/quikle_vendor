import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RiderAssignmentController extends GetxController {
  var currentDialogState = ''.obs; // initial, loading, selection, success
  var selectedRiderId = ''.obs;
  var orderId = '#12344'.obs;
  var assignedRiderName = ''.obs;

  // Available riders data
  var availableRiders = [
    {
      'id': '1',
      'name': 'Sarah Lee',
      'status': 'Available',
      'distance': '3 min away (0.8 miles)',
    },
    {
      'id': '2',
      'name': 'John Doe',
      'status': 'Available',
      'distance': '5 min away (1.2 miles)',
    },
  ].obs;

  void showInitialDialog() {
    currentDialogState.value = 'initial';
  }

  void findRiders() {
    currentDialogState.value = 'loading';

    // Simulate API call
    Future.delayed(Duration(seconds: 2), () {
      currentDialogState.value = 'selection';
    });
  }

  void selectRider(String riderId) {
    selectedRiderId.value = riderId;
  }

  void confirmAssignment() {
    if (selectedRiderId.value.isNotEmpty) {
      var selectedRider = availableRiders.firstWhere(
        (rider) => rider['id'] == selectedRiderId.value,
      );
      assignedRiderName.value = selectedRider['name']!;
      currentDialogState.value = 'success';
    }
  }

  void cancelDialog() {
    currentDialogState.value = '';
    selectedRiderId.value = '';
    assignedRiderName.value = '';
  }

  void completeAssignment() {
    cancelDialog();
  }
}
