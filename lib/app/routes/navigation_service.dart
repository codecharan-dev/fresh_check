import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Programmatic navigation without [BuildContext].
///
/// Useful for navigating from Blocs, services, or anywhere outside the
/// widget tree. The [GoRouter] instance is set once via the [router] setter —
/// called automatically when [AppRouter.instance] is first accessed.
///
/// Usage (from a Bloc or service):
/// ```dart
/// NavigationService.go(RoutePaths.home);
/// NavigationService.goNamed(RouteNames.scanResult, extra: result);
/// ```
class NavigationService {
  NavigationService._();

  /// Root navigator key — shared with [GoRouter] so we have a stable handle
  /// to the navigator outside the widget tree.
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'rootNavigator');

  static late GoRouter _router;

  /// Set once by [AppRouter] immediately after the [GoRouter] is built.
  static set router(GoRouter value) => _router = value;

  // ── Navigation helpers ────────────────────────────────────────────

  /// Navigate to [location] (full path), replacing the current stack entry.
  static void go(String location, {Object? extra}) =>
      _router.go(location, extra: extra);

  /// Navigate to a named route.
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

  /// Push [location] onto the navigation stack.
  static Future<T?> push<T>(String location, {Object? extra}) =>
      _router.push(location, extra: extra);

  /// Push a named route onto the navigation stack.
  static Future<T?> pushNamed<T>(
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

  /// Pop the top-most route.
  static void pop<T>([T? result]) => _router.pop(result);

  /// Replace the current route with [location].
  static void replace(String location, {Object? extra}) =>
      _router.replace(location, extra: extra);
}
