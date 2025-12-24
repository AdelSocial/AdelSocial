import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPolicyScreen extends StatelessWidget {
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
          'Privacy Policy',
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

                    _buildSectionTitle('1. Information We Collect'),
                    _buildParagraph('We collect information to provide better services to our users:'),
                    _buildBulletPoint('Personal Information (name, email, phone number)'),
                    _buildBulletPoint('Profile Information and preferences'),
                    _buildBulletPoint('Streaming data and viewer interactions'),
                    _buildBulletPoint('Payment and transaction information'),
                    _buildBulletPoint('Device information and usage data'),

                    _buildSectionTitle('2. How We Use Information'),
                    _buildParagraph('We use the information we collect for:'),
                    _buildBulletPoint('Providing and improving our services'),
                    _buildBulletPoint('Personalizing user experience'),
                    _buildBulletPoint('Processing payments and transactions'),
                    _buildBulletPoint('Communicating with users'),
                    _buildBulletPoint('Ensuring platform security'),

                    _buildSectionTitle('3. Information Sharing'),
                    _buildParagraph('We do not sell your personal information. We may share information with:'),
                    _buildBulletPoint('Service providers who assist our operations'),
                    _buildBulletPoint('Legal authorities when required by law'),
                    _buildBulletPoint('Other users as per your privacy settings'),

                    _buildSectionTitle('4. Data Security'),
                    _buildParagraph('We implement appropriate security measures to protect your personal information from unauthorized access and disclosure.'),

                    _buildSectionTitle('5. Your Rights'),
                    _buildParagraph('You have the right to:'),
                    _buildBulletPoint('Access your personal information'),
                    _buildBulletPoint('Correct inaccurate data'),
                    _buildBulletPoint('Delete your personal information'),
                    _buildBulletPoint('Object to processing of your data'),
                    _buildBulletPoint('Data portability'),

                    _buildSectionTitle('6. Contact Us'),
                    _buildParagraph('If you have any questions about this Privacy Policy, please contact us at privacy@streamapp.com.'),

                    SizedBox(height: 30),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //   children: [
                    //     OutlinedButton(
                    //       onPressed: () => _downloadPrivacyPolicy(),
                    //       child: Text('Download PDF'),
                    //     ),
                    //     ElevatedButton(
                    //       onPressed: () => _managePrivacySettings(),
                    //       style: ElevatedButton.styleFrom(
                    //         backgroundColor: Colors.pink,
                    //         foregroundColor: Colors.white,
                    //       ),
                    //       child: Text('Privacy Settings'),
                    //     ),
                    //   ],
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

  void _downloadPrivacyPolicy() {
    Get.snackbar(
      'Download Started',
      'Privacy Policy PDF is being downloaded',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void _managePrivacySettings() {
    Get.dialog(
      AlertDialog(
        title: Text('Privacy Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: Text('Personalized Ads'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: Text('Data Analytics'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: Text('Email Notifications'),
              value: false,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: Text('Push Notifications'),
              value: true,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Settings Saved',
                'Privacy settings updated successfully',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}