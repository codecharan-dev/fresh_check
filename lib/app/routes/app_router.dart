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
import 'package:fresh_check/app/routes/app_route_transitions.dart';
import 'package:fresh_check/app/routes/navigation_service.dart';
import 'package:fresh_check/app/routes/route_guards.dart';
import 'package:fresh_check/app/routes/route_names.dart';
import 'package:fresh_check/app/routes/route_paths.dart';
import 'package:fresh_check/features/auth/di/auth_injection.dart';
import 'package:fresh_check/features/auth/presentation/screens/login_screen.dart';
import 'package:fresh_check/features/auth/presentation/screens/signup_screen.dart';
import 'package:fresh_check/features/history/di/history_injection.dart';
import 'package:fresh_check/features/profile/di/profile_injection.dart';
import 'package:fresh_check/features/scan/di/scan_injection.dart';
import 'package:fresh_check/features/settings/di/settings_injection.dart';
import 'package:fresh_check/features/splash/di/splash_injection.dart';
import 'package:fresh_check/features/splash/presentation/screens/splash_screen.dart';
import 'package:fresh_check/features/subscription/di/subscription_injection.dart';
import 'package:fresh_check/features/welcome/presentation/screens/welcome_screen.dart';
import 'package:go_router/go_router.dart';
// import 'package:fresh_check/features/scan/presentation/screens/scan_screen.dart';
// import 'package:fresh_check/features/scan/presentation/screens/scan_result_screen.dart';
// import 'package:fresh_check/features/history/presentation/screens/history_screen.dart';
// import 'package:fresh_check/features/profile/presentation/screens/profile_screen.dart';
// import 'package:fresh_check/features/settings/presentation/screens/settings_screen.dart';
// import 'package:fresh_check/features/subscription/presentation/screens/subscription_screen.dart';

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

        // ── Welcome ──────────────────────────────────────────────────────────
        // Uses push() from splash — slide transition plays on entry.
        // PopScope(canPop: false) in WelcomeScreen prevents back to splash.
        GoRoute(
          path: RoutePaths.welcome,
          name: RouteNames.welcome,
          pageBuilder: (context, state) => AppRouteTransitions.buildPage(
            context: context,
            state: state,
            child: const WelcomeScreen(),
          ),
        ),

        // ── Auth ─────────────────────────────────────────────────────────────
        GoRoute(
          path: RoutePaths.login,
          name: RouteNames.login,
          pageBuilder: (context, state) {
            registerAuthDependencies();
            return AppRouteTransitions.buildPage(
              context: context,
              state: state,
              child: const LoginScreen(),
            );
          },
        ),
        GoRoute(
          path: RoutePaths.register,
          name: RouteNames.register,
          pageBuilder: (context, state) {
            registerAuthDependencies(); // same guard — no duplicate work
            return AppRouteTransitions.buildPage(
              context: context,
              state: state,
              child: const SignupScreen(),
            );
          },
        ),

        // ── Home ─────────────────────────────────────────────────────────────
        // Home typically aggregates multiple features (scan shortcut, history
        // preview). Register each feature the home page depends on here.
        GoRoute(
          path: RoutePaths.home,
          name: RouteNames.home,
          pageBuilder: (context, state) {
            // registerHomeDependencies(); // add when home feature is built
            return AppRouteTransitions.buildPage(
              context: context,
              state: state,
              child: const _PlaceholderScreen(label: 'Home'),
            );
          },
        ),

        // ── Scan (with nested result) ─────────────────────────────────────────
        GoRoute(
          path: RoutePaths.scan,
          name: RouteNames.scan,
          pageBuilder: (context, state) {
            registerScanDependencies();
            return AppRouteTransitions.buildPage(
              context: context,
              state: state,
              child: const _PlaceholderScreen(label: 'Scan'),
              // Replace with: child: const ScanScreen(),
              transition: AppTransition.fade,
            );
          },
          routes: [
            GoRoute(
              path: RoutePaths.scanResultSegment, // resolves → /scan/result
              name: RouteNames.scanResult,
              pageBuilder: (context, state) {
                registerScanDependencies(); // guard returns immediately — already registered
                return AppRouteTransitions.buildPage(
                  context: context,
                  state: state,
                  child: const _PlaceholderScreen(label: 'Scan Result'),
                  // Replace with: child: const ScanResultScreen(),
                );
              },
            ),
          ],
        ),

        // ── History ───────────────────────────────────────────────────────────
        GoRoute(
          path: RoutePaths.history,
          name: RouteNames.history,
          pageBuilder: (context, state) {
            registerHistoryDependencies();
            return AppRouteTransitions.buildPage(
              context: context,
              state: state,
              child: const _PlaceholderScreen(label: 'History'),
              // Replace with: child: const HistoryScreen(),
            );
          },
        ),

        // ── Profile ───────────────────────────────────────────────────────────
        GoRoute(
          path: RoutePaths.profile,
          name: RouteNames.profile,
          pageBuilder: (context, state) {
            registerProfileDependencies();
            return AppRouteTransitions.buildPage(
              context: context,
              state: state,
              child: const _PlaceholderScreen(label: 'Profile'),
              // Replace with: child: const ProfileScreen(),
            );
          },
        ),

        // ── Settings ──────────────────────────────────────────────────────────
        GoRoute(
          path: RoutePaths.settings,
          name: RouteNames.settings,
          pageBuilder: (context, state) {
            registerSettingsDependencies();
            return AppRouteTransitions.buildPage(
              context: context,
              state: state,
              child: const _PlaceholderScreen(label: 'Settings'),
              // Replace with: child: const SettingsScreen(),
            );
          },
        ),

        // ── Subscription ──────────────────────────────────────────────────────
        GoRoute(
          path: RoutePaths.subscription,
          name: RouteNames.subscription,
          pageBuilder: (context, state) {
            registerSubscriptionDependencies();
            return AppRouteTransitions.buildPage(
              context: context,
              state: state,
              child: const _PlaceholderScreen(label: 'Subscription'),
              // Replace with: child: const SubscriptionScreen(),
            );
          },
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Placeholder screens
// Replace each pageBuilder child with the real page when the feature is built.
// Delete these classes once all routes are wired to real pages.
// ─────────────────────────────────────────────────────────────────────────────

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(label)),
      body: Center(
        child: Text(
          '$label — coming soon',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
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
