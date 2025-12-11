import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quikle_vendor/core/models/response_data.dart';

class CouponNetworkCaller {
  static const int timeoutDuration = 60;

  /// Encodes form body with support for repeated keys (e.g., item_ids=1&item_ids=2)
  /// This is needed for FastAPI's List[int] = Form(...) fields
  String _encodeFormBodyWithArrays(Map<String, dynamic>? body) {
    if (body == null || body.isEmpty) return '';

    final pairs = <String>[];
    body.forEach((key, value) {
      if (value is List) {
        // For lists: add repeated key=value entries
        for (final item in value) {
          pairs.add(
            '${Uri.encodeComponent(key)}=${Uri.encodeComponent(item.toString())}',
          );
        }
      } else if (value != null) {
        pairs.add(
          '${Uri.encodeComponent(key)}=${Uri.encodeComponent(value.toString())}',
        );
      }
    });

    return pairs.join('&');
  }

  /// Custom PUT request for coupon update with proper form array encoding
  Future<ResponseData> putRequest(
    String url, {
    Map<String, dynamic>? body,
    String? token,
    Map<String, String>? headers,
  }) async {
    final requestHeaders = {
      'Content-Type': 'application/x-www-form-urlencoded',
      if (token != null) 'Authorization': token,
      if (headers != null) ...headers,
    };

    try {
      final response = await http
          .put(
            Uri.parse(url),
            headers: requestHeaders,
            body: _encodeFormBodyWithArrays(body),
          )
          .timeout(Duration(seconds: timeoutDuration));

      // Handle response
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResponseData(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: jsonDecode(response.body),
          errorMessage: '',
        );
      } else {
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          responseData: jsonDecode(response.body),
          errorMessage: 'Request failed with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      return ResponseData(
        isSuccess: false,
        statusCode: -1,
        responseData: {},
        errorMessage: e.toString(),
      );
    }
  }
}
