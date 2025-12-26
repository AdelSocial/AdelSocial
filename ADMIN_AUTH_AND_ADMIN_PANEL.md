## Admin panel + Firebase setup + Firestore setup (FULL developer guide)

This is the **single source of truth** for your developer to understand:

- What the **previous agent** added (admin UI + routes + initial wiring)
- What I changed (Firebase Auth + Firestore-based admin authorization + route protection)
- What to do in **Firebase Console** (Auth + Firestore)
- What to do in **Firestore** (collections, fields, recommended security rules)
- Which admin pages are **dynamic** (reading Firestore) vs still placeholders

### High-level behavior

- **Admin panel lives inside the same Flutter app** (not a separate app build).
- All admin screens use **namespaced routes** under `'/admin/*'` (e.g. `'/admin/dashboard'`).
- The admin login screen is at `'/admin/login'`.
- Any navigation to a `'/admin/*'` route is **protected** and will redirect to `'/admin/login'` unless:
  - the user is signed in via **Firebase Auth**, and
  - the user is authorized as an admin via Firestore **`admins`** collection.

### Quick start (developer checklist)

1) **Firebase Console**
   - Ensure the project exists and the app is registered for Android/iOS
   - Enable **Authentication → Email/Password**
   - Enable **Firestore Database**

2) **Create an admin**
   - Create a Firebase Auth user (email/password)
   - Add Firestore doc `admins/{uid}` with `active: true` (recommended)

3) **Verify in the app**
   - Go to **Settings → Admin Panel**
   - If not logged in, you should be redirected to **Admin Login**
   - Login with the admin email/password → you should land on **/admin/dashboard**

---

## Part A — What to do in Firebase Console (step-by-step)

### A1) Enable Email/Password sign-in

Firebase Console → **Authentication** → **Sign-in method**:

- Enable **Email/Password**

This app’s admin login uses:
- `FirebaseAuth.signInWithEmailAndPassword(email, password)`

### A2) Firestore Database: create + choose mode

Firebase Console → **Firestore Database**:

- Create Firestore database (if not created)
- During development you can use test rules briefly, but for real use you should apply rules like the ones in **Part C**.

### A3) (Optional but recommended) Add App Check

Firebase Console → **App Check**:

- Add App Check providers for Android/iOS if you want to prevent abuse.

---

## Part B — What to do in Firestore (collections + fields)

### B1) Admin authorization (`admins` collection)

The app authorizes admins using Firestore collection **`admins`**.

Recommended schema (best + simplest for Security Rules):

- Collection: `admins`
- Document ID: **Firebase Auth UID**
  - Path: `admins/{uid}`
  - Fields:
    - `active` (bool) → `true` (default) / `false` to disable access
    - (optional) `email` (string)
    - (optional) `role` (string, e.g. `"super_admin"`)
    - (optional) `createdAt` (timestamp)

Alternate schema supported by code (not recommended for rules):

- Any doc in `admins` with:
  - `email: "<admin email>"`
  - optional `active: true/false`

Important: Firestore security rules cannot “query” by email efficiently, so **use UID docs** (`admins/{uid}`) as the canonical authorization mechanism.

### B2) Admin panel dynamic data (collections used)

Some admin pages now read real Firestore data. Default collection names:

- `users`
- `calls` (optional field: `status`)
- `conversations` (optional field: `status`)
- `posts`
- `transactions` (optional fields: `amount`, `createdAt`)
- `live_sessions` (optional field: `status`)
- `tickets` (required for sorting: `createdAt`)
- `service_requests` (required for sorting: `createdAt`)

If your backend uses different names, change constants in:
- `lib/app/services/admin_firestore_repository.dart`

### B3) Required fields to avoid runtime query errors

Firestore `orderBy('createdAt')` is used for:

- `tickets`
- `service_requests`

So ensure these documents have:
- `createdAt: Timestamp` (server timestamp recommended)

Recommended minimal schemas:

**tickets/{ticketDoc}**
- `createdAt: Timestamp`
- `ticketId` (string) or use doc id
- `userId` (string) and/or `userName` (string)
- `issue` or `title` (string)
- `priority` (string: low/medium/high)
- `status` (string: open/pending/resolved)

**service_requests/{requestDoc}**
- `createdAt: Timestamp`
- `requestId` (string) or use doc id
- `userId` (string) and/or `userName` (string)
- `service` or `serviceName` (string)
- `amount` (number/string)
- `status` (string)

Notes:
- The UI is defensive and will show `—` for missing fields, but **missing `createdAt` can break ordering**.

---

## Part C — Firestore Security Rules (recommended starting point)

Below is a recommended baseline. It enforces:
- only authenticated users can read/write their own data (example)
- only admins (by UID doc) can access admin-managed collections

Update collection paths to match your real data model.

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function isSignedIn() {
      return request.auth != null;
    }

    // Canonical admin check (recommended)
    function isAdmin() {
      return isSignedIn()
        && exists(/databases/$(database)/documents/admins/$(request.auth.uid))
        && get(/databases/$(database)/documents/admins/$(request.auth.uid)).data.active != false;
    }

    // Admins collection itself
    match /admins/{uid} {
      allow read: if isAdmin();        // or restrict further to super-admin only
      allow write: if false;           // lock down by default
    }

    // Example: admin-managed collections
    match /tickets/{docId} {
      allow read, write: if isAdmin();
    }
    match /service_requests/{docId} {
      allow read, write: if isAdmin();
    }
    match /transactions/{docId} {
      allow read: if isAdmin();
    }
    match /users/{uid} {
      // Example user rule: user can read/write self; admins can read all
      allow read: if isAdmin() || (isSignedIn() && request.auth.uid == uid);
      allow write: if isSignedIn() && request.auth.uid == uid;
    }

    // Default deny
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

---

## Part D — App behavior, routes, and how to use it

### D1) Key routes

- **Admin login**: `AppRoutes.adminLogin` → `'/admin/login'`
- **Admin dashboard**: `DashboardPage.route` → `'/admin/dashboard'`
- **Admin namespace**: any route starting with `'/admin'` is protected

### D2) How access control works in the app

Flow:

1) User taps **Settings → Admin Panel**
2) App navigates to `'/admin/dashboard'`
3) Middleware (`AdminRouteGuard`) runs:
   - if not authenticated → redirect to `'/admin/login'`
   - if authenticated but not in `admins` → redirect to `'/admin/login'`
   - if authenticated and admin → allow access

### D3) Admin login behavior

- Admin enters email/password
- App calls Firebase Auth sign-in
- App checks Firestore `admins`:
  - if authorized → proceeds to dashboard
  - if not authorized → signs out and shows “Access denied”

### D4) Admin logout behavior

- Admin clicks top-right menu → Logout
- App signs out FirebaseAuth and navigates to `'/admin/login'`

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

### Files to look at (map)

- **Firebase init**: `lib/main.dart`, `lib/firebase_options.dart`
- **Admin login UI**: `lib/app/view/navigation/admin_login_screen.dart`
- **Admin login logic**: `lib/app/controller/admin_login_controller.dart`
- **Admin authorization**: `lib/app/services/admin_access_service.dart`
- **Admin route protection**: `lib/app/middleware/admin_route_guard.dart`
- **Admin panel pages**: `lib/project_model/screen/admin_dashboard_screen.dart`
- **App entry to admin**: `lib/app/view/navigation/setting screen.dart`
- **Admin Firestore reads (stats/tables)**: `lib/app/services/admin_firestore_repository.dart`

### Recommended next steps (optional)

- **Add Firestore Security Rules** so only admins can read/write admin-managed collections.
- Consider using **UID-only** admin docs (`admins/{uid}`) as the canonical schema (more reliable than email matching).

## Admin panel “dynamic data” (Firestore-backed tables + stats)

The admin panel now reads real data from Firestore for:

- Dashboard stat cards (counts / revenue estimate)
- Tickets table
- Service requests table

### Expected collection names (defaults)

These are the default collection names used by the admin panel code:

- `users`
- `calls` (expects optional field `status`)
- `conversations` (expects optional field `status`)
- `posts`
- `transactions` (expects optional fields `amount`, `createdAt`)
- `live_sessions` (expects optional field `status`)
- `tickets` (expects optional field `createdAt`)
- `service_requests` (expects optional field `createdAt`)

If your backend uses different names, update constants in:
- `lib/app/services/admin_firestore_repository.dart`

### Expected fields (best-effort / optional)

Tables are defensive: if a field is missing, the UI shows `—`.

- **Tickets** (`tickets`):
  - `createdAt` (Timestamp)
  - optional: `ticketId`/`id`, `userName`/`userId`, `issue`/`title`, `priority`, `status`

- **Service requests** (`service_requests`):
  - `createdAt` (Timestamp)
  - optional: `requestId`/`id`, `userName`/`userId`, `service`/`serviceName`, `status`, `amount`/`price`

### Permissions note

Admins must have Firestore read permissions for these collections; otherwise the UI will show load errors or `—`.

---

## Part E — What is still placeholder / not connected yet

These pages are still mostly UI-only (no real Firestore integration yet):

- Video Calls / Audio Calls
- Messages / Chat
- Notifications “send” UI (does not write to FCM / Firestore yet)
- Services & Pricing (does not persist yet)
- Exclusive Posts (does not persist yet)
- Go Live (does not control a real stream yet)

If you want, we can connect each page to real Firestore collections (create/update/delete + pagination + filters).

---

## Part F — Troubleshooting

### “I can log in but it says Access denied”

- The Firebase Auth user must be authorized in Firestore:
  - Ensure `admins/{uid}` exists and `active != false`

### “Admin pages keep redirecting me to /admin/login”

- Either not authenticated, or not authorized in `admins`.
- Check Firebase Auth current user, and Firestore rules for `admins/{uid}`.

### “Tickets/Service Requests show error or spinner forever”

Common causes:
- Firestore rules deny access (fix rules for admins)
- Collection name mismatch (update `AdminFirestoreRepository` constants)
- Missing `createdAt` in documents (required for `orderBy('createdAt')`)

