import 'package:get/get.dart';

class PaymentsController extends GetxController {
  var transactions = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();

    // TODO: Replace mock data with API
    transactions.addAll([
      {
        "orderId": "ORD-FD-001",
        "amount": "\$47.40",
        "status": "Received",
        "time": "10 minutes ago",
        "customer": "Anaya Desai",
        "delivery": "Cash On Delivery",
        "tags": ["Food"],
      },
      {
        "orderId": "ORD-GR-087",
        "amount": "\$47.40",
        "status": "Pending",
        "time": "15 minutes ago",
        "customer": "Anaya Desai",
        "delivery": "Cash On Delivery",
        "tags": ["Food"],
      },
    ]);
  }

  Future<void> fetchTransactions() async {
    // TODO: Implement API integration
  }
}
