import 'dart:convert';
import 'dart:developer';
import 'package:quikle_vendor/core/services/network_caller.dart';
import 'package:quikle_vendor/core/utils/constants/api_constants.dart';
import 'package:quikle_vendor/features/order_management/model/order_model.dart';

class OrderService {
  final NetworkCaller _networkCaller = NetworkCaller();

  /// Fetch orders from API with pagination and optional filters
  Future<OrderResponse?> fetchOrders({
    int offset = 0,
    int limit = 10,
    String? status,
    String? type,
    String? token,
  }) async {
    try {
      final queryParams = {
        'offset': offset.toString(),
        'limit': limit.toString(),
        if (status != null) 'status': status,
        if (type != null) 'type': type,
      };

      print('📡 [ORDER SERVICE] Fetching from: ${ApiConstants.myOrders}');
      print('📡 [ORDER SERVICE] Query params: $queryParams');
      print('📡 [ORDER SERVICE] Token: $token');

      final response = await _networkCaller.getRequest(
        ApiConstants.myOrders,
        queryParams: queryParams,
        token: token,
      );

      print('📡 [ORDER SERVICE] Network response received');
      print('📡 [ORDER SERVICE] isSuccess: ${response.isSuccess}');
      print('📡 [ORDER SERVICE] statusCode: ${response.statusCode}');
      print('📡 [ORDER SERVICE] responseData: ${response.responseData}');
      print(
        '📡 [ORDER SERVICE] responseData type: ${response.responseData.runtimeType}',
      );

      if (response.isSuccess && response.responseData != null) {
        // Handle both String and Map responses
        Map<String, dynamic> jsonData;

        if (response.responseData is String) {
          jsonData =
              jsonDecode(response.responseData as String)
                  as Map<String, dynamic>;
        } else {
          jsonData = response.responseData as Map<String, dynamic>;
        }

        print('✅ [ORDER SERVICE] Parsed JSON: ${jsonEncode(jsonData)}');
        // Log the API response
        log('✅ Order API Response: ${jsonEncode(jsonData)}');

        final orderResponse = OrderResponse.fromJson(jsonData);
        print(
          '✅ [ORDER SERVICE] OrderResponse created: ${orderResponse.orders.length} orders',
        );
        return orderResponse;
      } else {
        print(
          '❌ [ORDER SERVICE] API not successful. isSuccess: ${response.isSuccess}',
        );
        print(
          '❌ [ORDER SERVICE] responseData null: ${response.responseData == null}',
        );
      }

      log('❌ Order API Error: ${response.responseData}');

      return null;
    } catch (e) {
      print('❌ [ORDER SERVICE] Exception: $e');
      print('❌ [ORDER SERVICE] Stack: ${StackTrace.current}');
      log('Error fetching orders: $e');
      return null;
    }
  }

  /// Map API status to UI status for filtering
  static String mapApiStatusToUiStatus(String? apiStatus) {
    switch (apiStatus?.toLowerCase()) {
      case 'processing':
        return 'new';
      case 'confirmed':
        return 'in-progress';
      // case 'prepared':
      //   return 'in-progress';
      case 'shipped':
      case 'outfordelivery':
        return 'in-progress';
      case 'delivered':
        return 'completed';
      case 'cancelled':
      case 'refunded':
        return 'cancelled';
      default:
        return 'new';
    }
  }

  /// Get tag label for UI display
  static String getTagLabel(String uiStatus) {
    switch (uiStatus) {
      case 'new':
        return 'New';
      case 'confirmed':
        return 'In Progress';
      // case 'in-progress':
      //   return 'In Progress';
      case 'completed':
        return 'Completed';
      default:
        return _capitalize(uiStatus);
    }
  }

  /// Convert OrderModel to legacy Map format for UI compatibility
  static Map<String, dynamic> orderModelToMap(OrderModel order) {
    final uiStatus = mapApiStatusToUiStatus(order.status);

    return {
      'id': order.orderId,
      'customerName': order.userName ?? 'Unknown',
      'timeAgo': _getTimeAgoString(order.createdAt),
      'deliveryTime': order.estimatedDelivery != null
          ? 'Delivery in ${_getMinutesUntilDelivery(order.estimatedDelivery)} min'
          : 'N/A',
      'address': order.shippingAddress ?? 'Address not provided',
      'status': uiStatus,
      'tags': [getTagLabel(uiStatus)],
      'isUrgent': order.deliveryType == 'urgent',
      'requiresPrescription': false,
      'estimatedDelivery': order.estimatedDelivery?.toString() ?? 'N/A',
      'items': order.items
          .map(
            (item) => {
              'name': item.title ?? 'Unknown Item',
              'description': 'Order Item',
              'quantity': item.quantity ?? 1,
              'price': double.tryParse(item.price ?? '0') ?? 0.0,
              'image': item.image ?? 'assets/images/medicine.png',
            },
          )
          .toList(),
      'total': double.tryParse(order.total ?? '0') ?? 0.0,
      'specialInstructions': 'N/A',
      'apiOrderId': order.orderId,
      'userId': order.userId,
      'vendorId': order.vendorId,
      'paymentStatus': order.paymentStatus,
      'trackingNumber': order.trackingNumber,
    };
  }

  /// Create an offer for a new order with prepare time
  Future<bool> createOffer({
    required String orderId,
    required int prepareTime,
    String? token,
  }) async {
    try {
      final url = '${ApiConstants.createOffer}$orderId/';
      final body = {'prepare_time': prepareTime};

      log('📤 Creating offer: POST $url with body: $body');

      final response = await _networkCaller.postRequest(
        url,
        body: body,
        token: token,
        form: true,
      );

      if (response.isSuccess) {
        log('✅ Create Offer Success for Order $orderId');
        return true;
      } else {
        log('❌ Create Offer Failed: ${response.responseData}');
        return false;
      }
    } catch (e) {
      log('Error creating offer: $e');
      return false;
    }
  }

  /// Mark order as shipped
  Future<bool> markShipped({required String orderId, String? token}) async {
    try {
      final url = '${ApiConstants.markShipped}$orderId/';

      log('📤 Marking shipped: POST $url');

      final response = await _networkCaller.postRequest(url, token: token);

      if (response.isSuccess) {
        log('✅ Mark Shipped Success for Order $orderId');
        return true;
      } else {
        log('❌ Mark Shipped Failed: ${response.responseData}');
        return false;
      }
    } catch (e) {
      log('Error marking shipped: $e');
      return false;
    }
  }

  static String _getTimeAgoString(DateTime? date) {
    if (date == null) return 'Just now';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} mins ago';
    if (difference.inHours < 24) return '${difference.inHours} hours ago';
    return '${difference.inDays} days ago';
  }

  static int _getMinutesUntilDelivery(DateTime? deliveryTime) {
    if (deliveryTime == null) return 0;

    final now = DateTime.now();
    final difference = deliveryTime.difference(now);

    return difference.inMinutes > 0 ? difference.inMinutes : 0;
  }

  static String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}
