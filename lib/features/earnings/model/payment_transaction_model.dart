class PaymentsResponseModel {
  final int totalOrders;
  final int offset;
  final int limit;
  final List<PaymentTransactionModel> orders;

  PaymentsResponseModel({
    required this.totalOrders,
    required this.offset,
    required this.limit,
    required this.orders,
  });

  factory PaymentsResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentsResponseModel(
      totalOrders: _toInt(json['total_orders']),
      offset: _toInt(json['offset']),
      limit: _toInt(json['limit']),
      orders:
          (json['orders'] as List<dynamic>?)
              ?.map(
                (item) => PaymentTransactionModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class PaymentTransactionModel {
  final String orderId;
  final String? userName;
  final String? deliveryType;
  final String? paymentMethod;
  final String? total;
  final String? status;
  final String? paymentStatus;
  final DateTime? createdAt;
  final List<PaymentItemModel> items;

  PaymentTransactionModel({
    required this.orderId,
    this.userName,
    this.deliveryType,
    this.paymentMethod,
    this.total,
    this.status,
    this.paymentStatus,
    this.createdAt,
    required this.items,
  });

  factory PaymentTransactionModel.fromJson(Map<String, dynamic> json) {
    return PaymentTransactionModel(
      orderId: json['order_id'] as String? ?? '',
      userName: json['user_name'] as String?,
      deliveryType: json['delivery_type'] as String?,
      paymentMethod: json['payment_method'] as String?,
      total: json['total']?.toString(),
      status: json['status'] as String?,
      paymentStatus: json['payment_status'] as String?,
      createdAt: _parseDate(json['created_at'] as String?),
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (item) =>
                    PaymentItemModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  String get displayOrderId => orderId.isEmpty ? 'N/A' : orderId;

  String get displayAmount {
    final amount = double.tryParse(total ?? '');
    if (amount == null) {
      return '\$0.00';
    }
    return '\$${amount.toStringAsFixed(2)}';
  }

  String get displayStatus {
    final normalizedPaymentStatus = (paymentStatus ?? '').trim().toLowerCase();
    final normalizedOrderStatus = (status ?? '').trim().toLowerCase();
    final normalizedPaymentMethod = (paymentMethod ?? '').trim().toLowerCase();

    if (const {
      'paid',
      'completed',
      'success',
      'received',
    }.contains(normalizedPaymentStatus)) {
      return 'Received';
    }

    if (const {'pending', 'due', 'unpaid'}.contains(normalizedPaymentStatus)) {
      return 'Pending';
    }

    if (normalizedOrderStatus == 'confirmed' ||
        normalizedPaymentMethod == 'cash_on_delivery') {
      return 'Pending';
    }

    return _humanizeText(
      normalizedPaymentStatus.isNotEmpty
          ? normalizedPaymentStatus
          : normalizedOrderStatus,
    );
  }

  String get displayTime {
    if (createdAt == null) {
      return 'Just now';
    }

    final difference = DateTime.now().difference(createdAt!);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} mins ago';
    if (difference.inHours < 24) return '${difference.inHours} hours ago';
    return '${difference.inDays} days ago';
  }

  String get displayCustomer {
    final name = userName?.trim();
    return (name == null || name.isEmpty) ? 'Unknown customer' : name;
  }

  String get displayDelivery {
    final rawValue = (paymentMethod ?? deliveryType ?? '').trim();
    if (rawValue.isEmpty) {
      return 'N/A';
    }
    return _humanizeText(rawValue);
  }

  List<String> get displayTags {
    if (items.isEmpty) {
      return const ['0 items'];
    }

    if (items.length == 1) {
      final title = items.first.title?.trim() ?? '';
      if (title.isNotEmpty && title.length <= 18) {
        return [title];
      }
    }

    return ['${items.length} ${items.length == 1 ? 'item' : 'items'}'];
  }

  static DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    try {
      return DateTime.parse(value).toLocal();
    } catch (_) {
      return null;
    }
  }

  static String _humanizeText(String value) {
    if (value.trim().isEmpty) {
      return 'Unknown';
    }

    return value
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .split(' ')
        .where((part) => part.trim().isNotEmpty)
        .map(
          (part) =>
              '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}

class PaymentItemModel {
  final String? title;

  PaymentItemModel({this.title});

  factory PaymentItemModel.fromJson(Map<String, dynamic> json) {
    return PaymentItemModel(title: json['title'] as String?);
  }
}
