import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/routes/app_routes.dart';

class OrderManagementController extends GetxController {
  var tabs = ["New", "Accepted", "In Progress", "Completed"];
  var selectedTab = 0.obs;

  var allOrders = [
    // New Orders
    {
      'id': '#5679',
      'customerName': 'Sarah Johnson',
      'timeAgo': '10 mins ago',
      'deliveryTime': 'Delivery in 30 min',
      'estimatedDelivery': '30-45 minutes',
      'address': '456 Oak Ave, Downtown',
      'status': 'new',
      'tags': ['New', 'Urgent'],
      'isUrgent': true,
      'requiresPrescription': false,
      'items': [
        {
          'name': 'Pad Thai Chicken X 1',
          'description': 'Medium spicy, no peanuts',
          'price': 24.99,
          'image': 'assets/images/pad_thai.png',
        },
        {
          'name': 'Spring Rolls X 2',
          'description': 'Vegetarian',
          'price': 39.98,
          'image': 'assets/images/spring_roll.png',
        },
      ],
      'total': 24.00,
      'specialInstructions':
          'Please call when outside. Leave package at the door. The doorbell doesn\'t work.',
    },
    {
      'id': '#12346',
      'customerName': 'John Smith',
      'timeAgo': '15 mins ago',
      'deliveryTime': 'Delivery in 15 min',
      'estimatedDelivery': '30-45 minutes',
      'address': '456 Oak Ave, Downtown',
      'status': 'new',
      'tags': ['New', 'Urgent', 'Prescription'],
      'isUrgent': true,
      'requiresPrescription': true,
      'items': [
        {
          'name': 'Azithromycin 250mg X 1',
          'description': 'Prescription medication',
          'price': 24.99,
          'image': '/placeholder.svg?height=60&width=60',
        },
        {
          'name': 'Paracetamol 500mg X 2',
          'description': 'Pain relief',
          'price': 39.98,
          'image': '/placeholder.svg?height=60&width=60',
        },
      ],
      'total': 24.00,
      'specialInstructions':
          'Please call when outside. Leave package at the door. The doorbell doesn\'t work.',
    },
    // Accepted Orders
    {
      'id': '#1325',
      'customerName': 'John Smith',
      'timeAgo': '25 mins ago',
      'deliveryTime': 'Delivery in 15 min',
      'estimatedDelivery': '15-20 minutes',
      'address': '123 Main St, City Center',
      'status': 'accepted',
      'tags': ['Accepted'],
      'isUrgent': false,
      'requiresPrescription': false,
      'items': [
        {
          'name': 'Burger Combo X 1',
          'description': 'With fries and drink',
          'price': 15.99,
          'image': '/placeholder.svg?height=60&width=60',
        },
      ],
      'total': 15.99,
      'specialInstructions': 'Ring doorbell twice',
    },
    // In Progress Orders
    {
      'id': '#1327',
      'customerName': 'Emma Davis',
      'timeAgo': '40 mins ago',
      'deliveryTime': 'Delivery in 5 min',
      'estimatedDelivery': '5-10 minutes',
      'address': '789 Pine St, Uptown',
      'status': 'in-progress',
      'tags': ['In Progress'],
      'isUrgent': false,
      'requiresPrescription': false,
      'items': [
        {
          'name': 'Pizza Margherita X 1',
          'description': 'Large size, extra cheese',
          'price': 18.50,
          'image': '/placeholder.svg?height=60&width=60',
        },
      ],
      'total': 18.50,
      'specialInstructions': 'Leave at front door',
    },
    // Completed Orders
    {
      'id': '#13275',
      'customerName': 'Michael Brown',
      'timeAgo': '40 mins ago',
      'deliveryTime': 'Delivered at 2:30 PM',
      'estimatedDelivery': 'Delivered',
      'address': '321 Elm St, Suburb',
      'status': 'completed',
      'tags': ['Completed'],
      'isUrgent': false,
      'requiresPrescription': false,
      'items': [
        {
          'name': 'Sushi Platter X 1',
          'description': 'Mixed sushi, 12 pieces',
          'price': 32.00,
          'image': '/placeholder.svg?height=60&width=60',
        },
      ],
      'total': 32.00,
      'specialInstructions': 'Call upon arrival',
    },
  ].obs;

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void navigateToOrderDetails(String orderId) {
    Get.toNamed(AppRoute.orderDetailsScreen, arguments: orderId);
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
    navigateToOrderDetails(orderId);
  }

  void viewPrescription(String orderId) {
    Get.snackbar(
      'View Prescription',
      'Opening prescription for order $orderId',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF6366F1),
      colorText: Colors.white,
    );
  }

  Map<String, dynamic>? getOrderById(String orderId) {
    try {
      return allOrders.firstWhere((order) => order['id'] == orderId);
    } catch (e) {
      return null;
    }
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
