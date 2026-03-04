import 'package:fresh_check/app/routes/app_router.dart';
import 'package:fresh_check/app/routes/navigation_service.dart';
import 'package:fresh_check/config/env.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

// Global service locator.
// Always import this file directly — never through a barrel.
// Barrel imports risk circular dependencies:
//   feature → barrel → app_router → feature_page → feature_bloc → injection → [cycle]
//
// Correct usage anywhere in the project:
//   import 'package:fresh_check/app/di/injection.dart';
//   final myService = sl<MyService>();
final GetIt sl = GetIt.instance;

// ── Startup registration ───────────────────────────────────────────────────────
//
// Architectural rules enforced here — do not violate:
//
//   1. SYNC ONLY. No await, no Future, no async factories.
//      Firebase init runs in main.dart before this is called.
//      SharedPreferences init belongs in SplashBloc (after first frame).
//
//   2. CORE INFRASTRUCTURE ONLY. Router, network client, storage primitives.
//      Feature dependencies (BLoCs, repositories, use cases, datasources) are
//      NEVER registered here. They live in:
//        features/<name>/di/<name>_injection.dart
//      and are called lazily from app_router.dart pageBuilder.
//
//   3. ALL REGISTRATIONS ARE GUARDED. Every registration block starts with
//      isRegistered check to survive hot restart and re-entry.
//
//   4. registerSingleton (eager) IS NEVER USED.
//      Use registerLazySingleton — instance is built on first sl<T>() call,
//      not at registration time.
// ──────────────────────────────────────────────────────────────────────────────
void initCoreDependencies() {
  _registerConfig();
  _registerRouter();
  // Uncomment as each core layer file is built:
  // _registerNetwork();
  // _registerStorage();
}

// ── Config ────────────────────────────────────────────────────────────────────

void _registerConfig() {
  if (sl.isRegistered<AppConfig>()) return;
  sl.registerLazySingleton<AppConfig>(() => EnvironmentConfig.current);
}

// ── Router ────────────────────────────────────────────────────────────────────

void _registerRouter() {
  if (sl.isRegistered<GoRouter>()) return;

  // registerLazySingleton: the factory lambda is stored now but NOT called.
  // GoRouter is built on the first sl<GoRouter>() call, which happens inside
  // FreshCheckApp.build() — after runApp(), inside the widget tree.
  // NavigationService is wired explicitly here (not hidden inside AppRouter.build)
  // so the side effect is visible at the call site.
  sl.registerLazySingleton<GoRouter>(() {
    final router = AppRouter.build();
    NavigationService.router = router;
    return router;
  });
}

// ── Network ───────────────────────────────────────────────────────────────────
// Add when lib/core/network/api_client.dart is written.
// Dio constructor is sync — safe for lazy singleton.
//
// void _registerNetwork() {
//   if (sl.isRegistered<Dio>()) return;
//   sl.registerLazySingleton<Dio>(() => ApiClient.create(sl<AppConfig>()));
// }

// ── Storage ───────────────────────────────────────────────────────────────────
// FlutterSecureStorage constructor is sync — safe for lazy singleton.
// SharedPreferences.getInstance() is async — register it inside SplashBloc:
//   final prefs = await SharedPreferences.getInstance();
//   sl.registerSingleton<SharedPreferences>(prefs);
// Feature injection files can then safely call sl<SharedPreferences>() once
// SplashBloc has completed its async init sequence.
//
// void _registerStorage() {
//   if (sl.isRegistered<FlutterSecureStorage>()) return;
//   sl.registerLazySingleton<FlutterSecureStorage>(
//     () => const FlutterSecureStorage(),
//   );
// }
