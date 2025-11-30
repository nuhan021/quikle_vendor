import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackBarHelper {
  /// Show a snackbar safely with context checking
  /// Use this method to avoid "No Overlay widget found" errors
  static void show({
    required String title,
    required String message,
    SnackPosition position = SnackPosition.TOP,
    Color textColor = Colors.white,
    Color backgroundColor = Colors.blue,
    Duration duration = const Duration(seconds: 2),
  }) {
    // Check if navigator/overlay is available
    if (Get.context != null) {
      try {
        Get.snackbar(
          title,
          message,
          snackPosition: position,
          colorText: textColor,
          backgroundColor: backgroundColor,
          duration: duration,
        );
      } catch (e) {
        // Silently fail if overlay is not available
        debugPrint('SnackBar failed: $e');
      }
    }
  }

  /// Success snackbar
  static void success(String message, {String title = '✅'}) {
    show(title: title, message: message, backgroundColor: Colors.green);
  }

  /// Error snackbar
  static void error(String message, {String title = '❌'}) {
    show(title: title, message: message, backgroundColor: Colors.red);
  }

  /// Warning snackbar
  static void warning(String message, {String title = '⚠️'}) {
    show(title: title, message: message, backgroundColor: Colors.orange);
  }

  /// Info snackbar
  static void info(String message, {String title = 'ℹ️'}) {
    show(title: title, message: message, backgroundColor: Colors.blue);
  }
}
