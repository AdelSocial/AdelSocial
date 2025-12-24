import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionPlanScreen extends StatelessWidget {
  final int selectedPlan = 1;

  const SubscriptionPlanScreen({super.key}); // 0: Basic, 1: Premium, 2: VIP

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
          'Subscription Plans',
          style: TextStyle(
            color: Colors.pink[800],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Current Plan
          Padding(
            padding: EdgeInsets.all(16),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 40),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Premium Plan',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text('Active until Jan 30, 2024'),
                        ],
                      ),
                    ),
                    Chip(
                      label: Text('Active', style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.green,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Plans
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildPlanCard(
                  title: 'Basic',
                  price: 'Free',
                  period: 'Forever',
                  features: [
                    'Limited Live Streaming',
                    'Basic Support',
                    'Standard Quality',
                    'Ad Supported',
                  ],
                  isSelected: selectedPlan == 0,
                  onTap: () => _selectPlan(0),
                  buttonText: 'Current Plan',
                  buttonColor: Colors.grey,
                ),
                SizedBox(height: 16),
                _buildPlanCard(
                  title: 'Premium',
                  price: '₹999',
                  period: 'per month',
                  features: [
                    'Unlimited Live Streaming',
                    'Priority Support',
                    'HD Quality',
                    'Ad Free Experience',
                    'Custom Badge',
                    'Early Access to Features',
                  ],
                  isSelected: selectedPlan == 1,
                  onTap: () => _selectPlan(1),
                  buttonText: 'Current Plan',
                  buttonColor: Colors.pink,
                ),
                SizedBox(height: 16),
                _buildPlanCard(
                  title: 'VIP',
                  price: '₹2,499',
                  period: 'per month',
                  features: [
                    'All Premium Features',
                    '24/7 Dedicated Support',
                    '4K Ultra HD Quality',
                    'Exclusive VIP Badge',
                    'Revenue Share Bonus',
                    'Custom Emotes',
                    'Priority in Discovery',
                  ],
                  isSelected: selectedPlan == 2,
                  onTap: () => _selectPlan(2),
                  buttonText: 'Upgrade to VIP',
                  buttonColor: Colors.purple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required String period,
    required List<String> features,
    required bool isSelected,
    required VoidCallback onTap,
    required String buttonText,
    required Color buttonColor,
  }) {
    return Card(
      elevation: isSelected ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Colors.pink : Colors.transparent,
          width: 2,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              price,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.pink),
            ),
            Text(
              period,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),
            ...features.map((feature) => Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 20),
                  SizedBox(width: 8),
                  Text(feature),
                ],
              ),
            )),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }

  void _selectPlan(int planId) {
    if (planId == selectedPlan) {
      Get.snackbar(
        'Already Active',
        'You are already on this plan',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    } else {
      Get.dialog(
        AlertDialog(
          title: Text('Change Subscription Plan'),
          content: Text('Are you sure you want to change your subscription plan?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                Get.snackbar(
                  'Success',
                  'Subscription plan updated successfully!',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              },
              child: Text('Confirm'),
            ),
          ],
        ),
      );
    }
  }
}