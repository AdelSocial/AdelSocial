import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboardStats {
  final String totalUsers;
  final String activeCalls;
  final String ongoingChats;
  final String totalPosts;
  final String revenueMoM;
  final String liveSessions;

  const AdminDashboardStats({
    required this.totalUsers,
    required this.activeCalls,
    required this.ongoingChats,
    required this.totalPosts,
    required this.revenueMoM,
    required this.liveSessions,
  });
}

/// Firestore reads for the admin panel.
///
/// Collection names are conventional defaults; adjust to match your backend:
/// - users
/// - calls
/// - conversations
/// - posts
/// - transactions
/// - live_sessions
/// - tickets
/// - service_requests
/// - exclusive_posts
class AdminFirestoreRepository {
  AdminFirestoreRepository({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  static const String usersCol = 'users';
  static const String callsCol = 'calls';
  static const String conversationsCol = 'conversations';
  static const String postsCol = 'posts';
  static const String transactionsCol = 'transactions';
  static const String liveSessionsCol = 'live_sessions';
  static const String ticketsCol = 'tickets';
  static const String serviceRequestsCol = 'service_requests';
  static const String exclusivePostsCol = 'exclusive_posts';

  Future<int?> _safeCount(Query<Map<String, dynamic>> query) async {
    try {
      final snap = await query.count().get();
      return snap.count;
    } catch (_) {
      return null;
    }
  }

  Future<num?> _safeSumCurrentMonth({
    required String collection,
    required String amountField,
    required String createdAtField,
    int maxDocs = 1000,
  }) async {
    try {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);

      final q = _db
          .collection(collection)
          .where(createdAtField, isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .orderBy(createdAtField, descending: true)
          .limit(maxDocs);

      final snap = await q.get();
      num total = 0;
      for (final doc in snap.docs) {
        final data = doc.data();
        final v = data[amountField];
        if (v is num) total += v;
        if (v is String) {
          final parsed = num.tryParse(v.replaceAll(',', '').trim());
          if (parsed != null) total += parsed;
        }
      }
      return total;
    } catch (_) {
      return null;
    }
  }

  Future<AdminDashboardStats> fetchDashboardStats() async {
    final users = _safeCount(_db.collection(usersCol));
    final activeCalls =
        _safeCount(_db.collection(callsCol).where('status', isEqualTo: 'active'));
    final chats = _safeCount(
      _db.collection(conversationsCol).where('status', isEqualTo: 'active'),
    );
    final posts = _safeCount(_db.collection(postsCol));
    final live = _safeCount(
      _db.collection(liveSessionsCol).where('status', isEqualTo: 'live'),
    );
    final revenue = _safeSumCurrentMonth(
      collection: transactionsCol,
      amountField: 'amount',
      createdAtField: 'createdAt',
    );

    final results = await Future.wait<dynamic>([
      users,
      activeCalls,
      chats,
      posts,
      revenue,
      live,
    ]);

    final totalUsers = results[0] as int?;
    final activeCallsCount = results[1] as int?;
    final ongoingChatsCount = results[2] as int?;
    final totalPosts = results[3] as int?;
    final revenueMoM = results[4] as num?;
    final liveSessions = results[5] as int?;

    return AdminDashboardStats(
      totalUsers: totalUsers?.toString() ?? '—',
      activeCalls: activeCallsCount?.toString() ?? '—',
      ongoingChats: ongoingChatsCount?.toString() ?? '—',
      totalPosts: totalPosts?.toString() ?? '—',
      revenueMoM: revenueMoM == null ? '—' : '₹ ${_compactNumber(revenueMoM)}',
      liveSessions: liveSessions?.toString() ?? '—',
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> latestTickets({int limit = 20}) {
    // Expected (optional) fields:
    // - createdAt (Timestamp)
    return _db
        .collection(ticketsCol)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> latestServiceRequests({int limit = 20}) {
    return _db
        .collection(serviceRequestsCol)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> latestExclusivePosts({int limit = 20}) {
    return _db
        .collection(exclusivePostsCol)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots();
  }

  static String formatDate(dynamic value) {
    try {
      DateTime? dt;
      if (value is Timestamp) dt = value.toDate();
      if (value is DateTime) dt = value;
      if (value is String) {
        dt = DateTime.tryParse(value);
      }
      if (dt == null) return '—';
      final y = dt.year.toString().padLeft(4, '0');
      final m = dt.month.toString().padLeft(2, '0');
      final d = dt.day.toString().padLeft(2, '0');
      return '$y-$m-$d';
    } catch (_) {
      return '—';
    }
  }

  static String _compactNumber(num value) {
    final abs = value.abs();
    if (abs >= 10000000) return '${(value / 10000000).toStringAsFixed(1)}Cr';
    if (abs >= 100000) return '${(value / 100000).toStringAsFixed(1)}L';
    if (abs >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return value.toStringAsFixed(value % 1 == 0 ? 0 : 2);
  }
}

