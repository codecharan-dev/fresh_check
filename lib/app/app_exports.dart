// Barrel export for the app layer's public API.
//
// Import this in any feature screen or BLoC that needs routing or theming:
//
//   import 'package:fresh_check/app/app_exports.dart';
//
// What this exposes:
//   RouteNames         — named route string constants
//   RoutePaths         — URL path constants + nested segments
//   NavigationService  — context-free navigation for BLoCs/services
//   AppColors          — brand palette + freshness indicator colors  [uncomment when written]
//   AppTheme           — ThemeData factory                           [uncomment when written]
//
// What this intentionally does NOT expose:
//   injection.dart     — circular dependency risk; always import directly
//   app_router.dart    — internal GoRouter wiring; never exported — when the router
//                        imports real feature pages, exporting it here would create
//                        a cycle: feature → barrel → router → feature_page → [cycle]
//   route_guards.dart  — internal; only app_router.dart references this

// ── Routing ───────────────────────────────────────────────────────────────────
export 'package:fresh_check/app/routes/navigation_service.dart';
export 'package:fresh_check/app/routes/route_names.dart';
export 'package:fresh_check/app/routes/route_paths.dart';

// ── Theme ─────────────────────────────────────────────────────────────────────
export 'package:fresh_check/app/theme/app_colors.dart';
export 'package:fresh_check/app/theme/app_text_theme.dart';
export 'package:fresh_check/app/theme/app_theme.dart';
