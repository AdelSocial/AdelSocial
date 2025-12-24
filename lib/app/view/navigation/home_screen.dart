import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model_project/app/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: context.height,
        width: context.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/background.png"),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header Image with Wallet & Message Icons
              Stack(
                alignment: AlignmentGeometry.bottomRight,
                children: [
                  _buildHeaderImage(),
                  // Wallet and Message Icons
                  Positioned(
                    bottom: 10,
                    child: Row(
                      children: [
                        _buildIconWithText(
                          icon: Icons.wallet_rounded,
                          text: "Wallet",
                          onTap: () {
                            Get.toNamed(AppRoutes.wallet);
                          },
                        ),
                        const SizedBox(width: 15),
                        _buildIconWithText(
                          icon: Icons.message_rounded,
                          text: "Messages",
                          onTap: () {
                            Get.toNamed(AppRoutes.messages);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Welcome Section
              _buildWelcomeSection(),
              const SizedBox(height: 20),

              // Upcoming Events
              _buildEventsSection(),
              const SizedBox(height: 20),

              // Subscriptions
              _buildSubscriptionSection(),
              const SizedBox(height: 20),

              // Let's Connect
              _buildConnectSection(),
              const SizedBox(height: 20),

              // Exclusive Feed
              _buildExclusiveFeed(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconWithText({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.pink[600],
              size: 20,
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                color: Colors.pink[600],
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Image.asset(
      "assets/splash3.jpeg",
      fit: BoxFit.cover,
      height: context.height / 1.6,
      width: context.width,
    );
  }

  Widget _buildWelcomeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            "Hi, I'm Laxmi",
            style: TextStyle(
              fontSize: 25,
              color: Colors.pink[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            textAlign: TextAlign.center,
            "Welcome to my Official App 🔥 Get access to never seen content, Exclusive live streamings & connect with me personally",
            style: TextStyle(
              fontSize: 15,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            "Upcoming Events",
            style: TextStyle(
              fontSize: 18,
              color: Colors.pink[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_busy_rounded, color: Colors.grey[500]),
                const SizedBox(width: 10),
                Text(
                  "No events available",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            "Subscriptions",
            style: TextStyle(
              fontSize: 18,
              color: Colors.pink[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    "assets/splash1.jpeg",
                    fit: BoxFit.cover,
                    height: 120,
                    width: 100,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "THE PREMIUM MEMBERSHIP",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.pink[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "This Super Premium collection is for my superfans! Level up to unlock the VIP zone of my premium content and get a chance to join exclusive sessions!",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          // Handle show more
                        },
                        child: Text(
                          "Show more",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.pink[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 45,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.pink[500],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(
                            "Subscribe Now ₹5,999",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectSection() {
    return Column(
      children: [
        Text(
          "Let's Connect",
          style: TextStyle(
            fontSize: 18,
            color: Colors.pink[600],
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: 3,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: const EdgeInsets.only(right: 15),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Get a personalised video message from me for your special occasion! Whether it's a Birthday or Anniversary, make it memorable with a personal touch.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.pink[600],
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        // Handle booking
                      },
                      child: Container(
                        height: 45,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.pink[500],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Center(
                          child: Text(
                            "Book Now ₹10,000",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExclusiveFeed() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            "Exclusive Feed",
            style: TextStyle(
              fontSize: 18,
              color: Colors.pink[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ListView.separated(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return _buildFeedItem(index);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 20);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeedItem(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with profile and menu
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
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.more_vert, color: Colors.grey[600]),
              ],
            ),
          ),

          // Post Image
          Image.asset(
            "assets/splash3.jpeg",
            fit: BoxFit.cover,
            height: context.height / 2,
            width: context.width,
          ),

          // Engagement Icons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.favorite_border_rounded, color: Colors.grey[600]),
                    const SizedBox(width: 5),
                    Text(
                      "576",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.chat_bubble_outline_rounded, color: Colors.grey[600]),
                    const SizedBox(width: 5),
                    Text(
                      "24",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.currency_rupee_rounded, color: Colors.grey[600]),
                    const SizedBox(width: 5),
                    Text(
                      "576",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.card_giftcard_rounded, color: Colors.grey[600]),
                    const SizedBox(width: 5),
                    Text(
                      "4",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Caption and Details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "pristly love it bby",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    // Handle view comments
                  },
                  child: const Text(
                    "View all comments",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "24 Sep 2025 | 10:18 PM",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}