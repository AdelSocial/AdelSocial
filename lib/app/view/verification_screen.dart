import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:get/get.dart';
import 'package:model_project/app/app_routes.dart';
import '../controller/verification_controller.dart';

class VerificationScreen extends StatelessWidget {
  VerificationScreen({super.key});

  final VerificationController controller = Get.put(VerificationController());
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          height: context.height,
          width: context.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/background.png"),
            ),
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBackButton(),
                const SizedBox(height: 60),
                _buildHeader(),
                const SizedBox(height: 8),
                _buildDescription(),
                const SizedBox(height: 40),
                _buildPhoneInput(),
                const SizedBox(height: 30),
                _buildVerifyButton(),
                const SizedBox(height: 20),
                _buildTermsText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTermsText() => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(fontSize: 14, color: Colors.black, height: 1.4),
        children: [
          const TextSpan(text: 'By clicking on continue you agree with our '),
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(color: Colors.pink[600], fontWeight: FontWeight.w600),
            recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed(AppRoutes.privacyPolicy),
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Terms & Conditions',
            style: TextStyle(color: Colors.pink[600], fontWeight: FontWeight.w600),
            recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed(AppRoutes.termsConditions),
          ),
        ],
      ),
    ),
  );

  Widget _buildBackButton() => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(color: Colors.pink.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2)),
      ],
    ),
    child: IconButton(
      onPressed: () => Get.back(),
      icon: Icon(Icons.arrow_back_rounded, color: Colors.pink[600]),
    ),
  );

  Widget _buildHeader() => Center(
    child: Text(
      'Enter Phone Number',
      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.pink[800], height: 1.2),
    ),
  );

  Widget _buildDescription() => Center(
    child: Text(
      'Please enter your phone number to continue',
      style: TextStyle(fontSize: 16, color: Colors.pink[700]!.withOpacity(0.8), height: 1.5),
    ),
  );

  Widget _buildPhoneInput() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Mobile Number', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.pink[700])),
      const SizedBox(height: 12),
      IntlPhoneField(
        controller: phoneController,
        initialCountryCode: 'IN',
        disableLengthCheck: true,
        flagsButtonPadding: const EdgeInsets.only(left: 16),
        dropdownIconPosition: IconPosition.trailing,
        dropdownTextStyle: TextStyle(color: Colors.pink[700], fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: 'Phone Number',
          hintStyle: TextStyle(color: Colors.grey[600]),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
        validator: (phone) {
          if (phone == null || phone.number.isEmpty) {
            return 'Please enter your mobile number';
          }
          if (phone.number.length < 10) {
            return 'Please enter a valid 10-digit number';
          }
          return null;
        },
        onChanged: (phone) {
          // Optional: Real-time validation
        },
      ),
    ],
  );

  Widget _buildVerifyButton() => Obx(() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: controller.isLoading.value
            ? null : () {
          if (formKey.currentState!.validate()) {
            final phoneNumber = "+91${phoneController.text.trim()}";
            controller.sendOTP(phoneNumber);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink[500],
          foregroundColor: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          disabledBackgroundColor: Colors.pink[300],
        ),
        child: controller.isLoading.value
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white
          ),
        )
            : const Text(
            'Continue',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)
        ),
      ),
    );
  });
}