import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderManagementController extends GetxController {
  var tabs = ["New", "Accepted", "In Progress", "Completed"];
  var selectedTab = 0.obs;

  // Orders Data
  var orders = [
    {
      'id': '#5679',
      'customerName': 'Sarah Johnson',
      'timeAgo': '10 mins ago',
      'deliveryTime': 'Delivery in 30 min',
      'status': 'new',
      'tags': ['New', 'Urgent'],
      'isUrgent': true,
      'requiresPrescription': false,
    },
    {
      'id': '#5679',
      'customerName': 'Sarah Johnson',
      'timeAgo': '10 mins ago',
      'deliveryTime': 'Delivery in 30 min',
      'status': 'new',
      'tags': ['New', 'Urgent'],
      'isUrgent': true,
      'requiresPrescription': false,
    },
    {
      'id': '#5679',
      'customerName': 'Sarah Johnson',
      'timeAgo': '10 mins ago',
      'deliveryTime': 'Delivery in 30 min',
      'status': 'new',
      'tags': ['New', 'Urgent', 'Prescription Required'],
      'isUrgent': true,
      'requiresPrescription': true,
    },
  ].obs;

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void acceptOrder(String orderId) {
    Get.snackbar(
      'Order Accepted',
      'Order $orderId has been accepted',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF10B981),
      colorText: Colors.white,
    );
  }

  void rejectOrder(String orderId) {
    Get.snackbar(
      'Order Rejected',
      'Order $orderId has been rejected',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFFEF4444),
      colorText: Colors.white,
    );
  }

  void reviewOrder(String orderId) {
    Get.snackbar(
      'Order Review',
      'Reviewing order $orderId for prescription',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF6366F1),
      colorText: Colors.white,
    );
  }

  List<Map<String, dynamic>> get filteredOrders {
    String currentStatus = tabs[selectedTab.value].toLowerCase().replaceAll(
      ' ',
      '-',
    );
    if (currentStatus == 'new') {
      return orders.where((order) => order['status'] == 'new').toList();
    }
    return orders.where((order) => order['status'] == currentStatus).toList();
  }
}
