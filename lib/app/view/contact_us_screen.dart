import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactUsScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

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
          'Contact Us',
          style: TextStyle(
            color: Colors.pink[800],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Contact Information
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildContactInfo(
                      icon: Icons.email,
                      title: 'Email Us',
                      subtitle: 'support@streamapp.com',
                      onTap: () => _sendEmail(),
                    ),
                    SizedBox(height: 16),
                    _buildContactInfo(
                      icon: Icons.phone,
                      title: 'Call Us',
                      subtitle: '+1 (555) 123-4567',
                      onTap: () => _makeCall(),
                    ),
                    SizedBox(height: 16),
                    _buildContactInfo(
                      icon: Icons.chat,
                      title: 'Live Chat',
                      subtitle: 'Available 24/7',
                      onTap: () => _startLiveChat(),
                    ),
                    SizedBox(height: 16),
                    _buildContactInfo(
                      icon: Icons.location_on,
                      title: 'Visit Us',
                      subtitle: '123 Stream Street, Digital City',
                      onTap: () => _openLocation(),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            // Contact Form
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Send us a Message',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),

                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    SizedBox(height: 16),

                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16),

                    TextField(
                      controller: subjectController,
                      decoration: InputDecoration(
                        labelText: 'Subject',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.subject),
                      ),
                    ),
                    SizedBox(height: 16),

                    TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        labelText: 'Message',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 5,
                    ),
                    SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _submitForm(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Send Message'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            // FAQ Section
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Frequently Asked Questions',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    _buildFAQItem(
                      question: 'How do I reset my password?',
                      answer: 'You can reset your password from the login screen by clicking "Forgot Password".',
                    ),
                    _buildFAQItem(
                      question: 'Can I change my subscription plan?',
                      answer: 'Yes, you can upgrade or downgrade your subscription plan at any time.',
                    ),
                    _buildFAQItem(
                      question: 'How do I report inappropriate content?',
                      answer: 'Use the report button on the content or contact our support team immediately.',
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: TextButton(
                        onPressed: () => _viewAllFAQs(),
                        child: Text('View All FAQs'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.pink.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.pink),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return ExpansionTile(
      title: Text(question, style: TextStyle(fontSize: 14)),
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(answer),
        ),
      ],
    );
  }

  void _sendEmail() {
    Get.snackbar(
      'Email Ready',
      'Opening email application...',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void _makeCall() {
    Get.snackbar(
      'Calling Support',
      'Opening phone dialer...',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _startLiveChat() {
    Get.snackbar(
      'Live Chat',
      'Connecting you with support agent...',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  void _openLocation() {
    Get.snackbar(
      'Location',
      'Opening maps application...',
      backgroundColor: Colors.purple,
      colorText: Colors.white,
    );
  }

  void _submitForm() {
    if (nameController.text.isEmpty || emailController.text.isEmpty ||
        subjectController.text.isEmpty || messageController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Simulate form submission
    Get.dialog(
      AlertDialog(
        title: Text('Message Sent'),
        content: Text('Thank you for contacting us! We will get back to you within 24 hours.'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
              Get.snackbar(
                'Success',
                'Your message has been sent successfully!',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _viewAllFAQs() {
    Get.snackbar(
      'FAQs',
      'Opening complete FAQ section...',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }
}