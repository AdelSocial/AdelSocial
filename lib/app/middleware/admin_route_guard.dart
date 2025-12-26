import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../app_routes.dart';
import '../services/admin_access_service.dart';
import '../../project_model/screen/admin_dashboard_screen.dart';

/// Protects all routes under `/admin/*` using Firebase Auth + Firestore `admins`.
class AdminRouteGuard extends GetMiddleware {
  @override
  int? get priority => 0;

  @override
  Future<RouteSettings?> redirectFuture(RouteSettings route) async {
    final name = route.name ?? '';

    // Allow non-admin navigation for non-admin routes.
    if (!name.startsWith('/admin')) return null;

    final user = FirebaseAuth.instance.currentUser;

    // Special-case: admin login route
    if (name == AppRoutes.adminLogin) {
      if (user == null) return null;
      final ok = await AdminAccessService.isAdmin(user);
      return ok ? const RouteSettings(name: DashboardPage.route) : null;
    }

    // All other /admin routes require admin membership.
    if (user == null) return const RouteSettings(name: AppRoutes.adminLogin);

    final ok = await AdminAccessService.isAdmin(user);
    return ok ? null : const RouteSettings(name: AppRoutes.adminLogin);
  }
}

