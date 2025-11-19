import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppUtils {
  // Format currency
  static String formatCurrency(double amount, {String currencySymbol = 'RWF'}) {
    final formatter = NumberFormat('#,##0.##', 'en_US');
    return '$currencySymbol ${formatter.format(amount)}';
  }

  // Format date
  static String formatDate(DateTime date, {String pattern = 'MMM dd, yyyy'}) {
    try {
      final formatter = DateFormat(pattern);
      return formatter.format(date);
    } catch (e) {
      return date.toString();
    }
  }

  // Format time
  static String formatTime(DateTime dateTime, {String pattern = 'HH:mm'}) {
    try {
      final formatter = DateFormat(pattern);
      return formatter.format(dateTime);
    } catch (e) {
      return dateTime.toString();
    }
  }

  // Format date and time
  static String formatDateTime(DateTime dateTime,
      {String pattern = 'MMM dd, yyyy - HH:mm'}) {
    try {
      final formatter = DateFormat(pattern);
      return formatter.format(dateTime);
    } catch (e) {
      return dateTime.toString();
    }
  }

  // Calculate time difference
  static String getTimeDifference(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return formatDate(dateTime);
    }
  }

  // Validate email
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  // Validate phone
  static bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^(\+\d{1,3})?\d{7,14}$');
    return phoneRegex.hasMatch(phone.replaceAll(RegExp(r'[^\d+]'), ''));
  }

  // Validate password
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  // Show snackbar
  static void showSnackbar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        backgroundColor: backgroundColor,
        action: action,
      ),
    );
  }

  // Show error snackbar
  static void showErrorSnackbar(BuildContext context, String message) {
    showSnackbar(
      context,
      message,
      backgroundColor: Colors.red,
    );
  }

  // Show success snackbar
  static void showSuccessSnackbar(BuildContext context, String message) {
    showSnackbar(
      context,
      message,
      backgroundColor: Colors.green,
    );
  }

  // Show loading dialog
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading...'),
          ],
        ),
      ),
    );
  }

  // Hide loading dialog
  static void hideLoadingDialog(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  // Show confirmation dialog
  static Future<bool> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  // Calculate distance between two coordinates in kilometers
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadiusKm = 6371;

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(_degreesToRadians(lat1)) *
            Math.cos(_degreesToRadians(lat2)) *
            Math.sin(dLon / 2) *
            Math.sin(dLon / 2);

    final double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

    return earthRadiusKm * c;
  }

  // Convert degrees to radians
  static double _degreesToRadians(double degrees) {
    return degrees * Math.PI / 180;
  }

  // Get color based on rating
  static Color getRatingColor(double rating) {
    if (rating >= 4.5) {
      return Colors.green;
    } else if (rating >= 4.0) {
      return Colors.lightGreen;
    } else if (rating >= 3.5) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  // Format rating with stars
  static String formatRating(double rating) {
    return '${rating.toStringAsFixed(1)} ★';
  }

  // Get number of stars (rounded)
  static int getStarCount(double rating) {
    return rating.round();
  }

  // Truncate string
  static String truncateString(String str, int length) {
    if (str.length <= length) {
      return str;
    }
    return '${str.substring(0, length)}...';
  }
}

class Math {
  static const double PI = 3.141592653589793;

  static double sin(double x) => _sin(x);
  static double cos(double x) => _cos(x);
  static double sqrt(double x) => _sqrt(x);
  static double atan2(double y, double x) => _atan2(y, x);

  // Using approximations or dart:math
  static double _sin(double x) {
    // Normalize angle to [-2π, 2π]
    x = x % (2 * PI);

    // Taylor series approximation
    double result = 0;
    double term = x;
    for (int i = 1; i < 10; i++) {
      result += term;
      term *= -x * x / ((2 * i) * (2 * i + 1));
    }
    return result;
  }

  static double _cos(double x) {
    // cos(x) = sin(π/2 - x)
    return _sin(PI / 2 - x);
  }

  static double _sqrt(double x) {
    if (x < 0) return double.nan;
    if (x == 0) return 0;
    double guess = x / 2;
    double prevGuess = 0;
    while ((guess - prevGuess).abs() > 0.00001) {
      prevGuess = guess;
      guess = (guess + x / guess) / 2;
    }
    return guess;
  }

  static double _atan2(double y, double x) {
    // Simplified atan2 using approximations
    if (x > 0) {
      return _atan(y / x);
    } else if (x < 0 && y >= 0) {
      return _atan(y / x) + PI;
    } else if (x < 0 && y < 0) {
      return _atan(y / x) - PI;
    } else if (x == 0 && y > 0) {
      return PI / 2;
    } else if (x == 0 && y < 0) {
      return -PI / 2;
    }
    return 0;
  }

  static double _atan(double x) {
    // Approximation of atan
    return x / (1 + 0.28 * x * x);
  }
}
