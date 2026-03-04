// Barrel export for core infrastructure — the shared foundation used by
// every feature's data, domain, and presentation layers.
//
// Import this in feature repositories, use cases, and BLoCs:
//
//   import 'package:fresh_check/core/core_exports.dart';
//
// What this exposes:
//   Failures     — ServerFailure, NetworkFailure, CacheFailure, UnauthorizedFailure
//   Exceptions   — ServerException, NetworkException, CacheException, UnauthorizedException
//   UseCase      — abstract UseCase<Type, Params> + NoParams
//   ApiConstants — timeout durations
//   StorageKeys  — SharedPreferences + SecureStorage key constants
//   Extensions   — StringExtensions, ContextExtensions
//
// What this intentionally does NOT expose:
//   api_client.dart              — DI plumbing; only injection.dart needs it
//   auth_interceptor.dart        — DI plumbing; only injection.dart needs it
//   connectivity_interceptor.dart — DI plumbing; only injection.dart needs it
//
// How to activate each export:
//   Uncomment the line below as the corresponding file is written.
//   Run `fvm flutter analyze` after each addition to verify 0 issues.

// ── Error ─────────────────────────────────────────────────────────────────────
// export 'package:fresh_check/core/error/exceptions.dart';
// export 'package:fresh_check/core/error/failures.dart';

// ── UseCase ───────────────────────────────────────────────────────────────────
// export 'package:fresh_check/core/usecase/usecase.dart';

// ── Constants ─────────────────────────────────────────────────────────────────
// export 'package:fresh_check/core/constants/api_constants.dart';
// export 'package:fresh_check/core/constants/storage_keys.dart';

// ── Extensions ────────────────────────────────────────────────────────────────
// export 'package:fresh_check/core/extensions/context_extensions.dart';
// export 'package:fresh_check/core/extensions/string_extensions.dart';
