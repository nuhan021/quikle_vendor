import 'package:get/get.dart';

class InvoiceController extends GetxController {
  var invoices = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();

    // TODO: Replace this mock data with API call
    invoices.addAll([
      {
        "invoiceId": "INV-2024-001",
        "orderId": "ORD-ED-001",
        "amount": "\$47.40",
        "customer": "Anaya Desai",
        "date": "Jan 15, 2024",
        "time": "10 minutes ago",
        "status": "Paid",
        "tags": ["Food"],
      },
      {
        "invoiceId": "INV-2024-002",
        "orderId": "ORD-ED-002",
        "amount": "\$47.40",
        "customer": "Anaya Desai",
        "date": "Jan 15, 2024",
        "time": "20 minutes ago",
        "status": "Pending",
        "tags": ["Food"],
      },
    ]);
  }

  Future<void> fetchInvoices() async {
    // TODO: Implement API call
  }
}
