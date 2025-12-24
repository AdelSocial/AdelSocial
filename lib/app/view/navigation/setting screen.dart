
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model_project/app/app_routes.dart';
import 'package:model_project/app/view/navigation/admin_login_screen.dart';
import '../contact_us_screen.dart';
import '../privacy_policy_screen.dart';
import '../profile_screen.dart';
import '../subscription_plan_screen.dart';
import '../terms_conditions_screen.dart';
import '../transaction_history_screen.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          height: context.height,
          width: context.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/background.png")
              )
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildBackButton(),
                    Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: _buildHeader(),
                    ),
                    Text(""),
                  ],
                ),

                SizedBox(height: 30),
                // Profile Section
                _buildSettingsCard(
                  title: 'Profile',
                  icon: Icons.person_rounded,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                ),

                // Transaction History
                _buildSettingsCard(
                  title: 'Transaction History',
                  icon: Icons.history_rounded,
                  color: Colors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TransactionHistoryScreen()),
                    );
                  },
                ),

                // Subscription Plan
                _buildSettingsCard(
                  title: 'Subscription Plan',
                  icon: Icons.workspace_premium_rounded,
                  color: Colors.amber,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SubscriptionPlanScreen()),
                    );
                  },
                ),

                // Terms & Conditions
                _buildSettingsCard(
                  title: 'Terms & Conditions',
                  icon: Icons.description_rounded,
                  color: Colors.purple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TermsConditionsScreen()),
                    );
                  },
                ),

                // Privacy Policy
                _buildSettingsCard(
                  title: 'Privacy Policy',
                  icon: Icons.privacy_tip_rounded,
                  color: Colors.teal,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
                    );
                  },
                ),

                // Admin Login (New Addition)
                _buildSettingsCard(
                  title: 'Admin Login',
                  icon: Icons.admin_panel_settings_rounded,
                  color: Colors.red,
                  onTap: () {
                    Get.toNamed(AppRoutes.adminLogin);
                  },
                ),

                // Contact Us
                _buildSettingsCard(
                  title: 'Contact Us',
                  icon: Icons.contact_support_rounded,
                  color: Colors.orange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ContactUsScreen()),
                    );

                  },
                ),
                const SizedBox(height: 30),

                // Logout Button
                _buildLogoutButton(),
                const SizedBox(height: 5),
                _buildDeleteButton(),
              ],
            ),
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
    return Text(
      'Settings',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.pink[800],
        height: 1.2,
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.grey[600],
            size: 16,
          ),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.delete,
            color: Colors.red,
            size: 24,
          ),
        ),
        title: const Text(
          'Delete Account',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.red,
          ),
        ),
        trailing: Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.red,
            size: 16,
          ),
        ),
        onTap: () {
          _showDeleteConfirmation();
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.logout_rounded,
            color: Colors.red,
            size: 24,
          ),
        ),
        title: const Text(
          'Logout',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.red,
          ),
        ),
        trailing: Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.red,
            size: 16,
          ),
        ),
        onTap: () {
          _showLogoutConfirmation();
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  void _showLogoutConfirmation() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Logout',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.offAllNamed(AppRoutes.login);
              Get.snackbar(
                'Logged Out',
                'You have been successfully logged out',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Delete Account',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        content: const Text('This action cannot be undone. All your data will be permanently deleted.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.offAllNamed(AppRoutes.login);
              Get.snackbar(
                'Account Deleted',
                'Your account has been permanently deleted',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}