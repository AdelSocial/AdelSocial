import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'navigation/home_screen.dart';
import 'navigation/live_stream_screen.dart';
import 'navigation/setting screen.dart';
import 'navigation/subscription_screen.dart';

class DashScreen extends StatefulWidget {
  const DashScreen({super.key});

  @override
  State<DashScreen> createState() => _DashScreenState();
}

class _DashScreenState extends State<DashScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const LiveStreamScreen(),
    const SubscriptionScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: _buildCustomBottomNavBar(),
    );
  }

  Widget _buildCustomBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1B2B41),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stream_outlined),
            activeIcon: Icon(Icons.stream),
            label: 'Live',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            activeIcon: Icon(Icons.star),
            label: 'Premium',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}






