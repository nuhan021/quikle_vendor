import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../routes/app_routes.dart';

class StorageService {
  // Constants for preference keys
  static const String _tokenKey = 'token';
  static const String _idKey = 'userId';
  static const String _vendorDetailsKey = 'vendorDetails';

  // Singleton instance for SharedPreferences
  static SharedPreferences? _preferences;

  // Initialize SharedPreferences (call this during app startup)
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Check if a token exists in local storage
  static bool hasToken() {
    final token = _preferences?.getString(_tokenKey);
    return token != null;
  }

  // Save the token and user ID to local storage
  static Future<void> saveToken(String token, String id) async {
    await _preferences?.setString(_tokenKey, token);
    await _preferences?.setString(_idKey, id);
  }

  // Remove the token and user ID from local storage (for logout)
  static Future<void> logoutUser() async {
    await _preferences?.clear();
    Get.offAllNamed(AppRoute.login);
  }

  // Getter for user ID
  static String? get userId => _preferences?.getString(_idKey);

  // Getter for token
  static String? get token => _preferences?.getString(_tokenKey);

  // Save vendor details to local storage
  static Future<void> saveVendorDetails(
    Map<String, dynamic> vendorDetails,
  ) async {
    final jsonString = jsonEncode(vendorDetails);
    await _preferences?.setString(_vendorDetailsKey, jsonString);
  }

  // Get vendor details from local storage
  static Map<String, dynamic>? getVendorDetails() {
    final jsonString = _preferences?.getString(_vendorDetailsKey);
    if (jsonString != null) {
      return jsonDecode(jsonString);
    }
    return null;
  }

  // Clear vendor details
  static Future<void> clearVendorDetails() async {
    await _preferences?.remove(_vendorDetailsKey);
  }
}
