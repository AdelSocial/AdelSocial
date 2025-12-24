import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Admin authorization backed by Firestore `admins` collection.
///
/// Supported schemas (either works):
/// - `admins/{uid}` document exists (optional `active: false` to disable)
/// - `admins` collection contains a document with `email == user.email`
///   (optional `active: false` to disable)
class AdminAccessService {
  static final Map<String, bool> _adminCacheByUid = {};

  static void clearCache() => _adminCacheByUid.clear();

  static Future<bool> isAdmin(User user) async {
    final cached = _adminCacheByUid[user.uid];
    if (cached != null) return cached;

    final admins = FirebaseFirestore.instance.collection('admins');

    // 1) Prefer doc-id == uid
    final byUid = await admins.doc(user.uid).get();
    if (byUid.exists) {
      final data = byUid.data();
      final active = data?['active'];
      final allowed = active is bool ? active : true;
      _adminCacheByUid[user.uid] = allowed;
      return allowed;
    }

    // 2) Fallback to email-based lookup
    final email = user.email;
    if (email != null && email.trim().isNotEmpty) {
      final q = await admins.where('email', isEqualTo: email.trim()).limit(1).get();
      if (q.docs.isNotEmpty) {
        final data = q.docs.first.data();
        final active = data['active'];
        final allowed = active is bool ? active : true;
        _adminCacheByUid[user.uid] = allowed;
        return allowed;
      }
    }

    _adminCacheByUid[user.uid] = false;
    return false;
  }
}

