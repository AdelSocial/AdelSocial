## Admin panel + Firebase admin auth (developer notes)

This document explains the **admin panel**, **admin login**, and **route protection** that were added/updated in this repo.

### High-level behavior

- **Admin panel lives inside the same Flutter app** (not a separate app build).
- All admin screens use **namespaced routes** under `'/admin/*'` (e.g. `'/admin/dashboard'`).
- The admin login screen is at `'/admin/login'`.
- Any navigation to a `'/admin/*'` route is **protected** and will redirect to `'/admin/login'` unless:
  - the user is signed in via **Firebase Auth**, and
  - the user is authorized as an admin via Firestore **`admins`** collection.

### What the previous agent added (baseline)

The earlier implementation (before the latest update) introduced:

- **Admin panel UI** pages and routes in `lib/project_model/screen/admin_dashboard_screen.dart` (Dashboard, Video Calls, etc.)
- **Admin login screen UI** in `lib/app/view/navigation/admin_login_screen.dart`
- **GetX route wiring** for admin pages in `lib/main.dart`
- **Entry point from the user app**: Settings screen included an “Admin Login” tile in `lib/app/view/navigation/setting screen.dart`
- **A mock admin login controller** in `lib/app/controller/admin_login_controller.dart` using hardcoded credentials (not secure / only for demo)

### What was changed in the latest update

#### 1) Firebase initialization uses `DefaultFirebaseOptions`

File: `lib/main.dart`

- Changed from `Firebase.initializeApp()` to:
  - `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`
- This uses the generated config in `lib/firebase_options.dart`.

Notes:
- `DefaultFirebaseOptions` is configured for **Android/iOS** in this repo.
- Web/Linux/Mac/Windows are marked **Unsupported** in `lib/firebase_options.dart` unless you re-run FlutterFire CLI.

#### 2) Admin login now uses Firebase Auth + Firestore admins

File: `lib/app/controller/admin_login_controller.dart`

- Replaced mock credentials with:
  - `FirebaseAuth.instance.signInWithEmailAndPassword(email, password)`
- After sign-in, the app checks if the user is an authorized admin (Firestore `admins`).
- If the user is **not** an admin, they are **signed out** immediately and shown an “Access denied” message.

#### 3) All `/admin/*` routes are protected (route guard)

Files:
- `lib/app/middleware/admin_route_guard.dart`
- `lib/main.dart`

How it works:
- A `GetMiddleware` (`AdminRouteGuard`) runs for every admin route.
- If the route starts with `'/admin'`:
  - `'/admin/login'` is allowed (and will redirect to dashboard if already authorized)
  - any other `'/admin/*'` route requires an authorized admin session

#### 4) Firestore admin authorization logic (`admins` collection)

File: `lib/app/services/admin_access_service.dart`

The service considers a signed-in Firebase user an admin if either of these is true:

- **UID document** exists: `admins/{uid}`
  - optional boolean field `active: false` disables access
- **Email match**: any doc in `admins` where `email == user.email`
  - optional boolean field `active: false` disables access

This dual approach lets you choose either schema without changing code.

#### 5) “Admin Panel” is connected from the main app UI

File: `lib/app/view/navigation/setting screen.dart`

- The Settings tile now routes to the admin dashboard (`DashboardPage.route`).
- If the user is not authorized, the middleware redirects them to `'/admin/login'`.

#### 6) Admin logout added in admin panel UI

File: `lib/project_model/screen/admin_dashboard_screen.dart`

- The top-right menu “Logout” now calls `FirebaseAuth.instance.signOut()`
- Then returns to `'/admin/login'`

### How to create an admin login (credentials)

There are **no hardcoded admin credentials** in the app.

To create an admin:

1) **Create a Firebase Auth user (Email/Password)**
   - Firebase Console → Authentication → Users → Add user

2) **Authorize that user in Firestore**

Option A (recommended):
- Create document: `admins/{uid}` where `{uid}` is the Firebase Auth user UID
- Optional field: `active: true`

Option B (email based):
- Create a document in `admins` with field: `email: "admin@yourdomain.com"`
- Optional field: `active: true`

3) Use the same **email + password** on the **Admin Login** screen (`/admin/login`).

### Key routes (for developers)

- **Admin login**: `AppRoutes.adminLogin` → `'/admin/login'`
- **Admin dashboard**: `DashboardPage.route` → `'/admin/dashboard'`
- **Admin namespace**: any route starting with `'/admin'` is protected

### Files to look at (map)

- **Firebase init**: `lib/main.dart`, `lib/firebase_options.dart`
- **Admin login UI**: `lib/app/view/navigation/admin_login_screen.dart`
- **Admin login logic**: `lib/app/controller/admin_login_controller.dart`
- **Admin authorization**: `lib/app/services/admin_access_service.dart`
- **Admin route protection**: `lib/app/middleware/admin_route_guard.dart`
- **Admin panel pages**: `lib/project_model/screen/admin_dashboard_screen.dart`
- **App entry to admin**: `lib/app/view/navigation/setting screen.dart`

### Recommended next steps (optional)

- **Add Firestore Security Rules** so only admins can read/write admin-managed collections.
- Consider using **UID-only** admin docs (`admins/{uid}`) as the canonical schema (more reliable than email matching).

