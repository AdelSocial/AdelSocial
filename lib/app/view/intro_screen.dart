import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model_project/app/controller/intro_controller.dart';
import 'package:model_project/app/view/verification_screen.dart';

class IntroScreen extends StatelessWidget {
  final IntroController controller = Get.put(IntroController());

  IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Stack(
        children: [

          PageView.builder(
            controller: controller.pageController,
            itemCount: controller.sliderData.length,
            onPageChanged: controller.onPageChanged,
            itemBuilder: (context, index) {
              final data = controller.sliderData[index];
              return Stack(
                children: [
                  Image.asset(
                    data['image']!,
                    fit: BoxFit.cover,
                    width: context.width,
                    height: context.height,
                  ),
                  Positioned(
                    bottom: context.height * 0.2,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          Text(
                            data['title']!,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 10,
                                  color: Colors.black54,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.pink.withOpacity(0.2),
                  Colors.pink.withOpacity(0.5),
                ],
              ),
            ),
          ),

          // Page Indicators
          Positioned(
            top: context.height * 0.06,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                controller.sliderData.length,
                    (index) => _buildPageIndicator(index),
              ),
            ),
          ),

          // Skip Button
          Positioned(
            top: context.height * 0.05,
            right: 20,
            child: TextButton(
              onPressed: () {
                Get.off(() => VerificationScreen());
              },
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: const Text(
                'Skip',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),

          // Get Started Button
          Positioned(
            bottom: context.height * 0.08,
            left: 20,
            right: 20,
            child: Column(
              children: [
                _buildGetStartedButton(),
                const SizedBox(height: 16),
                Text(
                  'Swipe to explore more',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    return Obx(() {
      final isActive = controller.currentPage.value == index;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: 8,
        width: isActive ? 24 : 8,
        decoration: BoxDecoration(
          color:
          isActive ? Colors.pink : Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: Colors.pink.withOpacity(0.5),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildGetStartedButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          Get.off(() => VerificationScreen());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: Colors.pink.withOpacity(0.5),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Get Started'),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_rounded, size: 20),
          ],
        ),
      ),
    );
  }
}
