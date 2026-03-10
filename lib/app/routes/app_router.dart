// Central routing configuration for FreshCheck.
//
// Responsibilities of this file:
//   - Define all GoRoute entries
//   - Call feature injection in each pageBuilder (lazy, guarded)
//   - Delegate transition logic to AppRouteTransitions
//
// This file must NOT:
//   - Be exported via app_exports.dart (circular dep risk)
//   - Import feature repositories, services, or BLoCs directly
//   - Perform any side effects inside AppRouter.build()
//
// ── Wiring a real feature page (when the feature is built) ───────────────────
// 1. Uncomment the feature page import below.
// 2. Uncomment the matching feature injection import below.
// 3. In the matching GoRoute, uncomment registerXxxDependencies() and
//    replace _PlaceholderScreen with the real page widget.
// 4. Uncomment the isRegistered guard inside the injection function.
// 5. Delete _PlaceholderScreen usage once all routes are wired.
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fresh_check/app/app_exports.dart';
import 'package:fresh_check/app/routes/app_route_transitions.dart';
import 'package:fresh_check/app/routes/route_guards.dart';
import 'package:fresh_check/features/auth/di/auth_injection.dart';
import 'package:fresh_check/features/auth/presentation/screens/login_screen.dart';
import 'package:fresh_check/features/splash/di/splash_injection.dart';
import 'package:fresh_check/features/splash/presentation/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';
// ─────────────────────────────────────────────────────────────────────────────

class AppRouter {
  AppRouter._();

  /// Builds and returns the configured [GoRouter].
  ///
  /// Pure factory — no side effects. [NavigationService] is wired by the
  /// caller (injection.dart) immediately after this returns, keeping the
  /// side effect explicit and visible at the registration site.
  ///
  /// Must be called exactly once — via the lazy singleton factory in
  /// [initCoreDependencies]. Never call this directly.
  static GoRouter build() {
    return GoRouter(
      navigatorKey: NavigationService.navigatorKey,
      initialLocation: RoutePaths.splash,
      debugLogDiagnostics: kDebugMode,
      redirect: RouteGuard.authGuard,
      errorBuilder: (context, state) => _ErrorScreen(error: state.error),
      routes: [
        // ── Splash ───────────────────────────────────────────────────────────
        GoRoute(
          path: RoutePaths.splash,
          name: RouteNames.splash,
          pageBuilder: (context, state) {
            registerSplashDependencies();
            return AppRouteTransitions.buildPage(
              context: context,
              state: state,
              child: const SplashScreen(),
              transition: AppTransition.fade,
            );
          },
        ),

        // ── Auth ─────────────────────────────────────────────────────────────
        GoRoute(
          path: RoutePaths.login,
          name: RouteNames.loginScreen,
          pageBuilder: (context, state) {
            registerAuthDependencies();
            return AppRouteTransitions.buildPage(
              context: context,
              state: state,
              child: const LoginScreen(),
            );
          },
        ),

      ],
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({this.error});

  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Route not found\n${error?.toString() ?? ''}',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
