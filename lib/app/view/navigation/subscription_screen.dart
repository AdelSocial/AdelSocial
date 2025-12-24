import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int activeIndex = 0;

  final List<String> sliderImages = [
    "assets/splash1.jpeg",
    "assets/splash2.jpeg",
    "assets/splash3.jpeg",
    "assets/splash10.jpeg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: context.width,
        height: context.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 50),
                child: _buildBackButton(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: _buildButton(),
              ),
              const SizedBox(height: 30),
              _buildExclusiveFeed(context),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(Icons.arrow_back_rounded,
                color: Colors.pink[600], size: 26),
          ),
          const SizedBox(width: 12),
          Text(
            'Subscription',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.pink[800],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.pink[800],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Text(
          'THE PREMIUM MEMBERSHIP',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }


  Widget _buildExclusiveFeed(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.separated(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          shrinkWrap: true,
          itemBuilder: (context, index) => _buildFeedItem(context, index),
          separatorBuilder: (_, __) => const SizedBox(height: 20),
        ),
      ],
    );
  }


  Widget _buildFeedItem(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.asset(
                        "assets/splash1.jpeg",
                        fit: BoxFit.cover,
                        height: 50,
                        width: 50,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Laxmi",
                      style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ],
                ),
                Icon(Icons.more_vert, color: Colors.grey[600]),
              ],
            ),
          ),

          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: context.height * 0.45,
                  viewportFraction: 1.0,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration:
                  const Duration(milliseconds: 800),
                  enlargeCenterPage: false,
                  onPageChanged: (index, reason) {
                    setState(() => activeIndex = index);
                  },
                ),
                items: sliderImages.map((imagePath) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  );
                }).toList(),
              ),
              Positioned(
                bottom: 10,
                child: AnimatedSmoothIndicator(
                  activeIndex: activeIndex,
                  count: sliderImages.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: Colors.pinkAccent,
                    dotColor: Colors.white,
                    dotHeight: 8,
                    dotWidth: 8,
                    expansionFactor: 3,
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _iconWithCount(Icons.favorite_border_rounded, "576"),
                _iconWithCount(Icons.chat_bubble_outline_rounded, "24"),
                _iconWithCount(Icons.card_giftcard_rounded, "4"),
              ],
            ),
          ),

          // 📄 CAPTION + DATE
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "pristly love it bby ❤️",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => Get.snackbar(
                    'Comments',
                    'Opening comment section...',
                    backgroundColor: Colors.pink[50],
                    colorText: Colors.pink[900],
                    snackPosition: SnackPosition.BOTTOM,
                  ),
                  child: const Text(
                    "View all comments",
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "24 Sep 2025 • 10:18 PM",
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ❤️ ICON + COUNT
  Widget _iconWithCount(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 22),
        const SizedBox(width: 5),
        Text(count, style: TextStyle(color: Colors.grey[700])),
      ],
    );
  }
}
