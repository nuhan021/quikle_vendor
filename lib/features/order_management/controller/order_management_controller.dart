import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/routes/app_routes.dart';

class OrderManagementController extends GetxController {
  /// -------------------- Tabs --------------------
  final tabs = ["New", "Accepted", "In Progress", "Completed"];
  final selectedTab = 0.obs;

  /// -------------------- Orders (Mock Data) --------------------
  final allOrders = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  /// -------------------- Fetch Orders --------------------
  Future<void> fetchOrders() async {
    await Future.delayed(const Duration(milliseconds: 800)); // mock delay

    allOrders.assignAll([
      {
        'id': '#5679',
        'customerName': 'Sarah Johnson',
        'timeAgo': '10 mins ago',
        'deliveryTime': 'Delivery in 30 min',
        'address': '456 Oak Ave, Downtown',
        'status': 'new',
        'tags': ['New', 'Urgent'],
        'isUrgent': true,
        'requiresPrescription': false,
        'estimatedDelivery': '2:45 PM',
        'items': [
          {
            'name': 'Paracetamol',
            'description': '500mg tablets',
            'quantity': 2,
            'price': 5.99,
            'image': 'assets/images/medicine.png',
          },
          {
            'name': 'Vitamin C',
            'description': '1000mg',
            'quantity': 1,
            'price': 8.99,
            'image': 'assets/images/medicine.png',
          },
        ],
        'total': 14.98,
        'specialInstructions': 'Please deliver during office hours',
      },
      {
        'id': '#1325',
        'customerName': 'John Smith',
        'timeAgo': '25 mins ago',
        'deliveryTime': 'Delivery in 15 min',
        'address': '123 Main St, City Center',
        'status': 'accepted',
        'tags': ['Accepted'],
        'isUrgent': false,
        'requiresPrescription': false,
        'estimatedDelivery': '2:30 PM',
        'items': [
          {
            'name': 'Cough Syrup',
            'description': '100ml bottle',
            'quantity': 1,
            'price': 7.50,
            'image': 'assets/images/medicine.png',
          },
        ],
        'total': 7.50,
        'specialInstructions': 'Leave at door if not home',
      },
      {
        'id': '#1327',
        'customerName': 'Emma Davis',
        'timeAgo': '40 mins ago',
        'deliveryTime': 'Delivery in 5 min',
        'address': '789 Pine St, Uptown',
        'status': 'in-progress',
        'tags': ['In Progress'],
        'isUrgent': false,
        'requiresPrescription': false,
        'estimatedDelivery': '2:15 PM',
        'items': [
          {
            'name': 'Antibiotic Cream',
            'description': '50g tube',
            'quantity': 2,
            'price': 6.99,
            'image': 'assets/images/medicine.png',
          },
        ],
        'total': 13.98,
        'specialInstructions': 'Call before delivery',
      },
      {
        'id': '#13275',
        'customerName': 'Michael Brown',
        'timeAgo': '40 mins ago',
        'deliveryTime': 'Delivered at 2:30 PM',
        'address': '321 Elm St, Suburb',
        'status': 'completed',
        'tags': ['Completed'],
        'isUrgent': false,
        'requiresPrescription': false,
        'estimatedDelivery': '2:30 PM',
        'items': [
          {
            'name': 'Pain Relief Tablets',
            'description': '200mg',
            'quantity': 1,
            'price': 4.99,
            'image': 'assets/images/medicine.png',
          },
          {
            'name': 'Multivitamins',
            'description': 'Daily supplement',
            'quantity': 1,
            'price': 12.99,
            'image': 'assets/images/medicine.png',
          },
        ],
        'total': 17.98,
        'specialInstructions': 'Standard delivery',
      },
    ]);
  }

  /// -------------------- Tab Switch --------------------
  void changeTab(int index) => selectedTab.value = index;

  /// -------------------- Filtered Orders --------------------
  List<Map<String, dynamic>> get filteredOrders {
    final currentStatus = tabs[selectedTab.value].toLowerCase().replaceAll(
      ' ',
      '-',
    );
    return allOrders
        .where((order) => order['status'] == currentStatus)
        .toList();
  }

  /// -------------------- Navigate to Details --------------------
  void navigateToOrderDetails(String orderId) {
    Get.toNamed(AppRoute.orderDetailsScreen, arguments: orderId);
  }

  /// -------------------- Snackbar Helper --------------------
  void _showSnackbar(String title, String message, Color bgColor) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: bgColor,
      colorText: Colors.white,
    );
  }

  /// -------------------- Order Actions --------------------
  void acceptOrder(String orderId) =>
      _showSnackbar('Order Accepted', 'Order $orderId accepted', Colors.green);

  void rejectOrder(String orderId) =>
      _showSnackbar('Order Rejected', 'Order $orderId rejected', Colors.red);

  void reviewOrder(String orderId) => _showSnackbar(
    'Order Review',
    'Reviewing $orderId prescription',
    Colors.indigo,
  );

  void markAsPrepared(String orderId) => _showSnackbar(
    'Prepared',
    'Order $orderId marked as prepared',
    Colors.green,
  );

  void markAsDispatched(String orderId) =>
      _showSnackbar('Dispatched', 'Order $orderId dispatched', Colors.green);

  /// -------------------- Get Order by ID --------------------
  Map<String, dynamic>? getOrderById(String orderId) {
    try {
      return allOrders.firstWhereOrNull((order) => order['id'] == orderId);
    } catch (_) {
      return null;
    }
  }

  /// -------------------- View Prescription --------------------
  void viewPrescription(String orderId) => _showSnackbar(
    'Prescription',
    'Viewing prescription for $orderId',
    Colors.blue,
  );

  /// -------------------- View Details --------------------
  void viewDetails(String orderId) {
    Get.toNamed(AppRoute.orderDetailsScreen, arguments: orderId);
  }
}
