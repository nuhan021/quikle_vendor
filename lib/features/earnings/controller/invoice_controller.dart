import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:quikle_vendor/core/services/storage_service.dart';
import 'package:quikle_vendor/core/utils/helpers/snackbar_helper.dart';
import 'package:quikle_vendor/features/order_management/model/order_model.dart';
import 'package:quikle_vendor/features/order_management/services/order_services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class InvoiceController extends GetxController {
  final OrderService _orderService = OrderService();
  final statusOptions = <String>[
    'all',
    'processing',
    'confirmed',
    'shipped',
    'prepared',
    'outForDelivery',
    'delivered',
    'cancelled',
    'refunded',
  ];
  final typeOptions = <String>['all', 'combined', 'split', 'urgent'];

  final invoices = <OrderModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final selectedStatus = 'all'.obs;
  final selectedType = 'all'.obs;
  final downloadingOrderIds = <String>{}.obs;
  final viewingOrderIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInvoices();
  }

  Future<void> fetchInvoices({
    bool showLoader = true,
    String? previousStatus,
    String? previousType,
  }) async {
    final previousInvoices = List<OrderModel>.from(invoices);

    if (showLoader) {
      isLoading.value = true;
    }
    errorMessage.value = '';

    try {
      final storedToken = StorageService.token;
      final authHeader = storedToken != null ? 'Bearer $storedToken' : null;

      final response = await _orderService.fetchOrders(
        token: authHeader,
        status: apiStatus,
        type: apiType,
      );

      if (response == null) {
        throw Exception('Failed to load invoices.');
      }

      invoices.assignAll(response.orders);
    } catch (e) {
      invoices.assignAll(previousInvoices);
      if (previousStatus != null) {
        selectedStatus.value = previousStatus;
      }
      if (previousType != null) {
        selectedType.value = previousType;
      }
      if (previousInvoices.isEmpty) {
        errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      }
    } finally {
      if (showLoader) {
        isLoading.value = false;
      }
    }
  }

  String? get apiStatus =>
      selectedStatus.value == 'all' ? null : selectedStatus.value;

  String? get apiType =>
      selectedType.value == 'all' ? null : selectedType.value;

  void changeStatus(String value) {
    if (selectedStatus.value == value) {
      return;
    }
    final previousStatus = selectedStatus.value;
    selectedStatus.value = value;
    fetchInvoices(previousStatus: previousStatus);
  }

  void changeType(String value) {
    if (selectedType.value == value) {
      return;
    }
    final previousType = selectedType.value;
    selectedType.value = value;
    fetchInvoices(previousType: previousType);
  }

  String labelForValue(String value) {
    if (value == 'all') {
      return 'All';
    }

    final withSpaces = value
        .replaceAllMapped(
          RegExp(r'([a-z])([A-Z])'),
          (match) => '${match.group(1)} ${match.group(2)}',
        )
        .replaceAll('_', ' ')
        .replaceAll('-', ' ');

    return withSpaces
        .split(' ')
        .where((part) => part.trim().isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  String invoiceIdFor(OrderModel order) {
    final transactionId = order.transactionId?.trim() ?? '';
    if (transactionId.isNotEmpty) {
      return 'INV-$transactionId';
    }

    final orderId = order.orderId.trim();
    if (orderId.isNotEmpty) {
      return 'INV-$orderId';
    }

    return 'INV-N/A';
  }

  String orderIdFor(OrderModel order) {
    final orderId = order.orderId.trim();
    return orderId.isEmpty ? 'N/A' : orderId;
  }

  String amountFor(OrderModel order) {
    final amount = double.tryParse(order.total ?? '');
    if (amount == null) {
      return '\$0.00';
    }
    return '\$${amount.toStringAsFixed(2)}';
  }

  String customerFor(OrderModel order) {
    final customerName = order.userName?.trim() ?? '';
    return customerName.isEmpty ? 'Unknown customer' : customerName;
  }

  String dateFor(OrderModel order) {
    final createdAt = order.createdAt?.toLocal();
    if (createdAt == null) {
      return 'N/A';
    }
    return DateFormat('MMM dd, yyyy').format(createdAt);
  }

  String timeFor(OrderModel order) {
    final createdAt = order.createdAt?.toLocal();
    if (createdAt == null) {
      return 'Just now';
    }

    final difference = DateTime.now().difference(createdAt);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} mins ago';
    if (difference.inHours < 24) return '${difference.inHours} hours ago';
    return '${difference.inDays} days ago';
  }

  String statusFor(OrderModel order) {
    final orderStatus = order.status?.trim() ?? '';
    if (orderStatus.isNotEmpty) {
      return labelForValue(orderStatus);
    }

    final paymentStatus = (order.paymentStatus ?? '').trim().toLowerCase();
    final paymentMethod = (order.paymentMethod ?? '').trim().toLowerCase();
    final transactionId = (order.transactionId ?? '').trim();

    if (const {
      'paid',
      'completed',
      'success',
      'received',
    }.contains(paymentStatus)) {
      return 'Paid';
    }

    if (const {'pending', 'due', 'unpaid'}.contains(paymentStatus)) {
      return 'Pending';
    }

    if (paymentMethod == 'cash_on_delivery') {
      return 'Pending';
    }

    if (transactionId.isNotEmpty) {
      return 'Paid';
    }

    return 'Pending';
  }

  List<String> tagsFor(OrderModel order) {
    final tags = <String>[];
    final orderType = (order.type ?? order.deliveryType ?? '').trim();

    if (orderType.isNotEmpty) {
      tags.add(labelForValue(orderType));
    }

    if (order.items.isEmpty) {
      tags.add('0 items');
      return tags;
    }

    if (order.items.length == 1) {
      final title = order.items.first.title?.trim() ?? '';
      if (title.isNotEmpty && title.length <= 18) {
        tags.add(title);
        return tags;
      }
    }

    tags.add(
      '${order.items.length} ${order.items.length == 1 ? 'item' : 'items'}',
    );
    return tags;
  }

  bool isDownloading(String orderId) => downloadingOrderIds.contains(orderId);

  bool isViewing(String orderId) => viewingOrderIds.contains(orderId);

  Future<void> downloadInvoice(OrderModel order) async {
    final orderId = order.orderId.trim();
    if (orderId.isEmpty || downloadingOrderIds.contains(orderId)) {
      return;
    }

    downloadingOrderIds.add(orderId);
    try {
      final detailedOrder = await _fetchDetailedOrder(orderId);
      final invoiceUrl = _primaryInvoiceUrl(detailedOrder);

      if (invoiceUrl == null) {
        SnackBarHelper.error('No invoice PDF found for this order.');
        return;
      }

      final savedFile = await _downloadInvoiceFile(
        invoiceUrl: invoiceUrl,
        orderId: detailedOrder.orderId,
      );

      SnackBarHelper.success(
        'Invoice downloaded: ${savedFile.path.split('/').last}',
      );
    } catch (_) {
      SnackBarHelper.error('Failed to download invoice.');
    } finally {
      downloadingOrderIds.remove(orderId);
    }
  }

  Future<void> viewInvoice(OrderModel order) async {
    final orderId = order.orderId.trim();
    if (orderId.isEmpty || viewingOrderIds.contains(orderId)) {
      return;
    }

    viewingOrderIds.add(orderId);
    try {
      final detailedOrder = await _fetchDetailedOrder(orderId);
      final invoiceUrl = _primaryInvoiceUrl(detailedOrder);

      if (invoiceUrl == null) {
        SnackBarHelper.error('No invoice PDF found for this order.');
        return;
      }

      final uri = Uri.tryParse(invoiceUrl);
      if (uri == null) {
        SnackBarHelper.error('Invalid invoice URL.');
        return;
      }

      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        SnackBarHelper.error('Unable to open invoice PDF.');
      }
    } catch (_) {
      SnackBarHelper.error('Failed to open invoice.');
    } finally {
      viewingOrderIds.remove(orderId);
    }
  }

  Future<OrderModel> _fetchDetailedOrder(String orderId) async {
    final storedToken = StorageService.token;
    final authHeader = storedToken != null ? 'Bearer $storedToken' : null;

    final detailedOrder = await _orderService.fetchOrderById(
      orderId: orderId,
      token: authHeader,
    );

    if (detailedOrder == null) {
      throw Exception('Failed to load invoice details.');
    }

    return detailedOrder;
  }

  String? _primaryInvoiceUrl(OrderModel order) {
    final urls = [
      order.invoice1,
      order.invoice2,
    ].map((url) => url?.trim() ?? '').where((url) => url.isNotEmpty).toList();

    if (urls.isEmpty) {
      return null;
    }

    return urls.first;
  }

  Future<File> _downloadInvoiceFile({
    required String invoiceUrl,
    required String orderId,
  }) async {
    final response = await http.get(Uri.parse(invoiceUrl));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Invoice download failed.');
    }

    final directory = await getApplicationDocumentsDirectory();
    final invoicesDirectory = Directory('${directory.path}/invoices');

    if (!await invoicesDirectory.exists()) {
      await invoicesDirectory.create(recursive: true);
    }

    final sanitizedOrderId = orderId.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    final file = File(
      '${invoicesDirectory.path}/invoice_$sanitizedOrderId.pdf',
    );

    await file.writeAsBytes(response.bodyBytes, flush: true);
    return file;
  }
}
