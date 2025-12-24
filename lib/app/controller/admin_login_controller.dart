import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/navigation/admin_login_screen.dart';

class AdminAuthController extends GetxController {
  var isLoading = false.obs;
  var isLoggedIn = false.obs;

  // Mock admin credentials - Replace with your actual authentication
  final String _adminEmail = "admin@example.com";
  final String _adminPassword = "admin123";

  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Check credentials (Replace with actual API call)
      if (email == _adminEmail && password == _adminPassword) {
        isLoggedIn.value = true;
        Get.snackbar(
          'Success',
          'Admin login successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Invalid admin credentials',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Login failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    isLoggedIn.value = false;
    Get.offAll(() => AdminLoginScreen());
  }

  // Check if user is admin (for route guards)
  bool get isAdmin => isLoggedIn.value;
}