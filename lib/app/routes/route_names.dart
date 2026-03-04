/// Human-readable route name constants.
///
/// Use these with [GoRouter.goNamed] / [context.goNamed] for named navigation.
/// Every route in [AppRouter] must have a matching entry here.
class RouteNames {
  const RouteNames._();

  static const String splash = 'splash';
  static const String welcome = 'welcome';
  static const String login = 'login';
  static const String register = 'register';
  static const String home = 'home';
  static const String scan = 'scan';
  static const String scanResult = 'scan-result';
  static const String history = 'history';
  static const String profile = 'profile';
  static const String settings = 'settings';
  static const String subscription = 'subscription';
}
