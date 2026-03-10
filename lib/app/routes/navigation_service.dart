import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Context-free navigation for BLoCs, services, and callbacks.
//
// Methods are grouped by platform recommendation:
//
//   Mobile (Android / iOS)
//     push, pushNamed, pushReplacement, pushReplacementNamed, pop
//     → Imperative — plays page transitions, ideal for stack-based mobile UX.
//
//   Web (browser)
//     go, goNamed
//     → Declarative — replaces the entire stack AND updates the browser URL.
//       On mobile these still work but skip page transitions.
//
//   All platforms
//     replace, replaceNamed, pop, canPop, refresh, currentLocation, currentMatch
//     → Utility methods that behave identically everywhere.
//
// Usage:
//   NavigationService.push(RoutePaths.scan);
//   NavigationService.pushReplacement(RoutePaths.home);
//   NavigationService.go(RoutePaths.home);
class NavigationService {
  NavigationService._();

  /// Root navigator key — shared with [GoRouter] so we have a stable handle
  /// to the navigator outside the widget tree.
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'rootNavigator');

  static late GoRouter _router;

  /// Set once by the DI lambda in [initCoreDependencies] immediately after
  /// [AppRouter.build] returns.
  static set router(GoRouter value) => _router = value;

  // ═══════════════════════════════════════════════════════════════════════════
  // MOBILE (Android / iOS) — imperative, plays page transitions
  // ═══════════════════════════════════════════════════════════════════════════

  /// Push [location] onto the stack — plays the destination's page transition.
  static Future<T?> push<T extends Object?>(
    String location, {
    Object? extra,
  }) =>
      _router.push(location, extra: extra);

  /// Push a named route onto the stack — plays the destination's page
  /// transition.
  static Future<T?> pushNamed<T extends Object?>(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) =>
      _router.pushNamed(
        name,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra,
      );

  /// Replace the top-most route with [location] — plays the page transition.
  ///
  /// Use for flows like splash → welcome where the user should not go back.
  static Future<T?> pushReplacement<T extends Object?>(
    String location, {
    Object? extra,
  }) =>
      _router.pushReplacement(location, extra: extra);

  /// Replace the top-most route with a named route — plays the page
  /// transition.
  static Future<T?> pushReplacementNamed<T extends Object?>(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) =>
      _router.pushReplacementNamed(
        name,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // WEB (browser) — declarative, updates the URL bar
  // ═══════════════════════════════════════════════════════════════════════════

  /// Navigate to [location], replacing the entire navigation stack.
  ///
  /// On web this updates the browser URL. On mobile it works but skips
  /// page transitions — prefer [push] / [pushReplacement] on mobile.
  static void go(String location, {Object? extra}) =>
      _router.go(location, extra: extra);

  /// Navigate to a named route, replacing the entire navigation stack.
  ///
  /// On web this updates the browser URL. On mobile it works but skips
  /// page transitions — prefer [pushNamed] / [pushReplacementNamed]
  /// on mobile.
  static void goNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) =>
      _router.goNamed(
        name,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // ALL PLATFORMS — utility methods
  // ═══════════════════════════════════════════════════════════════════════════

  // ── Silent replacement (no animation) ──────────────────────────────

  /// Swap the current route with [location] without any page transition.
  ///
  /// Treats the new route as the "same page" — useful for updating
  /// path/query parameters silently (e.g. filter changes in a list).
  static void replace(String location, {Object? extra}) =>
      _router.replace(location, extra: extra);

  /// Swap the current route with a named route without any page transition.
  static void replaceNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) =>
      _router.replaceNamed(
        name,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra,
      );

  // ── Pop ─────────────────────────────────────────────────────────────

  /// Pop the top-most route, optionally returning [result] to the caller.
  static void pop<T extends Object?>([T? result]) => _router.pop(result);

  /// Pop routes until [predicate] returns true.
  ///
  /// Useful for popping back to a specific screen in a deep stack.
  /// Example: `NavigationService.popUntil((route) => route.isFirst);`
  static void popUntil(bool Function(Route<dynamic>) predicate) {
    navigatorKey.currentState?.popUntil(predicate);
  }

  // ── Query ───────────────────────────────────────────────────────────

  /// Whether the top-most route can be popped.
  ///
  /// Returns `false` when the current route is the last route in the stack
  /// (e.g. the initial route). Useful in BLoCs to decide whether to pop
  /// or navigate elsewhere.
  static bool canPop() => _router.canPop();

  /// The current top-most [RouteMatch].
  ///
  /// Useful for reading the matched route from outside the widget tree.
  static RouteMatch get currentMatch =>
      _router.routerDelegate.currentConfiguration.last;

  /// The current full URI string (e.g. `/scan/result?id=42`).
  static String get currentLocation =>
      _router.routerDelegate.currentConfiguration.uri.toString();

  // ── Refresh ─────────────────────────────────────────────────────────

  /// Force the router to re-evaluate its current route.
  ///
  /// Triggers the [redirect] callback again — useful after login/logout
  /// to re-evaluate auth guards without an explicit navigation call.
  static void refresh() => _router.refresh();
}
