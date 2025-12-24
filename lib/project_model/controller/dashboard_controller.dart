
// controllers/dashboard_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  // Statistics Data
  var totalUsers = 1234.obs;
  var activeVideoCalls = 12.obs;
  var ongoingChats = 34.obs;
  var totalPosts = 56.obs;

  // User Engagement Data (Monthly)
  var userEngagement = <double>[60, 40, 20, 0, 45, 65, 80, 75, 90, 85, 70, 95].obs;
  void updateEngagementData(List<double> newData) {
    userEngagement.value = newData;
  }



   List<StatItem> statItems = [
    StatItem(
      title: 'Total Users',
      value: '1234',
      icon: Icons.people,
      color: Colors.blue,
    ),
    StatItem(
      title: 'Active Video Calls',
      value: '12',
      icon: Icons.videocam,
      color: Colors.green,
    ),
    StatItem(
      title: 'Ongoing Chats',
      value: '34',
      icon: Icons.chat,
      color: Colors.orange,
    ),
    StatItem(
      title: 'Total Posts',
      value: '56',
      icon: Icons.post_add,
      color: Colors.purple,
    ),
  ];


  // Service Usage Data
  var serviceUsage = <ServiceUsage>[
    ServiceUsage(name: 'Video', percentage: 65, color: Colors.blue),
    ServiceUsage(name: 'Audio', percentage: 45, color: Colors.green),
    ServiceUsage(name: 'Chat', percentage: 80, color: Colors.orange),
  ].obs;

  var premiumServices = <ServiceUsage>[
    ServiceUsage(name: 'Customize Post', percentage: 30, color: Colors.purple),
    ServiceUsage(name: 'Go Live', percentage: 55, color: Colors.red),
    ServiceUsage(name: 'Customize App', percentage: 25, color: Colors.teal),
  ].obs;
}




class ServiceUsage {
  final String name;
  final double percentage;
  final Color color;

  ServiceUsage({
    required this.name,
    required this.percentage,
    required this.color,
  });
}


class StatItem {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  StatItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}