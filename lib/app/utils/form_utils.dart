import 'package:flutter/material.dart';

import '../../main.dart';
import '../widgets/app_progress_bar.dart';

class FormValidations {
  static String? notEmpty(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? "Password"} is required';
    }
    if (value.length <= 3) {
      return '${fieldName ?? "Password"}: min 3 characters';
    }
    return null; // Valid password
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters';
    } else if (value.length > 16) {
      return 'Password must not exceed 16 characters';
    }
    return null; // Valid password
  }

  static String? validateConfirmPassword(
      String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Confirm password is required';
    } else if (confirmPassword != password) {
      return 'Passwords do not match';
    }
    return null; // Valid confirm password
  }

  static String? validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number is required';
    }

    // Regular expression to match a 10-digit mobile number
    String pattern = r'^[0-9]{10}$';
    RegExp regex = RegExp(pattern);

    if (!regex.hasMatch(value)) {
      return 'Enter a valid 10-digit mobile number';
    }

    return null; // Valid mobile number
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    // Regular expression for email validation
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(pattern);

    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null; // Valid email
  }

  static showProgress() {
    showDialog(
        context: navigatorKey.currentState!.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(content: AppProgressDialog());
        });
  }

  static stopProgress() {
    Navigator.pop(navigatorKey.currentState!.context);
  }
}
