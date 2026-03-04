// Centralised page-transition system for FreshCheck.
//
// ── Adding a new animation type ───────────────────────────────────────────────
// 1. Add an entry to [AppTransition].
// 2. Write a static builder method that matches [RouteTransitionsBuilder]:
//      static Widget _myAnim(BuildContext, Animation<double>, Animation<double>, Widget)
// 3. Add a branch to the switch inside [AppRouteTransitions.buildPage].
// Done — the router does NOT need any other changes.
//
// ── Changing global speed ─────────────────────────────────────────────────────
// Edit [_kTransitionDuration]. Both push and pop update everywhere instantly.
//
// ── Overriding speed for a single route ───────────────────────────────────────
// Pass [duration] to [AppRouteTransitions.buildPage]. That route alone is
// affected; every other route continues to use [_kTransitionDuration].
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Single source of truth for transition speed across the entire app.
const Duration _kTransitionDuration = Duration(milliseconds: 300);

/// Available transition types for [AppRouteTransitions.buildPage].
///
/// Omit [transition] in [AppRouteTransitions.buildPage] to get [slide]
/// automatically — only specify a value to override for a specific route.
enum AppTransition {
  /// Slides in from right on push; reverses to right on pop. (Default)
  slide,

  /// Fades in on push; fades out on pop.
  fade,

  /// Scales up from 85 % with a simultaneous fade on push; reverses on pop.
  scale,

  /// Slides up from the bottom on push; slides down on pop.
  bottomToTop,
}

/// Factory for [CustomTransitionPage] instances.
///
/// Call [buildPage] from every [GoRoute.pageBuilder] in [AppRouter].
/// [transition] defaults to [AppTransition.slide] when omitted.
/// [duration] defaults to [_kTransitionDuration] when omitted.
///
/// ── Default route (slide, global duration) ────────────────────────────────
/// ```dart
/// pageBuilder: (context, state) => AppRouteTransitions.buildPage(
///   context: context,
///   state: state,
///   child: const LoginPage(),
/// ),
/// ```
///
/// ── Route with a custom animation type ────────────────────────────────────
/// ```dart
/// pageBuilder: (context, state) => AppRouteTransitions.buildPage(
///   context: context,
///   state: state,
///   child: const SplashPage(),
///   transition: AppTransition.fade,
/// ),
/// ```
///
/// ── Route with a custom animation type AND custom duration ─────────────────
/// ```dart
/// pageBuilder: (context, state) => AppRouteTransitions.buildPage(
///   context: context,
///   state: state,
///   child: const ScanPage(),
///   transition: AppTransition.fade,
///   duration: Duration(milliseconds: 200),
/// ),
/// ```
class AppRouteTransitions {
  AppRouteTransitions._();

  /// Wraps [child] in a [CustomTransitionPage] with the requested [transition].
  ///
  /// [transition] — animation style; defaults to [AppTransition.slide].
  /// [duration]   — push and pop speed; defaults to [_kTransitionDuration].
  ///                Pass a value to override for this route only.
  ///
  /// [state.pageKey] is forwarded so GoRouter preserves page identity for
  /// deep links and route guards — never pass a manual key here.
  static CustomTransitionPage<T> buildPage<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    AppTransition transition = AppTransition.slide,
    Duration? duration,
  }) {
    final effectiveDuration = duration ?? _kTransitionDuration;
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: effectiveDuration,
      reverseTransitionDuration: effectiveDuration,
      transitionsBuilder: switch (transition) {
        AppTransition.slide => _slide,
        AppTransition.fade => _fade,
        AppTransition.scale => _scale,
        AppTransition.bottomToTop => _bottomToTop,
      },
    );
  }

  // ── Transition builders ────────────────────────────────────────────────────
  // Every method signature matches RouteTransitionsBuilder:
  //   Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)
  //
  // Flutter drives `animation` forward (0→1) on push and backward (1→0) on
  // pop automatically — no explicit pop-direction logic is ever needed here.

  static Widget _slide(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final tween = Tween(
      begin: const Offset(1.0, 0.0), // off-screen right
      end: Offset.zero, // settled at centre
    ).chain(CurveTween(curve: Curves.easeInOut));
    return SlideTransition(position: animation.drive(tween), child: child);
  }

  static Widget _fade(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final tween = Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.easeInOut));
    return FadeTransition(opacity: animation.drive(tween), child: child);
  }

  static Widget _scale(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final scaleTween = Tween<double>(begin: 0.85, end: 1.0)
        .chain(CurveTween(curve: Curves.easeInOut));
    final fadeTween = Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.easeInOut));
    return ScaleTransition(
      scale: animation.drive(scaleTween),
      child: FadeTransition(
        opacity: animation.drive(fadeTween),
        child: child,
      ),
    );
  }

  static Widget _bottomToTop(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final tween = Tween(
      begin: const Offset(0.0, 1.0), // off-screen bottom
      end: Offset.zero, // settled at centre
    ).chain(CurveTween(curve: Curves.easeInOut));
    return SlideTransition(position: animation.drive(tween), child: child);
  }
}
