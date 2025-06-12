
import 'package:go_router/go_router.dart';


import 'package:abodesv1/features/auth/presentation/pages/welcome_page.dart';
import 'package:abodesv1/features/auth/presentation/pages/account_page.dart';
import 'package:abodesv1/features/auth/presentation/pages/signup_page.dart';
import 'package:abodesv1/features/auth/presentation/pages/signin_page.dart';

import 'package:abodesv1/features/owner/presentation/pages/homepage.dart';

import 'package:abodesv1/features/seeker/presentation/pages/homepage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _db = FirebaseDatabase.instance.ref();

  static Future<String?> getUserRole() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final snapshot = await _db.child('users/${user.uid}/role').get();
    return snapshot.value as String?;
  }
}



class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return null; // Not signed in, proceed normally

      final role = await AuthService.getUserRole();

      if (role == 'owner') return '/owner/home';
      if (role == 'seeker') return '/seeker/home';

      return '/signin'; // fallback
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: '/create-account',
        builder: (context, state) => const CreateAccountPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>? ?? {};
          final role = extras['role'] as String? ?? '';
          return SignupPage(role: role);
        },
      ),
      GoRoute(
        path: '/signin',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>? ?? {};
          final role = extras['role'] as String? ?? '';
          return SigninPage(role: role);
        },
      ),

      // OWNER ROUTES
      GoRoute(
        path: '/owner/home',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>? ?? {};
          return OwnerHomePage(
            ownerId: extras['ownerId'],
            seekerId: extras['seekerId'],
          );
        },
      ),
      GoRoute(
        path: '/seeker/home',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>? ?? {};
          return SeekerHomePage(
            ownerId: extras['ownerId'],
            seekerId: extras['seekerId'],
          );
        },
      ),



    ],
  );
}
