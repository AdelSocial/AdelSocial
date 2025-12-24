import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController(text: "Sophia Miller");
  final TextEditingController emailController = TextEditingController(text: "sophia@example.com");
  final TextEditingController phoneController = TextEditingController(text: "+1 234 567 8900");
  final TextEditingController bioController = TextEditingController(text: "Professional model and content creator");

  ProfileScreen({super.key});

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
          'Profile',
          style: TextStyle(
            color: Colors.pink[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.pink[600]),
            onPressed: () => _editProfile(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Picture
            Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.pink, width: 3),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      "assets/splash1.jpeg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Sophia Miller",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "Professional Model",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 30),

            // Profile Information
            _buildInfoCard(
              icon: Icons.person,
              title: "Personal Information",
              children: [
                _buildInfoRow("Full Name", "Sophia Miller"),
                _buildInfoRow("Email", "sophia@example.com"),
                _buildInfoRow("Phone", "+1 234 567 8900"),
                _buildInfoRow("Gender", "Female"),
                _buildInfoRow("Date of Birth", "March 15, 1995"),
              ],
            ),

            SizedBox(height: 20),

            _buildInfoCard(
              icon: Icons.work,
              title: "Professional Information",
              children: [
                _buildInfoRow("Category", "Fashion Model"),
                _buildInfoRow("Experience", "5 Years"),
                _buildInfoRow("Location", "New York, USA"),
                _buildInfoRow("Languages", "English, Spanish"),
              ],
            ),

            SizedBox(height: 20),

            _buildInfoCard(
              icon: Icons.star,
              title: "Statistics",
              children: [
                _buildInfoRow("Total Followers", "125K"),
                _buildInfoRow("Total Likes", "1.2M"),
                _buildInfoRow("Live Sessions", "347"),
                _buildInfoRow("Rating", "4.9/5.0"),
              ],
            ),

            SizedBox(height: 30),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _editProfile(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text("Edit Profile"),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required String title, required List<Widget> children}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.pink, size: 20),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

// In ProfileScreen, update the _editProfile method:
  void _editProfile() {
    Get.to(() => EditProfileScreen());
  }


  void _changePassword() {
    Get.defaultDialog(
      title: "Change Password",
      content: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: "Current Password",
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              labelText: "New Password",
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              labelText: "Confirm New Password",
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
            Get.snackbar(
              'Success',
              'Password changed successfully!',
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          },
          child: Text("Update"),
        ),
      ],
    );
  }
}