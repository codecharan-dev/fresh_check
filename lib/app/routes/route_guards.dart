import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Authentication and authorisation guard skeleton.
///
/// Plugged into [GoRouter.redirect]. Returns `null` to allow navigation,
/// or a path string to redirect elsewhere.
///
/// How to wire real auth (future step):
///   1. Inject the auth repository / token service via GetIt: `sl<AuthRepository>()`
///   2. Uncomment the guard block below and replace the placeholder.
///   3. Add token-refresh logic in [onError] inside [AppRouter] if needed.
class RouteGuard {
  const RouteGuard._();

  /// Top-level redirect applied to every navigation event.
  static String? authGuard(BuildContext context, GoRouterState state) {
    // Dev mode: all routes open. Uncomment the block below when auth is ready.

    // final bool isAuthenticated = sl<AuthRepository>().isAuthenticated;
    // final bool isPublicRoute =
    //     state.matchedLocation == RoutePaths.splash ||
    //     state.matchedLocation == RoutePaths.login ||
    //     state.matchedLocation == RoutePaths.register;
    // if (!isAuthenticated && !isPublicRoute) return RoutePaths.login;

    return null; // allow all navigation during development
  }
}
