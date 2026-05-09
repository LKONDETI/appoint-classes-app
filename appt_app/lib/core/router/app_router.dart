import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../shell/presentation/screens/main_shell.dart';

/// A [ChangeNotifier] that bridges Riverpod's [authProvider] into a
/// [Listenable] so GoRouter's [refreshListenable] triggers a redirect
/// re-evaluation whenever auth state changes.
class _AuthRouterNotifier extends ChangeNotifier {
  _AuthRouterNotifier(this._ref) {
    _ref.listen<AuthState>(authProvider, (prev, next) => notifyListeners());
  }

  final Ref _ref;

  bool get isAuthenticated => _ref.read(authProvider) is AuthAuthenticated;
}

final _authRouterNotifierProvider =
    ChangeNotifierProvider<_AuthRouterNotifier>(
  (ref) => _AuthRouterNotifier(ref),
);

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(_authRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: notifier,
    redirect: (context, state) {
      final isAuthenticated = notifier.isAuthenticated;
      final loc = state.matchedLocation;
      // ignore: avoid_print
      print('[ROUTER] redirect: loc=$loc isAuthenticated=$isAuthenticated');

      final isAuthRoute =
          loc == '/login' || loc == '/register' || loc == '/splash';

      if (!isAuthenticated && !isAuthRoute) {
        // ignore: avoid_print
        print('[ROUTER] → redirecting to /login (not authenticated)');
        return '/login';
      }
      if (isAuthenticated && isAuthRoute && loc != '/splash') {
        // ignore: avoid_print
        print('[ROUTER] → redirecting to /home (authenticated on auth route)');
        return '/home';
      }
      // ignore: avoid_print
      print('[ROUTER] → no redirect');
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (context, _) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, _) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, _) => const RegisterScreen()),
      GoRoute(path: '/home', builder: (context, _) => const MainShell()),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.error}')),
    ),
  );
});
