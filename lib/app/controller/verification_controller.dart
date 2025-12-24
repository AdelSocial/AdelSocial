import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../view/otp_screen.dart';

class VerificationController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var isLoading = false.obs;
  var verificationId = ''.obs;
  var phoneNumber = ''.obs;

  /// Send OTP
  Future<void> sendOTP(String phone) async {
    try {
      isLoading.value = true;
      phoneNumber.value = phone;
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          Get.snackbar("Success", "Auto verification successful!");
          // Get.offAllNamed('/createProfile');
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            Get.snackbar("Error", "Invalid phone number format");
          } else if (e.code == 'too-many-requests') {
            Get.snackbar("Error", "Too many requests. Try again later.");
          } else if (e.code == 'app-not-authorized') {
            Get.snackbar("Error", "App not authorized. Check SHA keys in Firebase Console.");
          } else {
            Get.snackbar("Error", e.message ?? "OTP sending failed");
          }
        },

        codeSent: (String verId, int? resendToken) {
          verificationId.value = verId;
          Get.to(OtpVerificationScreen(
            arguments: {
              'phoneNumber': phone,
            },
          ));
          // Get.toNamed('/otp-verification', arguments: {
          //   'phoneNumber': phone,
          // });
        },
        codeAutoRetrievalTimeout: (String verId) {
          verificationId.value = verId;
        },
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to send OTP. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  /// Verify OTP
  Future<void> verifyOTP(String otp) async {
    try {
      isLoading.value = true;

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        Get.snackbar("Success", "Phone number verified successfully");
        Get.offAllNamed('/createProfile');
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Invalid OTP");
    } catch (e) {
      Get.snackbar("Error", "Something went wrong. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  /// Resend OTP
  Future<void> resendOTP() async {
    if (phoneNumber.value.isNotEmpty) {
      await sendOTP(phoneNumber.value);
    }
  }
}