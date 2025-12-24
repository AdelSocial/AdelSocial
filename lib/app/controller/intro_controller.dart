
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntroController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final List<Map<String, String>> sliderData = [
    {'image': 'assets/splash1.jpeg', 'title': 'WELCOME TO MY OFFICIAL APP'},
    {'image': 'assets/splash10.jpeg', 'title': 'EXCLUSIVE CONTENT'},
    {'image': 'assets/splash3.jpeg', 'title': 'CONNECT WITH ME 1-1'},
    {'image': 'assets/splash4.jpeg', 'title': 'WATCH ME LIVE'},
  ];

  void onPageChanged(int page) {
    currentPage.value = page;
  }

  @override
  void onInit() {
    super.onInit();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 3), () {
      if (pageController.hasClients) {
        if (currentPage.value < sliderData.length - 1) {
          pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
        _startAutoSlide();
      }
    });
  }
}
