/// URL path constants used in [AppRouter] route definitions and navigation.
///
/// Root paths are full absolute paths → use for navigation:
///   `context.go(RoutePaths.scan)`
///
/// Segment constants (e.g. [scanResultSegment]) are relative path segments →
/// used only inside [AppRouter] to define nested child routes.
/// For navigation to nested routes use the full path (e.g. [scanResult]).
class RoutePaths {
  const RoutePaths._();

  // ── Root paths ────────────────────────────────────────────────────
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String scan = '/scan';
  static const String history = '/history';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String subscription = '/subscription';

  // ── Nested segments (use in route definition only) ────────────────
  static const String scanResultSegment = 'result';

  // ── Full nested paths (use for navigation) ────────────────────────
  static const String scanResult = '$scan/$scanResultSegment'; // /scan/result
}
