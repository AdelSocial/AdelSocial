import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'create_profile_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key, required Map<String, String> arguments});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isLoading = false;
  int _countdown = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    // _startCountdown();
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
        _startCountdown();
      } else {
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 50),
          height: context.height,
          width: context.width,
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/background.png"))
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBackButton(),
              const SizedBox(height: 40),

              // Header with Icon
              _buildHeader(),
              const SizedBox(height: 20),

              // Description
              _buildDescription(),
              const SizedBox(height: 40),

              // OTP Input Fields
              _buildOtpInputs(),
              const SizedBox(height: 20),

              // Countdown Timer
              _buildCountdownTimer(),
              const SizedBox(height: 30),

              // Verify Button
              _buildVerifyButton(),
              const SizedBox(height: 30),

              // Resend Option
              _buildResendOption(),

              // Alternative Options
              // _buildAlternativeOptions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(Icons.arrow_back_rounded, color: Colors.pink[600]),
        style: IconButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.pink,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              Icons.verified_user_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Enter OTP',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.pink[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Center(
      child: Column(
        children: [
          Text(
            'We have sent a verification code to',
            style: TextStyle(
              fontSize: 16,
              color: Colors.pink[700]!.withOpacity(0.8),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '+91 •••• •••789',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.pink[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpInputs() {
    return Column(
      children: [
        Text(
          'Enter 6-digit code',
          style: TextStyle(
            fontSize: 14,
            color: Colors.pink[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) => _buildOtpDigit(index)),
        ),
      ],
    );
  }

  Widget _buildOtpDigit(int index) {
    return Container(
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.pink[200]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.pink!, width: 2),
          ),
        ),
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.pink[800],
        ),
        onChanged: (value) {
          if (value.length == 1 && index < 5) {
            _focusNodes[index + 1].requestFocus();
          }
          if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }

          // Auto verify when all fields are filled
          if (value.length == 1 && index == 5) {
            _autoVerifyIfComplete();
          }
        },
      ),
    );
  }

  void _autoVerifyIfComplete() {
    bool allFilled = _otpControllers.every((controller) => controller.text.isNotEmpty);
    if (allFilled) {
      Future.delayed(const Duration(milliseconds: 300), () {
        // _verifyOtp();
      });
    }
  }

  Widget _buildCountdownTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.access_time_rounded,
          color: Colors.pink[500],
          size: 18,
        ),
        const SizedBox(width: 6),
        Text(
          'Resend code in $_countdown seconds',
          style: TextStyle(
            color: Colors.pink[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildVerifyButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: (){
          Get.to(() => CreateProfileScreen());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink[500],
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: Colors.pink.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: _isLoading
            ? SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Verify OTP'),
            SizedBox(width: 8),
            Icon(Icons.verified_rounded, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildResendOption() {
    return Center(
      child: _canResend
          ? Column(
        children: [
          Text(
            "Didn't receive the code?",
            style: TextStyle(
              color: Colors.pink[700],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _resendOtp,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.pink[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                'RESEND OTP',
                style: TextStyle(
                  color: Colors.pink[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      )
          : Text(
        "Didn't receive code?",
        style: TextStyle(
          color: Colors.pink[700],
          fontSize: 14,
        ),
      ),
    );
  }

  // Widget _buildAlternativeOptions() {
  //   return Container(
  //     margin: const EdgeInsets.only(top: 40),
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(20),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.pink.withOpacity(0.1),
  //           blurRadius: 15,
  //           offset: const Offset(0, 5),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       children: [
  //         Text(
  //           'Having trouble?',
  //           style: TextStyle(
  //             color: Colors.pink[700],
  //             fontWeight: FontWeight.w600,
  //             fontSize: 16,
  //           ),
  //         ),
  //         const SizedBox(height: 16),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //           children: [
  //             _buildAlternativeOption(
  //               icon: Icons.call_rounded,
  //               text: 'Call Me',
  //               onTap: () {
  //                 Get.snackbar(
  //                   'Call Request',
  //                   'We will call you shortly with the code',
  //                   backgroundColor: Colors.pink[500],
  //                   colorText: Colors.white,
  //                 );
  //               },
  //             ),
  //             _buildAlternativeOption(
  //               icon: Icons.email_rounded,
  //               text: 'Email',
  //               onTap: () {
  //                 Get.snackbar(
  //                   'Email Sent',
  //                   'OTP sent to your email address',
  //                   backgroundColor: Colors.pink[500],
  //                   colorText: Colors.white,
  //                 );
  //               },
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildAlternativeOption({
  //   required IconData icon,
  //   required String text,
  //   required VoidCallback onTap,
  // }) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Column(
  //       children: [
  //         Container(
  //           width: 50,
  //           height: 50,
  //           decoration: BoxDecoration(
  //             color: Colors.pink[50],
  //             shape: BoxShape.circle,
  //             border: Border.all(color: Colors.pink[200]!),
  //           ),
  //           child: Icon(
  //             icon,
  //             color: Colors.pink[600],
  //             size: 24,
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         Text(
  //           text,
  //           style: TextStyle(
  //             color: Colors.pink[700],
  //             fontWeight: FontWeight.w500,
  //             fontSize: 12,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // void _verifyOtp() async {
  //   String otp = _otpControllers.map((controller) => controller.text).join();
  //   if (otp.length != 6) {
  //     Get.snackbar(
  //       'Incomplete OTP',
  //       'Please enter all 6 digits',
  //       backgroundColor: Colors.pink[500],
  //       colorText: Colors.white,
  //     );
  //     return;
  //   }
  //
  //   setState(() => _isLoading = true);
  //
  //   // Simulate API call
  //   await Future.delayed(const Duration(seconds: 2));
  //
  //   setState(() => _isLoading = false);
  //
  //   // Navigate to home screen
  //   // Get.offAllNamed('/home');
  // }

  void _resendOtp() {
    if (_canResend) {
      setState(() {
        _canResend = false;
        _countdown = 30;
      });
      _startCountdown();

        for (var controller in _otpControllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();

      Get.snackbar(
        'OTP Resent',
        'New verification code sent',
        backgroundColor: Colors.pink[500],
        colorText: Colors.white,
      );
    }
  }
}