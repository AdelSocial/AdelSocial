
// file: live_stream_screen.dart
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveStreamScreen extends StatefulWidget {
  const LiveStreamScreen({super.key});

  @override
  State<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen>
    with SingleTickerProviderStateMixin {
  // For floating hearts
  final List<_HeartModel> _hearts = [];
  final Random _rand = Random();

  // For comments (simulated incoming messages)
  final List<String> _comments = [
    "Looking gorgeous! ✨",
    "Where are you from?",
    "Love this outfit 😍",
    "Can you sing a song?",
    "Sending love ❤️",
  ];
  final ScrollController _commentsScroll = ScrollController();
  Timer? _commentsTimer;
  final TextEditingController _messageController = TextEditingController();

  // For like count & viewers
  int _likes = 576;
  int _viewers = 1243;

  // Animation controller for hearts
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController =
    AnimationController(vsync: this, duration: const Duration(seconds: 5))
      ..repeat();

    // Simulate incoming comments every few seconds
    _commentsTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _addIncomingComment();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _commentsTimer?.cancel();
    _commentsScroll.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _addIncomingComment() {
    final sample = _comments[_rand.nextInt(_comments.length)];
    setState(() {
      _liveComments.insert(0, _LiveComment(
        message: sample,
        time: DateTime.now(),
      ));
      // keep list short
      if (_liveComments.length > 40) _liveComments.removeLast();
    });

    // auto-scroll little bit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_commentsScroll.hasClients) {
        _commentsScroll.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // live comments list (newest first)
  final List<_LiveComment> _liveComments = [];

  void _spawnHeart({Color? color}) {
    // spawn a heart with random horizontal start
    final startX = 0.6 + (_rand.nextDouble() * 0.35); // right side bias
    final size = 20.0 + _rand.nextDouble() * 26;
    final hue = color ?? (Colors.pink.withOpacity(0.9));
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    setState(() {
      _hearts.add(_HeartModel(id: id, dx: startX, size: size, color: hue));
    });

    // remove after animation duration
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _hearts.removeWhere((h) => h.id == id);
      });
    });
  }

  void _onSendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _liveComments.insert(0, _LiveComment(message: text, time: DateTime.now()));
      if (_liveComments.length > 40) _liveComments.removeLast();
      _messageController.clear();
    });

    // spawn a small heart when user sends message
    _spawnHeart();
  }

  @override
  Widget build(BuildContext context) {
    final w = context.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // ===== VIDEO / BACKGROUND (replace with real video widget) =====
            Positioned.fill(
              child: Container(
                color: Colors.black,
                child: Stack(
                  children: [
                    // Placeholder image - replace with your live video widget (AgoraView / VideoPlayer etc.)
                    Positioned.fill(
                      child: Image.asset(
                        "assets/splash10.jpeg",
                        fit: BoxFit.cover,
                        color: Colors.black.withOpacity(0.15),
                        colorBlendMode: BlendMode.darken,
                      ),
                    ),

                    // top gradient for readability
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 220,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black54,
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ===== Top Bar: profile, live badge, viewers =====
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: Row(
                children: [
                  // profile
                  _profileCard(),
                  const Spacer(),

                  // live badge + viewers
                  _liveInfo(),
                ],
              ),
            ),

            // ===== Left side: comments (semi transparent) =====
            Positioned(
              left: 12,
              top: 110,
              bottom: 120,
              width: w * 0.62,
              child: _commentsPanel(),
            ),

            // ===== Right quick action buttons =====
            Positioned(
              right: 12,
              bottom: 150,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _rightActionButton(
                    icon: Icons.favorite,
                    label: '$_likes',
                    onTap: () {
                      setState(() {
                        _likes += 1;
                      });
                      _spawnHeart();
                    },
                  ),
                  const SizedBox(height: 14),
                  _rightActionButton(
                    icon: Icons.card_giftcard,
                    label: 'Gift',
                    onTap: () {
                      // show gift modal (demo)
                      _showGiftDialog();
                    },
                  ),
                  const SizedBox(height: 14),
                  _rightActionButton(
                    icon: Icons.share,
                    label: 'Share',
                    onTap: () {
                      Get.snackbar('Share', 'Share link copied to clipboard (demo)',
                          backgroundColor: Colors.black87, colorText: Colors.white);
                    },
                  ),
                  const SizedBox(height: 14),
                  _rightActionButton(
                    icon: Icons.person_add_alt_1,
                    label: 'Follow',
                    onTap: () {
                      Get.snackbar('Followed', 'You followed the host',
                          backgroundColor: Colors.black87, colorText: Colors.white);
                    },
                  ),
                ],
              ),
            ),

            // ===== Floating hearts (rendered above video) =====
            Positioned.fill(
              child: IgnorePointer(
                child: Stack(
                  children: _hearts
                      .map((h) => _FloatingHeartWidget(
                    model: h,
                  ))
                      .toList(),
                ),
              ),
            ),

            // ===== Bottom message input area =====
            Positioned(
              left: 12,
              right: 12,
              bottom: 18,
              child: _messageInputRow(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileCard() {
    return Row(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white70, width: 1.2),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            image: const DecorationImage(
              image: AssetImage("assets/splash1.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Laxmi",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade700,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "LIVE",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "$_viewers watching",
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _liveInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: const [
          Icon(Icons.visibility, color: Colors.white70, size: 18),
          SizedBox(width: 6),
          Text("Live • 2.1K", style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _commentsPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // small header
          Row(
            children: const [
              Icon(Icons.chat_bubble, color: Colors.white70, size: 16),
              SizedBox(width: 6),
              Text("Live chat", style: TextStyle(color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              controller: _commentsScroll,
              reverse: true,
              itemCount: _liveComments.length,
              itemBuilder: (context, idx) {
                final c = _liveComments[idx];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundImage:
                        const AssetImage("assets/splash1.jpeg"),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            c.message,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatTimeAgo(c.time),
                        style:
                        const TextStyle(color: Colors.white54, fontSize: 10),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _rightActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 8,
                    offset: const Offset(0, 2)),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12))
        ],
      ),
    );
  }

  Widget _messageInputRow() {
    return Row(
      children: [
        // small gift quick button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(12),
          ),
          child: GestureDetector(
            onTap: _showGiftDialog,
            child: const Icon(Icons.card_giftcard, color: Colors.white),
          ),
        ),
        const SizedBox(width: 10),

        // message field
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                const Icon(Icons.emoji_emotions_outlined, color: Colors.white70),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Say something...',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                      isCollapsed: true,
                    ),
                    onSubmitted: (_) => _onSendMessage(),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _onSendMessage();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.pinkAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.send, color: Colors.white, size: 18),
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),

        // like quick
        GestureDetector(
          onTap: () {
            setState(() {
              _likes += 1;
            });
            _spawnHeart();
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.favorite, color: Colors.pinkAccent),
          ),
        ),
      ],
    );
  }

  void _showGiftDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SizedBox(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Send a Gift',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  children: List.generate(6, (i) {
                    return GestureDetector(
                      onTap: () {
                        Get.back();
                        // spawn hearts and increment likes as demo
                        for (int k = 0; k < 6; k++) _spawnHeart();
                        setState(() => _likes += 5);
                        Get.snackbar('Gift sent', 'Thank you! 🎁',
                            backgroundColor: Colors.black87, colorText: Colors.white);
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.card_giftcard,
                                color: Colors.white, size: 36),
                          ),
                          const SizedBox(height: 8),
                          const Text('50', style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static String _formatTimeAgo(DateTime t) {
    final diff = DateTime.now().difference(t);
    if (diff.inSeconds < 60) return "${diff.inSeconds}s";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m";
    if (diff.inHours < 24) return "${diff.inHours}h";
    return "${diff.inDays}d";
  }
}

// ---------- helper models & widgets ----------

class _HeartModel {
  final String id;
  final double dx; // relative position (0..1) from left
  final double size;
  final Color color;

  _HeartModel({
    required this.id,
    required this.dx,
    required this.size,
    required this.color,
  });
}

class _FloatingHeartWidget extends StatefulWidget {
  final _HeartModel model;
  const _FloatingHeartWidget({required this.model});

  @override
  State<_FloatingHeartWidget> createState() => _FloatingHeartWidgetState();
}

class _FloatingHeartWidgetState extends State<_FloatingHeartWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _animY;
  late final Animation<double> _animOpacity;
  late final double startLeft;

  @override
  void initState() {
    super.initState();
    startLeft = widget.model.dx;
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..forward();

    _animY = Tween<double>(begin: 0, end: -420).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _animOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.6, 1.0)),
    );

    _ctrl.addListener(() {
      setState(() {});
    });
    _ctrl.addStatusListener((s) {
      if (s == AnimationStatus.completed) _ctrl.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final leftPx = MediaQuery.of(context).size.width * startLeft;
    final bottom = 120.0 + _animY.value;
    return Positioned(
      bottom: bottom,
      left: leftPx,
      child: Opacity(
        opacity: _animOpacity.value.clamp(0.0, 1.0),
        child: Transform.rotate(
          angle: (widget.model.size % 12) * 0.08,
          child: Icon(
            Icons.favorite,
            color: widget.model.color,
            size: widget.model.size,
            shadows: const [Shadow(blurRadius: 8, color: Colors.black26)],
          ),
        ),
      ),
    );
  }
}

class _LiveComment {
  final String message;
  final DateTime time;
  _LiveComment({required this.message, required this.time});
}
