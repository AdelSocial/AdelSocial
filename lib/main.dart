import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/app_routes.dart';
import 'app/middleware/admin_route_guard.dart';
import 'app/view/dash_screen.dart';
import 'app/view/create_profile_screen.dart';
import 'app/view/intro_screen.dart';
import 'app/view/navigation/admin_login_screen.dart';
import 'app/view/privacy_policy_screen.dart';
import 'app/view/terms_conditions_screen.dart';
import 'app/view/verification_screen.dart';
import 'firebase_options.dart';
import 'project_model/screen/admin_dashboard_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.intro,
      getPages: [
        // User flow
        GetPage(name: AppRoutes.intro, page: () => IntroScreen()),
        GetPage(name: AppRoutes.login, page: () => VerificationScreen()),
        GetPage(name: '/createProfile', page: () => const CreateProfileScreen()),
        GetPage(name: AppRoutes.home, page: () => const DashScreen()),
        GetPage(name: AppRoutes.privacyPolicy, page: () => PrivacyPolicyScreen()),
        GetPage(
          name: AppRoutes.termsConditions,
          page: () => const TermsConditionsScreen(),
        ),
        GetPage(
          name: AppRoutes.wallet,
          page: () => const _PlaceholderScreen(title: 'Wallet'),
        ),
        GetPage(
          name: AppRoutes.messages,
          page: () => const _PlaceholderScreen(title: 'Messages'),
        ),

        // Admin flow (same app, namespaced routes)
        GetPage(
          name: AppRoutes.adminLogin,
          page: () => const AdminLoginScreen(),
          middlewares: [AdminRouteGuard()],
        ),

        // Admin pages
        GetPage(
          name: DashboardPage.route,
          page: () => const DashboardPage(),
          middlewares: [AdminRouteGuard()],
        ),
        GetPage(
          name: VideoCallsPage.route,
          page: () => const VideoCallsPage(),
          middlewares: [AdminRouteGuard()],
        ),
        GetPage(
          name: AudioCallsPage.route,
          page: () => const AudioCallsPage(),
          middlewares: [AdminRouteGuard()],
        ),
        GetPage(
          name: MessagesPage.route,
          page: () => const MessagesPage(),
          middlewares: [AdminRouteGuard()],
        ),
        GetPage(
          name: ChatPage.route,
          page: () => const ChatPage(),
          middlewares: [AdminRouteGuard()],
        ),
        GetPage(
          name: NotificationsPage.route,
          page: () => const NotificationsPage(),
          middlewares: [AdminRouteGuard()],
        ),
        GetPage(
          name: AddPostPage.route,
          page: () => const AddPostPage(),
          middlewares: [AdminRouteGuard()],
        ),
        GetPage(
          name: TicketsPage.route,
          page: () => const TicketsPage(),
          middlewares: [AdminRouteGuard()],
        ),
        GetPage(
          name: ServicesPricingPage.route,
          page: () => const ServicesPricingPage(),
          middlewares: [AdminRouteGuard()],
        ),
        GetPage(
          name: ServiceRequestsPage.route,
          page: () => const ServiceRequestsPage(),
          middlewares: [AdminRouteGuard()],
        ),
        GetPage(
          name: ExclusivePostsPage.route,
          page: () => const ExclusivePostsPage(),
          middlewares: [AdminRouteGuard()],
        ),
        GetPage(
          name: GoLivePage.route,
          page: () => const GoLivePage(),
          middlewares: [AdminRouteGuard()],
        ),
        GetPage(
          name: AnalyticsPage.route,
          page: () => const AnalyticsPage(),
          middlewares: [AdminRouteGuard()],
        ),
        GetPage(
          name: CustomizeAppPage.route,
          page: () => const CustomizeAppPage(),
          middlewares: [AdminRouteGuard()],
        ),
      ],
      unknownRoute: GetPage(
        name: '/not-found',
        page: () => const _PlaceholderScreen(title: 'Not found'),
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}




