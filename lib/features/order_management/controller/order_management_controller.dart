import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderManagementController extends GetxController {
  var tabs = ["New", "Accepted", "In Progress", "Completed"];
  var selectedTab = 0.obs;

  // All Orders Data with different states
  var allOrders = [
    // New Orders
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
      'id': '#5680',
      'customerName': 'Sarah Johnson',
      'timeAgo': '10 mins ago',
      'deliveryTime': 'Delivery in 30 min',
      'status': 'new',
      'tags': ['New', 'Urgent'],
      'isUrgent': true,
      'requiresPrescription': false,
    },
    {
      'id': '#5681',
      'customerName': 'Sarah Johnson',
      'timeAgo': '10 mins ago',
      'deliveryTime': 'Delivery in 30 min',
      'status': 'new',
      'tags': ['New', 'Urgent', 'Prescription Required'],
      'isUrgent': true,
      'requiresPrescription': true,
    },
    // Accepted Orders
    {
      'id': '#1325',
      'customerName': 'John Smith',
      'timeAgo': '25 mins ago',
      'deliveryTime': 'Delivery in 15 min',
      'status': 'accepted',
      'tags': ['Accepted'],
      'isUrgent': false,
      'requiresPrescription': false,
    },
    {
      'id': '#1326',
      'customerName': 'Alice Johnson',
      'timeAgo': '30 mins ago',
      'deliveryTime': 'Delivery in 20 min',
      'status': 'accepted',
      'tags': ['Accepted'],
      'isUrgent': false,
      'requiresPrescription': false,
    },
    // In Progress Orders
    {
      'id': '#1325',
      'customerName': 'Emma Davis',
      'timeAgo': '40 mins ago',
      'deliveryTime': 'Delivery in 5 min',
      'status': 'in-progress',
      'tags': ['In Progress'],
      'isUrgent': false,
      'requiresPrescription': false,
    },
    {
      'id': '#1327',
      'customerName': 'Robert Wilson',
      'timeAgo': '45 mins ago',
      'deliveryTime': 'Delivery in 8 min',
      'status': 'in-progress',
      'tags': ['In Progress'],
      'isUrgent': false,
      'requiresPrescription': false,
    },
    // Completed Orders
    {
      'id': '#13275',
      'customerName': 'Michael Brown',
      'timeAgo': '40 mins ago',
      'deliveryTime': 'Delivered at 2:30 PM',
      'status': 'completed',
      'tags': ['Completed'],
      'isUrgent': false,
      'requiresPrescription': false,
    },
    {
      'id': '#13276',
      'customerName': 'Lisa Anderson',
      'timeAgo': '1 hour ago',
      'deliveryTime': 'Delivered at 1:45 PM',
      'status': 'completed',
      'tags': ['Completed'],
      'isUrgent': false,
      'requiresPrescription': false,
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

  void markAsPrepared(String orderId) {
    Get.snackbar(
      'Order Prepared',
      'Order $orderId marked as prepared',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF10B981),
      colorText: Colors.white,
    );
  }

  void markAsDispatched(String orderId) {
    Get.snackbar(
      'Order Dispatched',
      'Order $orderId marked as dispatched',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF10B981),
      colorText: Colors.white,
    );
  }

  void viewDetails(String orderId) {
    Get.snackbar(
      'Order Details',
      'Viewing details for order $orderId',
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
    return allOrders
        .where((order) => order['status'] == currentStatus)
        .toList();
  }
}
