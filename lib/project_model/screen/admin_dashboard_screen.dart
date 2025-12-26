import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:model_project/app/app_routes.dart';
import 'package:model_project/app/services/admin_firestore_repository.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Panel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.pink,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: DashboardPage.route,
      routes: {
        DashboardPage.route: (_) => const DashboardPage(),
        VideoCallsPage.route: (_) => const VideoCallsPage(),
        AudioCallsPage.route: (_) => const AudioCallsPage(),
        MessagesPage.route: (_) => const MessagesPage(),
        ChatPage.route: (_) => const ChatPage(),
        NotificationsPage.route: (_) => const NotificationsPage(),
        AddPostPage.route: (_) => const AddPostPage(),
        TicketsPage.route: (_) => const TicketsPage(),
        ServicesPricingPage.route: (_) => const ServicesPricingPage(),
        ServiceRequestsPage.route: (_) => const ServiceRequestsPage(),
        ExclusivePostsPage.route: (_) => const ExclusivePostsPage(),
        GoLivePage.route: (_) => const GoLivePage(),
        AnalyticsPage.route: (_) => const AnalyticsPage(),
        CustomizeAppPage.route: (_) => const CustomizeAppPage(),
      },
    );
  }
}

/// ============= Reusable Admin Shell =============
class AdminScaffold extends StatelessWidget {
  const AdminScaffold({super.key, required this.title, required this.body});

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.pink.withOpacity(0.1),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.pink[600]!,
                    Colors.pink!,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.shield_outlined,
                size: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        actions: const [
          _BellAction(),
          SizedBox(width: 12),
          _ProfileAction(),
          SizedBox(width: 16),
        ],
      ),
      drawer: const _AdminDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFDF2F8), Color(0xFFFCE8F3)],
            stops: [0.1, 0.9],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: body,
          ),
        ),
      ),
    );
  }
}

class _BellAction extends StatelessWidget {
  const _BellAction();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.pink[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.pink[100]!),
          ),
          child: IconButton(
            icon: Icon(
              Icons.notifications_none_rounded,
              color: Colors.pink[600],
              size: 22,
            ),
            onPressed: () =>
                Navigator.pushNamed(context, NotificationsPage.route),
            tooltip: 'Notifications',
          ),
        ),
        Positioned(
          right: 10,
          top: 10,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.white, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileAction extends StatelessWidget {
  const _ProfileAction();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink[600]!, Colors.pink!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: PopupMenuButton(
        itemBuilder: (ctx) => [
          PopupMenuItem(
            value: 'profile',
            child: Row(
              children: [
                Icon(Icons.person, color: Colors.pink[600]),
                const SizedBox(width: 8),
                const Text('Profile'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'settings',
            child: Row(
              children: [
                Icon(Icons.settings, color: Colors.pink[600]),
                const SizedBox(width: 8),
                const Text('Settings'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'logout',
            child: Row(
              children: [
                Icon(Icons.logout, color: Colors.red),
                SizedBox(width: 8),
                Text('Logout', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
        onSelected: (value) async {
          if (value == 'logout') {
            await FirebaseAuth.instance.signOut();
            if (!context.mounted) return;
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.adminLogin,
              (_) => false,
            );
          }
        },
        icon: const Icon(Icons.person, color: Colors.white, size: 20),
        offset: const Offset(0, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _AdminDrawer extends StatelessWidget {
  const _AdminDrawer();

  @override
  Widget build(BuildContext context) {
    final items = <_NavItem>[
      _NavItem('Back to App', Icons.arrow_back_rounded, '/home'),
      _NavItem('Dashboard', Icons.dashboard_outlined, DashboardPage.route),
      _NavItem('Video Calls', Icons.videocam_outlined, VideoCallsPage.route),
      _NavItem('Audio Calls', Icons.headset_mic_outlined, AudioCallsPage.route),
      _NavItem('Messages', Icons.mail_outline, MessagesPage.route),
      _NavItem('Chat', Icons.chat_bubble_outline, ChatPage.route),
      _NavItem(
        'Notifications',
        Icons.campaign_outlined,
        NotificationsPage.route,
      ),
      _NavItem('Add Post', Icons.post_add_outlined, AddPostPage.route),
      _NavItem(
        'Issue Tickets',
        Icons.confirmation_number_outlined,
        TicketsPage.route,
      ),
      _NavItem(
        'Services & Pricing',
        Icons.price_change_outlined,
        ServicesPricingPage.route,
      ),
      _NavItem(
        'Service Requests',
        Icons.inbox_outlined,
        ServiceRequestsPage.route,
      ),
      _NavItem('Exclusive Posts', Icons.star_border, ExclusivePostsPage.route),
      _NavItem('Go Live', Icons.podcasts_outlined, GoLivePage.route),
      _NavItem('Analytics', Icons.analytics_outlined, AnalyticsPage.route),
      _NavItem('Customize App', Icons.tune, CustomizeAppPage.route),
    ];
    final current = ModalRoute.of(context)?.settings.name;

    return Drawer(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink[600]!, Colors.pink!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.shield_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Admin Panel',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Welcome back!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 12),
                children: items
                    .map(
                      (e) =>
                      _DrawerTile(item: e, isSelected: e.route == current),
                )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;

  const _DrawerTile({required this.item, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.pink[50] : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(color: Colors.pink[100]!)
            : Border.all(color: Colors.transparent),
      ),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isSelected ? Colors.pink[600] : Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            item.icon,
            color: isSelected ? Colors.white : Colors.grey[700],
            size: 20,
          ),
        ),
        title: Text(
          item.label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.pink[600] : Colors.black87,
            fontSize: 14,
          ),
        ),
        selected: isSelected,
        onTap: () {
          Navigator.pop(context);
          if (item.route != ModalRoute.of(context)?.settings.name) {
            Navigator.pushReplacementNamed(context, item.route);
          }
        },
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final String route;
  _NavItem(this.label, this.icon, this.route);
}

/// ======= Enhanced UI helpers =======
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final String? subtitle;
  final Color? color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? Colors.pink[600]!;
    return Card(
      elevation: 3,
      shadowColor: Colors.pink.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [cardColor, cardColor.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: cardColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: cardColor.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;
  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Colors.pink.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                ...(actions ?? []),
              ],
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}

class SimpleDataTable extends StatelessWidget {
  final List<String> columns;
  final List<List<String>> rows;
  const SimpleDataTable({super.key, required this.columns, required this.rows});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: DataTable(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          headingRowColor: WidgetStateProperty.all(Colors.pink[50]),
          columns: columns
              .map(
                (c) => DataColumn(
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  c,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.pink[600],
                  ),
                ),
              ),
            ),
          )
              .toList(),
          rows: rows
              .map(
                (r) => DataRow(
              cells: r
                  .map(
                    (c) => DataCell(
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(c),
                  ),
                ),
              )
                  .toList(),
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}

/// ============= Pages =============

class DashboardPage extends StatelessWidget {
  static const route = '/admin/dashboard';
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Dashboard',
      body: ListView(
        children: const [
          _DashboardStatsRow(),
          SizedBox(height: 24),
          _EngagementAndUsage(),
          SizedBox(height: 24),
          _QuickActions(),
        ],
      ),
    );
  }
}

class _DashboardStatsRow extends StatelessWidget {
  const _DashboardStatsRow();

  @override
  Widget build(BuildContext context) {
    final repo = AdminFirestoreRepository();
    return FutureBuilder<AdminDashboardStats>(
      future: repo.fetchDashboardStats(),
      builder: (context, snap) {
        final stats = snap.data ??
            const AdminDashboardStats(
              totalUsers: '…',
              activeCalls: '…',
              ongoingChats: '…',
              totalPosts: '…',
              revenueMoM: '…',
              liveSessions: '…',
            );

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 0.9,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            StatCard(
              title: 'Total Users',
              value: stats.totalUsers,
              icon: Icons.people_alt_outlined,
              color: const Color(0xFFEC407A),
            ),
            StatCard(
              title: 'Active Calls',
              value: stats.activeCalls,
              icon: Icons.videocam_outlined,
              color: const Color(0xFFAB47BC),
            ),
            StatCard(
              title: 'Ongoing Chats',
              value: stats.ongoingChats,
              icon: Icons.chat_bubble_outline,
              color: const Color(0xFF7E57C2),
            ),
            StatCard(
              title: 'Total Posts',
              value: stats.totalPosts,
              icon: Icons.article_outlined,
              color: const Color(0xFF5C6BC0),
            ),
            StatCard(
              title: 'Revenue (MoM)',
              value: stats.revenueMoM,
              icon: Icons.payments_outlined,
              color: const Color(0xFF26A69A),
            ),
            StatCard(
              title: 'Live Sessions',
              value: stats.liveSessions,
              icon: Icons.podcasts_outlined,
              color: const Color(0xFFFFA726),
            ),
          ],
        );
      },
    );
  }
}


class _EngagementAndUsage extends StatelessWidget {
  const _EngagementAndUsage();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionCard(
          title: 'User Engagement',
          child: Container(
            height: 150,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.pink,
                  Colors.pink.withAlpha(8),
                ],
              ),
              border: Border.all(color: Colors.black12),
            ),
            child: const Icon(
              Icons.analytics_outlined,
              size: 48,
              color: Colors.black26,
            ),
          ),
        ),
        const SizedBox(width: 16),
        SectionCard(
          title: 'Service Usage',
          child: Container(
            height: 150,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.pink,
                  Colors.pink.withAlpha(8),
                ],
              ),
              border: Border.all(color: Colors.black12),
            ),
            child: const Icon(Icons.pie_chart, size: 48, color: Colors.black26),
          ),
        ),
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Quick Actions',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          FilledButton.icon(
            onPressed: () =>
                Navigator.pushNamed(context, NotificationsPage.route),
            icon: const Icon(Icons.campaign_outlined),
            label: const Text('Send Notification'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.pink[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.pushNamed(context, AddPostPage.route),
            icon: const Icon(Icons.post_add_outlined),
            label: const Text('Create Post'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.pink[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.pushNamed(context, GoLivePage.route),
            icon: const Icon(Icons.podcasts_outlined),
            label: const Text('Start Live'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.pink[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ... (Other pages remain similar but with updated color scheme)

class VideoCallsPage extends StatelessWidget {
  static const route = '/admin/video-calls';
  const VideoCallsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Video Calls',
      body: ListView(
        children: [
          SectionCard(
            title: 'Active \nRecent Calls',
            actions: [
              Column(
                children: [
                  FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('Start Call'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.pink[600],
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.stop_circle_outlined),
                    label: const Text('End Call'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.pink[600],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
            child: const SimpleDataTable(
              columns: ['User', 'Call ID', 'Duration', 'Date', 'Status'],
              rows: [
                ['Aisha', '#VID-8342', '12:40', '2025-11-05', 'Active'],
                ['Rahul', '#VID-8341', '08:21', '2025-11-05', 'Ended'],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ... (Other pages would follow similar updates with Colors.pink[600])

class AnalyticsPage extends StatelessWidget {
  static const route = '/admin/analytics';
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Analytics',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 0.6,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            SectionCard(
              title: 'Revenue',
              child: _chartBox('Bar Chart Placeholder', context),
            ),
            SectionCard(
              title: 'Active Users',
              child: _chartBox('Area Chart Placeholder', context),
            ),
            SectionCard(
              title: 'Top Services',
              child: _chartBox('Donut Chart Placeholder', context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chartBox(String label, context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFFDF2F8)],
        ),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 32,
            color: Colors.pink[600],
          ),
          const SizedBox(height: 8),
          Text(
            textAlign: TextAlign.center,
            label,
            style: TextStyle(color: Colors.pink[600]),
          ),
        ],
      ),
    );
  }
}

class AudioCallsPage extends StatelessWidget {
  static const route = '/admin/audio-calls';
  const AudioCallsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Audio Calls',
      body: ListView(
        children: [
          SectionCard(
            title: 'Audio Call Sessions',
            actions: [
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('New Call'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.pink[600],
                  foregroundColor: Colors.white,
                ),
              ),
            ],
            child: const SimpleDataTable(
              columns: ['User', 'Call ID', 'Duration', 'Date', 'Status'],
              rows: [
                ['Neeraj', '#AUD-2211', '05:10', '2025-11-05', 'Active'],
                ['Ira', '#AUD-2210', '14:32', '2025-11-04', 'Ended'],
                ['Rohan', '#AUD-2209', '08:15', '2025-11-04', 'Ended'],
                ['Priya', '#AUD-2208', '22:45', '2025-11-03', 'Ended'],
              ],
            ),
          ),
          const SizedBox(height: 16),
          SectionCard(
            title: 'Call Statistics',
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.start,
                  children: [
                    _StatItem('Total Calls', '156', Icons.call, Colors.pink[600]!),
                    _StatItem('Avg Duration', '12:30', Icons.timer, Colors.pink[500]!),
                    _StatItem('Success Rate', '94%', Icons.check_circle, Colors.pink!),
                  ],
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}

class MessagesPage extends StatelessWidget {
  static const route = '/admin/messages';
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Messages (Inbox)',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🟦 Left Section: Conversations List
          Expanded(
            flex: 4,
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search conversations...',
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.pink[600],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView.separated(
                      itemCount: 8,
                      separatorBuilder: (_, __) =>
                      const Divider(height: 1, thickness: 0.5),
                      itemBuilder: (ctx, i) => ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.pink[50],
                          child: Icon(
                            Icons.person,
                            color: Colors.pink[600],
                          ),
                        ),
                        title: Text(
                          'User #${i + 1}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: const Text('Last message preview...'),
                        trailing: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              '2m',
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 12,
                              ),
                            ),
                            if (i < 3)
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.pink[600],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  '3',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 16),

          // 🟩 Right Section: Chat Box
          Expanded(
            flex: 10,
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Conversation with User #1',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black12),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.white, Color(0xFFFDF2F8)],
                          ),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _MessageBubble(
                              isMe: false,
                              text: 'Hello, I need help with my account.',
                              time: '2:30 PM',
                            ),
                            _MessageBubble(
                              isMe: true,
                              text:
                              'Sure, I can help you with that. What seems to be the problem?',
                              time: '2:31 PM',
                            ),
                            _MessageBubble(
                              isMe: false,
                              text: 'I cannot access my premium features.',
                              time: '2:32 PM',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Type a reply...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(width: 12),
                        FilledButton(
                          onPressed: () {},
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.pink[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Send'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatPage extends StatelessWidget {
  static const route = '/admin/chat';
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Live Chat',
      body: SingleChildScrollView(
        child: Column(
          children: [
            SectionCard(
              title: 'Live Conversations',
              child: Column(
                children: [
                  const SimpleDataTable(
                    columns: ['Room', 'Users', 'Moderators', 'Status', 'Actions'],
                    rows: [
                      ['Public #1', '23', '2', 'Active', 'View'],
                      ['Support', '5', '1', 'Active', 'View'],
                      ['General', '45', '3', 'Active', 'View'],
                      ['Premium', '12', '1', 'Inactive', 'View'],
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.visibility_outlined),
                        label: const Text('Monitor Selected'),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.pink[600],
                          foregroundColor: Colors.white,
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.block_outlined),
                        label: const Text('Mute User'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Clear Chat'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

        SectionCard(
          title: 'Chat Statistics',
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Responsive wrapping layout
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _ChatStat('Active Rooms', '8', Icons.chat_bubble_outline),
                  _ChatStat('Total Users', '156', Icons.people_outline),
                  _ChatStat('Messages Today', '1.2K', Icons.message_outlined),
                  _ChatStat('Moderators', '7', Icons.shield_outlined),
                ],
              );
            },
          ),
        ),

        ],
        ),
      ),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  static const route = '/admin/notifications';
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final titleCtrl = TextEditingController();
    final msgCtrl = TextEditingController();

    return AdminScaffold(
      title: 'Send Notification',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🟩 LEFT: Compose Notification Form
          Expanded(
            flex: 8,
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Compose Notification',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.schedule),
                          label: const Text('Schedule'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: titleCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: msgCtrl,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Message',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField(
                      initialValue: 'All Users',
                      items: const [
                        DropdownMenuItem(
                          value: 'All Users',
                          child: Text('All Users'),
                        ),
                        DropdownMenuItem(
                          value: 'Subscribers',
                          child: Text('Subscribers'),
                        ),
                        DropdownMenuItem(
                          value: 'Single User',
                          child: Text('Single User (enter ID)'),
                        ),
                      ],
                      onChanged: (v) {},
                      decoration: const InputDecoration(
                        labelText: 'Target Audience',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.image_outlined),
                          label: const Text('Attach Image'),
                        ),
                        const Spacer(),
                        FilledButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.send_rounded),
                          label: const Text('Send Now'),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.pink[600],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // 🟦 RIGHT: Recent Notifications
          Expanded(
            flex: 4,
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recent Notifications',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.separated(
                        itemCount: 5,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (ctx, i) => Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Notification ${i + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Short description of the notification...',
                                style: TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '2 hours ago',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.pink[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddPostPage extends StatelessWidget {
  static const route = '/admin/add-post';
  const AddPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    final title = TextEditingController();
    final body = TextEditingController();

    return AdminScaffold(
      title: 'Add Post',
      body: ListView(
        children: [
          SectionCard(
            title: 'Post Editor',
            actions: [
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.preview_outlined),
                label: const Text('Preview'),
              ),

            ],
            child: Column(
              children: [
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.publish_outlined),
                  label: const Text('Publish'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.pink[600],
                    foregroundColor: Colors.white,
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: title,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: body,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    labelText: 'Body (Markdown supported)',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField(
                        initialValue: 'General',
                        items: const [
                          DropdownMenuItem(
                            value: 'General',
                            child: Text('General'),
                          ),
                          DropdownMenuItem(
                            value: 'Update',
                            child: Text('Update'),
                          ),
                          DropdownMenuItem(
                            value: 'Promo',
                            child: Text('Promo'),
                          ),
                          DropdownMenuItem(value: 'News', child: Text('News')),
                        ],
                        onChanged: (_) {},
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField(
                        initialValue: 'Draft',
                        items: const [
                          DropdownMenuItem(
                            value: 'Draft',
                            child: Text('Draft'),
                          ),
                          DropdownMenuItem(
                            value: 'Scheduled',
                            child: Text('Scheduled'),
                          ),
                          DropdownMenuItem(
                            value: 'Published',
                            child: Text('Published'),
                          ),
                        ],
                        onChanged: (_) {},
                        decoration: const InputDecoration(
                          labelText: 'State',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.video_library_outlined),
                      label: const Text('Add Video'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.image_outlined),
                      label: const Text('Add Image'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.attach_file),
                      label: const Text('Add File'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TicketsPage extends StatelessWidget {
  static const route = '/admin/tickets';
  const TicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = AdminFirestoreRepository();
    return AdminScaffold(
      title: 'Issue Tickets',
      body: SectionCard(
        title: 'Support Tickets',
        actions: [
          Wrap(
            spacing: 10,
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.filter_list),
                label: const Text('Filter'),
              ),

            ],
          ),
        ],
        child: Column(

          children: [

            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.assignment_ind_outlined),
              label: const Text('Assign'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.pink[600],
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder(
              stream: repo.latestTickets(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Failed to load tickets.');
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;
                final rows = docs.map((d) {
                  final data = d.data();
                  final id = (data['ticketId'] ?? data['id'] ?? d.id).toString();
                  final user = (data['userName'] ??
                          data['user'] ??
                          data['userId'] ??
                          data['uid'] ??
                          '—')
                      .toString();
                  final issue = (data['issue'] ?? data['title'] ?? data['message'] ?? '—')
                      .toString();
                  final priority = (data['priority'] ?? '—').toString();
                  final status = (data['status'] ?? '—').toString();
                  final date = AdminFirestoreRepository.formatDate(
                    data['createdAt'] ?? data['date'] ?? data['updatedAt'],
                  );
                  return [id, user, issue, priority, status, date, 'View'];
                }).toList();

                return SimpleDataTable(
                  columns: const [
                    'ID',
                    'User',
                    'Issue',
                    'Priority',
                    'Status',
                    'Date',
                    'Actions',
                  ],
                  rows: rows.isEmpty
                      ? const [
                          ['—', '—', 'No tickets found', '—', '—', '—', '—']
                        ]
                      : rows,
                );
              },
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.pink[600],
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Approve Selected'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Decline Selected'),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download_outlined),
                  label: const Text('Export'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ServicesPricingPage extends StatelessWidget {
  static const route = '/admin/services-pricing';
  const ServicesPricingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Services & Pricing',
      body: SectionCard(
        title: 'Manage Services',
        actions: [
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Add Service'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.pink[600],
              foregroundColor: Colors.white,
            ),
          ),
        ],
        child: Column(
          children: [
            const SimpleDataTable(
              columns: ['Service', 'Price', 'Duration', 'Active', 'Popularity'],
              rows: [
                ['Video Call', '₹299', '20 min', 'Yes', '85%'],
                ['Audio Call', '₹199', '15 min', 'Yes', '72%'],
                ['Chat', '₹99', 'Per day', 'Yes', '64%'],
                ['Exclusive Content', '₹499', 'Monthly', 'Yes', '91%'],
                ['Live Session', '₹799', '60 min', 'Yes', '78%'],
                ['Massage', '₹1,499', '60 min', 'No', '45%'],
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.pink[600],
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save Changes'),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.history),
                  label: const Text('Reset'),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.analytics_outlined),
                  label: const Text('View Analytics'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceRequestsPage extends StatelessWidget {
  static const route = '/admin/service-requests';
  const ServiceRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = AdminFirestoreRepository();
    return AdminScaffold(
      title: 'Service Requests',
      body: SectionCard(
        title: 'Incoming Requests',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🟩 Simple Data Table
            StreamBuilder(
              stream: repo.latestServiceRequests(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Failed to load service requests.');
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;
                final rows = docs.map((d) {
                  final data = d.data();
                  final id = (data['requestId'] ?? data['id'] ?? d.id).toString();
                  final user = (data['userName'] ??
                          data['user'] ??
                          data['userId'] ??
                          data['uid'] ??
                          '—')
                      .toString();
                  final service = (data['service'] ?? data['serviceName'] ?? '—').toString();
                  final date = AdminFirestoreRepository.formatDate(
                    data['createdAt'] ?? data['date'] ?? data['updatedAt'],
                  );
                  final status = (data['status'] ?? '—').toString();
                  final amount = (data['amount'] ?? data['price'] ?? '—').toString();
                  return [id, user, service, date, status, amount];
                }).toList();

                return SimpleDataTable(
                  columns: const [
                    'Req ID',
                    'User',
                    'Service',
                    'Date',
                    'Status',
                    'Amount',
                  ],
                  rows: rows.isEmpty
                      ? const [
                          ['—', '—', 'No requests found', '—', '—', '—']
                        ]
                      : rows,
                );
              },
            ),

            const SizedBox(height: 20),

            // 🟦 Action Buttons Row
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF26A69A),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Approve Selected'),
                ),
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFEF5350),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Decline Selected'),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.message_outlined),
                  label: const Text('Contact User'),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download_outlined),
                  label: const Text('Export Requests'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExclusivePostsPage extends StatelessWidget {
  static const route = '/admin/exclusive-posts';
  const ExclusivePostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Exclusive Posts',
      body: SectionCard(
        title: 'Premium Content Management',
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  'Paid Content',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 12),
                Switch(
                  value: true,
                  onChanged: (_) {},
                  activeThumbColor: Colors.pink[600],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SimpleDataTable(
              columns: [
                'Post ID',
                'Title',
                'Access Level',
                'Status',
                'Schedule',
                'Revenue',
              ],
              rows: [
                [
                  '#EP-110',
                  'Premium Tips & Tricks',
                  'Subscribers',
                  'Published',
                  '—',
                  '₹12,340',
                ],
                [
                  '#EP-111',
                  'Insider Video Content',
                  'Gold Tier',
                  'Scheduled',
                  '2025-11-06 18:00',
                  '₹8,450',
                ],
                [
                  '#EP-109',
                  'Advanced Techniques',
                  'Platinum',
                  'Published',
                  '—',
                  '₹15,670',
                ],
                [
                  '#EP-108',
                  'Monthly Insights',
                  'Subscribers',
                  'Draft',
                  '—',
                  '—',
                ],
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('New Premium Post'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.pink[600],
                    foregroundColor: Colors.white,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.analytics_outlined),
                  label: const Text('View Performance'),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.monetization_on_outlined),
                  label: const Text('Revenue Report'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GoLivePage extends StatelessWidget {
  static const route = '/admin/go-live';
  const GoLivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Go Live',
      body: SingleChildScrollView(
        child: Column(
          children: [
            SectionCard(
              title: 'Live Stream Control',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SimpleDataTable(
                    columns: [
                      'Stream Key',
                      'Title',
                      'Status',
                      'Viewers',
                      'Duration',
                    ],
                    rows: [
                      [
                        'sk_live_23jk42kf',
                        'AMA Session with Experts',
                        'Live',
                        '128',
                        '01:23:45',
                      ],
                      [
                        'sk_live_98df73gh',
                        'Weekly Update',
                        'Ended',
                        '89',
                        '00:45:12',
                      ],
                    ],
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text('Start Live'),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF26A69A),
                          foregroundColor: Colors.white,
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.stop),
                        label: const Text('Stop Stream'),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFEF5350),
                          foregroundColor: Colors.white,
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.key),
                        label: const Text('Regenerate Key'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.settings_outlined),
                        label: const Text('Stream Settings'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SectionCard(
              title: 'Quick Live Setup',
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _LiveOption(
                          'Camera Live',
                          Icons.videocam,
                          Colors.pink[600]!,
                        ),
                      ),
                      Expanded(
                        child: _LiveOption(
                          'Screen Share',
                          Icons.screen_share,
                          Colors.pink[500]!,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _LiveOption(
                          'Audio Only',
                          Icons.mic,
                          Colors.pink!,
                        ),
                      ),
                      Expanded(
                        child: _LiveOption(
                          'Schedule Live',
                          Icons.schedule,
                          Colors.pink[300]!,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomizeAppPage extends StatelessWidget {
  static const route = '/admin/customize-app';
  const CustomizeAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nameCtrl = TextEditingController(text: 'My App');
    final color = ValueNotifier<Color>(Colors.pink[600]!);

    return AdminScaffold(
      title: 'Customize App',
      body: SectionCard(
        title: 'Branding & Theme',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'App Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  'Primary Color:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 16),
                ValueListenableBuilder<Color>(
                  valueListenable: color,
                  builder: (ctx, c, _) => Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: c,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black26),
                      boxShadow: [
                        BoxShadow(
                          color: c.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.color_lens_outlined),
                  label: const Text('Pick Color'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.pink[600],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.image_outlined),
                  label: const Text('Upload Logo'),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.screenshot_monitor_outlined),
                  label: const Text('Splash Image'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.save_outlined),
              label: const Text('Save Branding'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.pink[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============= Helper Widgets =============

class _StatItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem(this.title, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200, // Fixed width for consistent layout
      height: 120, // Uniform height
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 28, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: color.withOpacity(0.9),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final bool isMe;
  final String text;
  final String time;

  const _MessageBubble({
    required this.isMe,
    required this.text,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isMe ? Colors.pink[50]! : Colors.white;
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = isMe
        ? const BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(16),
      bottomLeft: Radius.circular(16),
    )
        : const BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(16),
      bottomRight: Radius.circular(16),
    );

    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: radius,
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Text(text),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            time,
            style: const TextStyle(color: Colors.black54, fontSize: 10),
          ),
        ),
      ],
    );
  }
}

class _ChatStat extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _ChatStat(this.title, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 150,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.pink[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.pink[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(2, 4),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: Colors.pink[600]),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.pink[800],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _LiveOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _LiveOption(this.title, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: color),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'Start now',
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

