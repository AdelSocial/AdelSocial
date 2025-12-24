import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.pink[600]),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Terms & Conditions',
          style: TextStyle(
            color: Colors.pink[800],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last Updated: January 15, 2024',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    SizedBox(height: 20),
                    _buildSectionTitle('1. Acceptance of Terms'),
                    _buildParagraph(
                        'By accessing and using our live streaming platform, you accept and agree to be bound by the terms and provision of this agreement.'),

                    _buildSectionTitle('2. User Responsibilities'),
                    _buildParagraph('As a user of our platform, you agree to:'),
                    _buildBulletPoint('Provide accurate and complete information during registration'),
                    _buildBulletPoint('Maintain the security of your password and account'),
                    _buildBulletPoint('Notify us immediately of any unauthorized use of your account'),
                    _buildBulletPoint('Take responsibility for all activities that occur under your account'),

                    _buildSectionTitle('3. Content Guidelines'),
                    _buildParagraph('Users must not stream content that:'),
                    _buildBulletPoint('Is illegal, offensive, or inappropriate'),
                    _buildBulletPoint('Infringes on intellectual property rights'),
                    _buildBulletPoint('Contains hate speech or discrimination'),
                    _buildBulletPoint('Promotes violence or harmful activities'),

                    _buildSectionTitle('4. Subscription and Payments'),
                    _buildParagraph(
                        'Premium features require subscription payments. All payments are non-refundable unless required by law.'),

                    _buildSectionTitle('5. Termination'),
                    _buildParagraph(
                        'We reserve the right to terminate or suspend access to our service immediately, without prior notice, for conduct that we believe violates these Terms.'),

                    _buildSectionTitle('6. Limitation of Liability'),
                    _buildParagraph(
                        'We shall not be held liable for any indirect, incidental, special, consequential or punitive damages resulting from your use of the service.'),

                    SizedBox(height: 30),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     Checkbox(value: true, onChanged: (value) {}),
                    //     Expanded(child: Text('I have read and agree to the Terms & Conditions')),
                    //   ],
                    // ),
                    // SizedBox(height: 20),
                    // Center(
                    //   child: ElevatedButton(
                    //     onPressed: () => _acceptTerms(),
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Colors.pink,
                    //       foregroundColor: Colors.white,
                    //       padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    //     ),
                    //     child: Text('Accept Terms & Conditions'),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.pink[800]),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: TextStyle(fontSize: 14, height: 1.5),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontSize: 14)),
          Expanded(child: Text(text, style: TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  void _acceptTerms() {
    Get.snackbar(
      'Terms Accepted',
      'Thank you for accepting our Terms & Conditions',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    Get.back();
  }
}