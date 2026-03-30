import 'dart:convert';

class OrderResponse {
  final int totalOrders;
  final int offset;
  final int limit;
  final List<OrderModel> orders;

  OrderResponse({
    required this.totalOrders,
    required this.offset,
    required this.limit,
    required this.orders,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      totalOrders: json['total_orders'] ?? 0,
      offset: json['offset'] ?? 0,
      limit: json['limit'] ?? 0,
      orders:
          (json['orders'] as List<dynamic>?)
              ?.map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'total_orders': totalOrders,
    'offset': offset,
    'limit': limit,
    'orders': orders.map((e) => e.toJson()).toList(),
  };

  @override
  String toString() => jsonEncode(toJson());
}

class OrderModel {
  final String orderId;
  final int? userId;
  final String? userName;
  final int? riderId;
  final int? vendorId;
  final String? type;
  final String? shippingAddress;
  final String? deliveryType;
  final String? paymentMethod;
  final String? subtotal;
  final String? deliveryFee;
  final String? total;
  final String? discount;
  final String? couponCode;
  final String? status;
  final String? transactionId;
  final String? trackingNumber;
  final String? invoice1;
  final String? invoice2;
  final DateTime? estimatedDelivery;
  final String? paymentStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<OrderItem> items;

  OrderModel({
    required this.orderId,
    this.userId,
    this.userName,
    this.riderId,
    this.vendorId,
    this.type,
    this.shippingAddress,
    this.deliveryType,
    this.paymentMethod,
    this.subtotal,
    this.deliveryFee,
    this.total,
    this.discount,
    this.couponCode,
    this.status,
    this.transactionId,
    this.trackingNumber,
    this.invoice1,
    this.invoice2,
    this.estimatedDelivery,
    this.paymentStatus,
    this.createdAt,
    this.updatedAt,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? s) {
      if (s == null) return null;
      try {
        return DateTime.parse(s);
      } catch (_) {
        return null;
      }
    }

    return OrderModel(
      orderId: json['order_id'] as String? ?? '',
      userId: json['user_id'] is int
          ? json['user_id'] as int
          : (json['user_id'] is String
                ? int.tryParse(json['user_id'] as String)
                : null),
      userName: json['user_name'] as String?,
      riderId: json['rider_id'] is int ? json['rider_id'] as int : null,
      vendorId: json['vendor_id'] is int
          ? json['vendor_id'] as int
          : (json['vendor_id'] is String
                ? int.tryParse(json['vendor_id'] as String)
                : null),
      type: json['type'] as String? ?? json['delivery_type'] as String?,
      shippingAddress: json['shipping_address'] as String?,
      deliveryType: json['delivery_type'] as String?,
      paymentMethod: json['payment_method'] as String?,
      subtotal: json['subtotal'] as String?,
      deliveryFee: json['delivery_fee'] as String?,
      total: json['total'] as String?,
      discount: json['discount'] as String?,
      couponCode: json['coupon_code'] as String?,
      status: json['status'] as String?,
      transactionId: json['transaction_id'] as String?,
      trackingNumber: json['tracking_number'] as String?,
      invoice1: json['invoice1'] as String?,
      invoice2: json['invoice2'] as String?,
      estimatedDelivery: parseDate(json['estimated_delivery'] as String?),
      paymentStatus: json['payment_status'] as String?,
      createdAt: parseDate(json['created_at'] as String?),
      updatedAt: parseDate(json['updated_at'] as String?),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'order_id': orderId,
    'user_id': userId,
    'user_name': userName,
    'rider_id': riderId,
    'vendor_id': vendorId,
    'type': type,
    'shipping_address': shippingAddress,
    'delivery_type': deliveryType,
    'payment_method': paymentMethod,
    'subtotal': subtotal,
    'delivery_fee': deliveryFee,
    'total': total,
    'discount': discount,
    'coupon_code': couponCode,
    'status': status,
    'transaction_id': transactionId,
    'tracking_number': trackingNumber,
    'invoice1': invoice1,
    'invoice2': invoice2,
    'estimated_delivery': estimatedDelivery?.toIso8601String(),
    'payment_status': paymentStatus,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'items': items.map((e) => e.toJson()).toList(),
  };
}

class OrderItem {
  final int? orderItemId;
  final String? orderId;
  final int? quantity;
  final String? price;
  final String? title;
  final String? image;

  OrderItem({
    this.orderItemId,
    this.orderId,
    this.quantity,
    this.price,
    this.title,
    this.image,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      orderItemId: json['order_item_id'] is int
          ? json['order_item_id'] as int
          : (json['order_item_id'] is String
                ? int.tryParse(json['order_item_id'] as String)
                : null),
      orderId: json['order_id'] as String?,
      quantity: json['quantity'] is int
          ? json['quantity'] as int
          : (json['quantity'] is String
                ? int.tryParse(json['quantity'] as String)
                : null),
      price: json['price'] as String?,
      title: json['title'] as String?,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'order_item_id': orderItemId,
    'order_id': orderId,
    'quantity': quantity,
    'price': price,
    'title': title,
    'image': image,
  };
}
