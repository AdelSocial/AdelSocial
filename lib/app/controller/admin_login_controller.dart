import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/admin_access_service.dart';

class AdminAuthController extends GetxController {
  var isLoading = false.obs;
  final RxBool isAdmin = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = cred.user;
      if (user == null) {
        Get.snackbar(
          'Error',
          'Login failed: missing user session',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      final ok = await AdminAccessService.isAdmin(user);
      isAdmin.value = ok;

      if (!ok) {
        // Do not keep a non-admin signed into the admin area.
        await _auth.signOut();
        Get.snackbar(
          'Access denied',
          'Your account is not an authorized admin.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      Get.snackbar(
        'Success',
        'Admin login successful',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return true;
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

  Future<void> logout() async {
    isAdmin.value = false;
    AdminAccessService.clearCache();
    await _auth.signOut();
  }

  // Check if user is admin (for route guards)
  bool get isAdminUser => isAdmin.value;
}