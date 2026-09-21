import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/lock_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/contacts/presentation/screens/contact_detail_screen.dart';
import '../../features/contacts/presentation/screens/contact_list_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../shared/widgets/main_shell.dart';
import '../providers/app_lock_provider.dart';

// infortfounder://contact-request/123 deep links resolve to
// /contact-requests/123 through this same GoRouter config (see main.dart's
// MaterialApp.router — platform URI handling wires into `router.go(...)`
// with the same path once app links are configured per-platform).
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: _RiverpodRefreshStream(ref),
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final isLocked = ref.read(appLockProvider);
      final path = state.matchedLocation;

      if (authState is AuthInitial || authState is AuthChecking) {
        return path == '/splash' ? null : '/splash';
      }

      if (authState is Unauthenticated) {
        return path == '/login' ? null : '/login';
      }

      // Authenticated from here on.
      if (isLocked) {
        return path == '/lock' ? null : '/lock';
      }

      if (path == '/splash' || path == '/login' || path == '/lock') {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/lock', builder: (context, state) => const LockScreen()),
      GoRoute(
        path: '/contact-requests/:id',
        builder: (context, state) =>
            ContactDetailScreen(id: int.parse(state.pathParameters['id']!)),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/contact-requests',
                builder: (context, state) => const ContactListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/notifications',
                builder: (context, state) => const NotificationsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

/// Bridges Riverpod state changes into a Listenable so GoRouter re-evaluates
/// its redirect whenever auth or lock state changes.
class _RiverpodRefreshStream extends ChangeNotifier {
  _RiverpodRefreshStream(Ref ref) {
    ref.listen(authControllerProvider, (_, _) => notifyListeners());
    ref.listen(appLockProvider, (_, _) => notifyListeners());
  }
}
