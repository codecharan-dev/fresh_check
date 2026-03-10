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
  static const String login = '/login';
}
