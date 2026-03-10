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
// Edit [defaultTransitionDuration]. Both push and pop update everywhere.
//
// ── Changing global curve ─────────────────────────────────────────────────────
// Edit [defaultCurve]. All transitions update everywhere.
//
// ── Overriding for a single route ─────────────────────────────────────────────
// Pass [duration], [reverseDuration], or [curve] to
// [AppRouteTransitions.buildPage]. That route alone is affected.
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ── Default transition configuration ─────────────────────────────────────────
// Change these to update all transitions globally from one place.
const Duration defaultTransitionDuration = Duration(milliseconds: 300);
const Duration defaultReverseTransitionDuration = Duration(milliseconds: 300);
const Curve defaultCurve = Curves.easeInOut;

/// Available transition types for [AppRouteTransitions.buildPage].
enum AppTransition {
  /// Slides in from right → left. (Default)
  slide,

  /// Slides in from left → right.
  slideLeft,

  /// Slides in from right → left (alias for [slide]).
  slideRight,

  /// Slides up from the bottom.
  slideUp,

  /// Slides down from the top.
  slideDown,

  /// Cross-fade.
  fade,

  /// Scales up from 85% with a simultaneous fade.
  scale,

  /// Rotates in with a simultaneous fade.
  rotation,

  /// No animation — instant swap.
  none,
}

/// Factory for [CustomTransitionPage] instances.
///
/// Call [buildPage] from every [GoRoute.pageBuilder] in [AppRouter].
///
/// ```dart
/// pageBuilder: (context, state) => AppRouteTransitions.buildPage(
///   context: context,
///   state: state,
///   child: const HomeScreen(),
///   transition: AppTransition.slideUp,
///   duration: const Duration(milliseconds: 350),
///   curve: Curves.easeOut,
/// ),
/// ```
class AppRouteTransitions {
  AppRouteTransitions._();

  static CustomTransitionPage<T> buildPage<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    AppTransition transition = AppTransition.slide,
    Duration? duration,
    Duration? reverseDuration,
    Curve? curve,
  }) {
    final effectiveDuration = duration ?? defaultTransitionDuration;
    final effectiveReverseDuration =
        reverseDuration ?? defaultReverseTransitionDuration;
    final effectiveCurve = curve ?? defaultCurve;

    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: effectiveDuration,
      reverseTransitionDuration: effectiveReverseDuration,
      transitionsBuilder: _resolveBuilder(transition, effectiveCurve),
    );
  }

  static RouteTransitionsBuilder _resolveBuilder(
    AppTransition transition,
    Curve curve,
  ) {
    return switch (transition) {
      AppTransition.slide || AppTransition.slideRight => _slideFrom(
          const Offset(1.0, 0.0),
          curve,
        ),
      AppTransition.slideLeft => _slideFrom(
          const Offset(-1.0, 0.0),
          curve,
        ),
      AppTransition.slideUp => _slideFrom(
          const Offset(0.0, 1.0),
          curve,
        ),
      AppTransition.slideDown => _slideFrom(
          const Offset(0.0, -1.0),
          curve,
        ),
      AppTransition.fade => _buildFade(curve),
      AppTransition.scale => _buildScale(curve),
      AppTransition.rotation => _buildRotation(curve),
      AppTransition.none => _buildNone,
    };
  }

  // ── Transition builders ──────────────────────────────────────────────────

  static RouteTransitionsBuilder _slideFrom(Offset begin, Curve curve) {
    return (context, animation, secondaryAnimation, child) {
      final tween = Tween(begin: begin, end: Offset.zero)
          .chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    };
  }

  static RouteTransitionsBuilder _buildFade(Curve curve) {
    return (context, animation, secondaryAnimation, child) {
      final tween = Tween<double>(begin: 0.0, end: 1.0)
          .chain(CurveTween(curve: curve));
      return FadeTransition(opacity: animation.drive(tween), child: child);
    };
  }

  static RouteTransitionsBuilder _buildScale(Curve curve) {
    return (context, animation, secondaryAnimation, child) {
      final scaleTween = Tween<double>(begin: 0.85, end: 1.0)
          .chain(CurveTween(curve: curve));
      final fadeTween = Tween<double>(begin: 0.0, end: 1.0)
          .chain(CurveTween(curve: curve));
      return ScaleTransition(
        scale: animation.drive(scaleTween),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        ),
      );
    };
  }

  static RouteTransitionsBuilder _buildRotation(Curve curve) {
    return (context, animation, secondaryAnimation, child) {
      final rotateTween = Tween<double>(begin: 0.5, end: 1.0)
          .chain(CurveTween(curve: curve));
      final fadeTween = Tween<double>(begin: 0.0, end: 1.0)
          .chain(CurveTween(curve: curve));
      return RotationTransition(
        turns: animation.drive(rotateTween),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        ),
      );
    };
  }

  static Widget _buildNone(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
