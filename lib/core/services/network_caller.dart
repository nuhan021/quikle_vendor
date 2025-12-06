import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../models/response_data.dart';
import '../utils/logging/logger.dart';

class NetworkCaller {
  final int timeoutDuration = 10;

  // GET Request
  Future<ResponseData> getRequest(
    String url, {
    String? token,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    Uri uri = Uri.parse(url);

    if (queryParams != null) {
      uri = uri.replace(
        queryParameters: queryParams.map((k, v) => MapEntry(k, v.toString())),
      );
    }

    final requestHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': token,
      if (headers != null) ...headers,
    };

    try {
      final response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: timeoutDuration));

      return await _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // POST Request (JSON or FORM)
  Future<ResponseData> postRequest(
    String url, {
    Map<String, dynamic>? body,
    String? token,
    Map<String, String>? headers,
    bool form = false, // <-- NEW
  }) async {
    // Check if body contains File objects for multipart upload
    final hasFiles = body?.values.any((value) => value is File) ?? false;

    if (hasFiles || (form && body != null)) {
      // Use MultipartRequest for file uploads or form data
      final request = http.MultipartRequest('POST', Uri.parse(url));

      if (token != null) {
        request.headers['Authorization'] = token;
      }
      if (headers != null) {
        request.headers.addAll(headers);
      }

      if (body != null) {
        body.forEach((key, value) {
          if (value is File) {
            request.files.add(
              http.MultipartFile.fromBytes(
                key,
                value.readAsBytesSync(),
                filename: value.path.split('/').last,
              ),
            );
          } else {
            request.fields[key] = value.toString();
          }
        });
      }

      try {
        final streamedResponse = await request.send().timeout(
          Duration(seconds: timeoutDuration),
        );
        final response = await http.Response.fromStream(streamedResponse);
        return await _handleResponse(response);
      } catch (e) {
        return _handleError(e);
      }
    } else {
      // Use regular POST for JSON
      final requestHeaders = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': token,
        if (headers != null) ...headers,
      };

      try {
        final response = await http
            .post(
              Uri.parse(url),
              headers: requestHeaders,
              body: jsonEncode(body ?? {}),
            )
            .timeout(Duration(seconds: timeoutDuration));

        return await _handleResponse(response);
      } catch (e) {
        return _handleError(e);
      }
    }
  }

  // PUT Request (JSON or FORM)
  Future<ResponseData> putRequest(
    String url, {
    Map<String, dynamic>? body,
    String? token,
    Map<String, String>? headers,
    bool form = false,
  }) async {
    final requestHeaders = {
      if (form)
        'Content-Type': 'application/x-www-form-urlencoded'
      else
        'Content-Type': 'application/json',
      if (token != null) 'Authorization': token,
      if (headers != null) ...headers,
    };

    try {
      final response = await http
          .put(
            Uri.parse(url),
            headers: requestHeaders,
            body: form
                ? body?.map((k, v) => MapEntry(k, v.toString()))
                : jsonEncode(body ?? {}),
          )
          .timeout(Duration(seconds: timeoutDuration));

      return await _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // DELETE Request
  Future<ResponseData> deleteRequest(
    String url, {
    String? token,
    Map<String, String>? headers,
  }) async {
    final requestHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': token,
      if (headers != null) ...headers,
    };

    try {
      final response = await http
          .delete(Uri.parse(url), headers: requestHeaders)
          .timeout(Duration(seconds: timeoutDuration));

      return await _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // MULTIPART Request
  Future<ResponseData> multipartRequest(
    String url, {
    Map<String, String>? fields,
    Map<String, String>? headers,
    List<http.MultipartFile>? files,
    String? token,
    String method = 'POST', // Allow POST, PUT, PATCH, etc.
  }) async {
    final uri = Uri.parse(url);

    final requestHeaders = {
      if (token != null) 'Authorization': token,
      if (headers != null) ...headers,
    };

    try {
      // Create appropriate request based on method
      final request = _createMultipartRequest(method, uri);

      request.headers.addAll(requestHeaders);
      if (fields != null) request.fields.addAll(fields);
      if (files != null) request.files.addAll(files);

      final streamedResponse = await request.send().timeout(
        Duration(seconds: timeoutDuration),
      );

      final response = await http.Response.fromStream(streamedResponse);

      return await _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // Helper method to create appropriate multipart request
  http.MultipartRequest _createMultipartRequest(String method, Uri uri) {
    switch (method.toUpperCase()) {
      case 'PUT':
        return http.MultipartRequest('PUT', uri);
      case 'PATCH':
        return http.MultipartRequest('PATCH', uri);
      case 'POST':
      default:
        return http.MultipartRequest('POST', uri);
    }
  }

  // HANDLE SUCCESS / ERROR RESPONSE
  Future<ResponseData> _handleResponse(Response response) async {
    AppLoggerHelper.debug('Status: ${response.statusCode}');
    AppLoggerHelper.debug('Body: ${response.body}');

    dynamic decoded;

    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      decoded = response.body;
    }

    // Handle success responses
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ResponseData(
        isSuccess: true,
        statusCode: response.statusCode,
        responseData: decoded,
        errorMessage: (decoded is Map && decoded['message'] != null)
            ? decoded['message']
            : '',
      );
    }

    // Handle validation errors (400)
    if (response.statusCode == 400) {
      return ResponseData(
        isSuccess: false,
        statusCode: 400,
        responseData: decoded,
        errorMessage: decoded is Map && decoded['message'] != null
            ? decoded['message']
            : 'Bad Request',
      );
    }

    // Unauthorized
    if (response.statusCode == 401) {
      return ResponseData(
        isSuccess: false,
        statusCode: 401,
        responseData: decoded,
        errorMessage: 'Unauthorized request',
      );
    }

    // Forbidden
    if (response.statusCode == 403) {
      return ResponseData(
        isSuccess: false,
        statusCode: 403,
        responseData: decoded,
        errorMessage: 'Forbidden request',
      );
    }

    // Server error
    if (response.statusCode == 500) {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: decoded,
        errorMessage: decoded is Map && decoded['message'] != null
            ? decoded['message']
            : 'Server error',
      );
    }

    // Default fallback
    return ResponseData(
      isSuccess: false,
      statusCode: response.statusCode,
      responseData: decoded,
      errorMessage: decoded is Map && decoded['message'] != null
          ? decoded['message']
          : 'Unknown error',
    );
  }

  // HANDLE NETWORK ERROR
  ResponseData _handleError(dynamic error) {
    AppLoggerHelper.error('Request error', error);

    if (error is TimeoutException) {
      return ResponseData(
        isSuccess: false,
        statusCode: 408,
        responseData: '',
        errorMessage: 'Request Timeout',
      );
    }

    return ResponseData(
      isSuccess: false,
      statusCode: 500,
      responseData: '',
      errorMessage: error.toString(),
    );
  }
}
