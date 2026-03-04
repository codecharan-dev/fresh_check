# FreshCheck

A food quality checking mobile app. Point the camera at food — fish, meat, fruits, vegetables — and get an instant freshness assessment: **Green** (fresh), **Yellow** (consume soon), or **Red** (avoid).

**Platforms:** Android · iOS
**Flutter:** 3.41.0 (managed via FVM)
**Dart:** 3.11.0

---

## Table of Contents

### Setup & Running
| # | Section                                                 | What you'll find                                                    |
|---|---------------------------------------------------------|---------------------------------------------------------------------|
| 1 | [Prerequisites](#prerequisites)                         | Tools & versions needed to build the app                            |
| 2 | [Getting Started](#getting-started)                     | Clone → install → run in 4 commands                                 |
| 3 | [Environment Configuration](#environment-configuration) | 4 flavors (dev/qa/staging/prod), Firebase per env, app name per env |
| 4 | [Android Build Notes](#android-build-notes)             | Core library desugaring fix for `flutter_local_notifications`       |

### Codebase Guide
| #  | Section                                       | What you'll find                                                    |
|----|-----------------------------------------------|---------------------------------------------------------------------|
| 5  | [Project Structure](#project-structure)       | Full directory tree with one-line descriptions                      |
| 6  | [Architecture](#architecture)                 | Clean Architecture layers, rules, folder jobs, full call chain      |
| 7  | [State Management](#state-management)         | BLoC pattern: events, states, `dartz fold`, transformers, UI wiring |
| 8  | [Dependency Injection](#dependency-injection) | GetIt setup, registration types, lazy loading, feature injection    |
| 9  | [Routing](#routing)                           | go_router wiring, all routes, navigation from widgets & BLoCs       |
| 10 | [Page Transitions](#page-transitions)         | Animation types, per-route customization, adding new animations     |
| 11 | [Error Handling](#error-handling)             | Exceptions → Failures → BLoC → UI (full error flow)                 |

### Day-to-Day Development
| #  | Section                                          | What you'll find                                              |
|----|--------------------------------------------------|---------------------------------------------------------------|
| 12 | [Code Generation](#code-generation)              | `build_runner` commands for freezed & json_serializable       |
| 13 | [Adding a New Feature](#adding-a-new-feature)    | Step-by-step: directory tree → DI → routes → codegen → verify |
| 14 | [Key Packages](#key-packages)                    | Every dependency and why it's here                            |
| 15 | [Lint & Static Analysis](#lint--static-analysis) | Rules enforced, error promotions, suppression syntax          |
| 16 | [Naming Conventions](#naming-conventions)        | Files, classes, BLoC, models, entities, use cases             |

### Status
| #  | Section                                                  | What you'll find                                       |
|----|----------------------------------------------------------|--------------------------------------------------------|
| 17 | [Known Issues / In Progress](#known-issues--in-progress) | Splash, core layer, theme, bloc observer — all pending |

---

## Prerequisites

| Tool           | Version | Install                        |
|----------------|---------|--------------------------------|
| FVM            | latest  | `dart pub global activate fvm` |
| Flutter        | 3.41.0  | managed by FVM                 |
| Dart           | 3.11.0  | comes with Flutter via FVM     |
| Xcode          | 15+     | Mac App Store (iOS builds)     |
| Android Studio | latest  | for Android SDK / emulator     |

> **Never use the global `flutter` command.** Always prefix with `fvm flutter` to ensure the pinned version is used.

---

## Getting Started

```bash
# 1. Install the pinned Flutter version
fvm install

# 2. Get dependencies
fvm flutter pub get

# 3. Run code generation (freezed / json_serializable)
fvm flutter pub run build_runner build --delete-conflicting-outputs

# 4. Run the app (dev flavor by default)
fvm flutter run --flavor dev
```

---

## Environment Configuration

The app uses **product flavors** (Android) and **Xcode schemes** (iOS) to manage four environments. Each environment has its own Firebase project, bundle ID, and configuration.

| Flavor     | Config class    | Bundle ID suffix | Firebase project        |
|------------|-----------------|------------------|-------------------------|
| `dev`      | `DevConfig`     | `.dev`           | `freshcheck-dev-3a5fd`  |
| `qa`       | `QaConfig`      | `.qa`            | `freshcheck-qa`         |
| `staging`  | `StagingConfig` | `.staging`       | `freshcheck-staging`    |
| `prod`     | `ProdConfig`    | *(none)*         | `freshcheck-prod`       |

**Run commands:**

```bash
# Development (default)
fvm flutter run --flavor dev

# QA
fvm flutter run --flavor qa

# Staging
fvm flutter run --flavor staging

# Production (release mode)
fvm flutter run --flavor prod --release
```

**Build commands:**

```bash
# Android APK
fvm flutter build apk --flavor dev --debug
fvm flutter build apk --flavor prod --release

# Android App Bundle (Play Store)
fvm flutter build appbundle --flavor prod --release

# iOS
fvm flutter build ios --flavor prod --release
```

**How flavor detection works:**

Flutter automatically sets `FLUTTER_APP_FLAVOR` when using `--flavor`. In `main.dart`:

```dart
const flavor = String.fromEnvironment('FLUTTER_APP_FLAVOR');
EnvironmentConfig.initialize(flavor.isEmpty ? 'dev' : flavor);
await Firebase.initializeApp(options: EnvironmentConfig.current.firebaseOptions);
```

Each flavor config (`lib/config/<flavor>_config.dart`) implements `AppConfig` and provides the correct `FirebaseOptions` from its matching `config/firebase/firebase_options_<flavor>.dart` file.

### Firebase per-flavor file locations

| Platform | Location                                             |
|----------|------------------------------------------------------|
| Android  | `android/app/src/<flavor>/google-services.json`      |
| iOS      | `ios/Firebase/<flavor>/GoogleService-Info.plist`     |
| Dart     | `lib/config/firebase/firebase_options_<flavor>.dart` |

iOS uses a build phase script that copies the correct `GoogleService-Info.plist` into the app bundle based on `APP_FLAVOR` (set in each flavor's xcconfig).

### App name per environment

The launcher/home screen app name changes per flavor:

- **Android**: `AndroidManifest.xml` uses `android:label="@string/app_name"` — each flavor defines `app_name` via `resValue` in `build.gradle.kts`
- **iOS**: `Info.plist` uses `$(APP_DISPLAY_NAME)` for both `CFBundleDisplayName` and `CFBundleName` — each flavor xcconfig sets `APP_DISPLAY_NAME`
- **Flutter**: `MaterialApp.router` uses `title: sl<AppConfig>().name` for the OS task switcher

| Flavor   | App Name           |
|----------|--------------------|
| dev      | FreshCheck Dev     |
| qa       | FreshCheck QA      |
| staging  | FreshCheck Staging |
| prod     | FreshCheck         |

---

## Android Build Notes

### Core Library Desugaring

`flutter_local_notifications` uses Java 8+ `java.time.*` APIs (e.g. `LocalDateTime`, `ZonedDateTime`) for notification scheduling. These APIs are not available natively on Android < API 26. Core library desugaring is a build-time transformation that backports them.

The following has already been applied to `android/app/build.gradle.kts`:

```kotlin
android {
    compileOptions {
        isCoreLibraryDesugaringEnabled = true   // ← enable backport
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
```

> If you add other packages that require desugaring, this config already covers them — no additional changes needed.

---

## Project Structure

```
lib/
├── core/                        # Framework-agnostic, shared infrastructure
│   ├── constants/
│   │   ├── api_constants.dart   # Timeout values, API version
│   │   └── storage_keys.dart    # SharedPreferences / SecureStorage key names
│   ├── error/
│   │   ├── exceptions.dart      # Data layer throws these
│   │   └── failures.dart        # Domain layer uses these (Either<Failure, T>)
│   ├── extensions/
│   │   ├── context_extensions.dart
│   │   └── string_extensions.dart
│   ├── network/
│   │   ├── api_client.dart      # Dio instance factory
│   │   └── interceptors/
│   │       ├── auth_interceptor.dart
│   │       └── connectivity_interceptor.dart
│   ├── storage/                 # SharedPreferences + SecureStorage abstractions
│   ├── usecase/
│   │   └── usecase.dart         # Abstract UseCase<Type, Params> + NoParams
│   └── utils/                   # Validators, formatters, helpers
│
├── config/
│   ├── firebase/
│   │   ├── firebase_options_dev.dart      # Auto-generated by FlutterFire CLI
│   │   ├── firebase_options_qa.dart
│   │   ├── firebase_options_staging.dart
│   │   └── firebase_options_prod.dart
│   ├── env.dart                 # Environment enum + AppConfig abstract class
│   ├── dev_config.dart
│   ├── qa_config.dart
│   ├── staging_config.dart
│   └── prod_config.dart
│
├── app/
│   ├── di/
│   │   └── injection.dart       # Core-only DI — initCoreDependencies() called in main
│   ├── routes/
│   │   ├── route_names.dart     # Named route string constants
│   │   ├── route_paths.dart     # URL path constants (full + nested segments)
│   │   ├── route_guards.dart    # Auth guard — plugged into GoRouter.redirect
│   │   ├── navigation_service.dart  # Context-free navigation (for BLoCs)
│   │   └── app_router.dart      # GoRouter config — AppRouter.build()
│   ├── theme/
│   │   ├── app_colors.dart      # Brand palette + freshness indicator colors
│   │   └── app_theme.dart       # ThemeData (light theme)
│   ├── bloc_observer.dart       # AppBlocObserver — logs all BLoC transitions
│   └── app.dart                 # FreshCheckApp root MaterialApp widget
│
├── shared/
│   └── widgets/                 # Reusable UI not owned by any single feature
│       ├── appbar/
│       ├── buttons/
│       ├── cards/
│       ├── dialogs/
│       ├── images/
│       ├── inputs/
│       ├── loading/
│       ├── spacing/
│       └── states/
│
├── features/
│   ├── auth/                    # Login, register, token/session lifecycle
│   │   ├── di/
│   │   │   └── auth_injection.dart      # ← feature DI, called lazily by router
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── scan/                    # Camera capture, AI call, scan result page
│   │   ├── di/
│   │   │   └── scan_injection.dart
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── history/
│   │   └── di/
│   │       └── history_injection.dart
│   ├── profile/
│   │   └── di/
│   │       └── profile_injection.dart
│   ├── subscription/
│   │   └── di/
│   │       └── subscription_injection.dart
│   └── settings/
│       └── di/
│           └── settings_injection.dart
│
└── main.dart                    # Entry point — async (Firebase init before runApp)
```

Each feature follows the same three-layer structure — see [Adding a New Feature](#adding-a-new-feature).

---

## Architecture

Clean Architecture with three layers per feature:

```
Presentation  →  Domain  →  Data
(BLoC / UI)      (Entities, UseCases, Repository interfaces)
                              (Models, DataSources, Repository impls)
```

### Layer rules — non-negotiable

| Layer                     | Tool                            | Rule                                           |
|---------------------------|---------------------------------|------------------------------------------------|
| Domain Entities           | `Equatable`                     | Pure Dart — zero package imports, no code gen  |
| UseCase Params + NoParams | `Equatable`                     | Domain layer — same rule                       |
| BLoC Events + States      | `freezed` sealed                | Pattern matching via when/maybeWhen/whenOrNull |
| Data Models               | `freezed` + `json_serializable` | Extends domain entity, adds fromJson/toJson    |
| Failures                  | `sealed class` + `Equatable`    | Exhaustive switch handling in BLoC             |

### What each folder does

#### `domain/entities/`
Pure Dart domain objects. Extend `Equatable`. No serialization. No framework imports. Used by use cases, repositories (interface), BLoC states, and UI.

```dart
class ScanResultEntity extends Equatable {
  const ScanResultEntity({
    required this.id,
    required this.foodType,
    required this.freshnessLevel,
    required this.confidence,
    required this.scannedAt,
  });

  final String id;
  final String foodType;
  final FreshnessLevel freshnessLevel; // enum: green, yellow, red
  final double confidence;
  final DateTime scannedAt;

  @override
  List<Object?> get props => [id, foodType, freshnessLevel, confidence, scannedAt];
}
```

#### `data/models/`
`freezed` classes that **extend** the domain entity. Add `fromJson`/`toJson` via `json_serializable`. Map API field names via `@JsonKey`. Model IS the entity — no manual conversion needed.

```dart
@freezed
class ScanResultModel extends ScanResultEntity with _$ScanResultModel {
  const factory ScanResultModel({
    required String id,
    @JsonKey(name: 'food_type') required String foodType,
    @JsonKey(name: 'freshness_level') required FreshnessLevel freshnessLevel,
    required double confidence,
    @JsonKey(name: 'scanned_at') required DateTime scannedAt,
  }) = _ScanResultModel;

  factory ScanResultModel.fromJson(Map<String, dynamic> json) =>
      _$ScanResultModelFromJson(json);
}
```

#### `data/datasources/`
Raw I/O only. Returns **models** (never entities). Throws **exceptions** (never `Either`). Two types per feature:
- `RemoteDataSource` — Dio HTTP calls
- `LocalDataSource` — SharedPreferences / SecureStorage

#### `domain/repositories/` + `data/repositories/`
Domain owns the **abstract interface**. Data owns the **implementation**. Repository catches datasource exceptions and wraps them in `Left(Failure)`. Returns `Right(Entity)` on success. Decides caching strategy.

#### `domain/usecases/`
One class per business action. Implements `UseCase<ReturnType, Params>`. Params extend `Equatable`. Calls repository — never datasources directly. Returns `Either<Failure, Entity>`.

### Full call chain

```
UI adds event to BLoC
  → BLoC emits loading → UI shows spinner
    → BLoC calls UseCase(params)
      → UseCase calls Repository.method()
        → Repository calls RemoteDataSource.method()
          → Dio POST → JSON response → Model returned (or Exception thrown)
        → Repository catches Exception → Left(Failure)
        → Repository returns Right(Entity) on success
      → UseCase returns Either<Failure, Entity>
    → BLoC fold:
        Left  → emit failure state → listener shows toast
        Right → emit success state → listener navigates
```

---

## State Management

**flutter_bloc** (BLoC pattern).

```
Event → BLoC → State → UI
```

### Events — `freezed` sealed

```dart
@freezed
sealed class AuthEvent with _$AuthEvent {
  const factory AuthEvent.loginSubmitted({
    required String email,
    required String password,
  }) = LoginSubmitted;

  const factory AuthEvent.logoutRequested() = LogoutRequested;
}
```

### States — `freezed` sealed

Every feature state has these factories: `initial`, `loading`, success variant, `failure(Failure)`.

```dart
@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial()                      = AuthInitial;
  const factory AuthState.loading()                      = AuthLoading;
  const factory AuthState.authenticated(UserEntity user) = AuthAuthenticated;
  const factory AuthState.unauthenticated()              = AuthUnauthenticated;
  const factory AuthState.failure(Failure failure)       = AuthFailure;
}
```

### BLoC — dartz fold + transformers

```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required LoginUseCase loginUseCase})
      : _loginUseCase = loginUseCase,
        super(const AuthState.initial()) {
    on<LoginSubmitted>(_onLoginSubmitted, transformer: droppable());
  }

  final LoginUseCase _loginUseCase;

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final result = await _loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthState.failure(failure)),
      (user)    => emit(AuthState.authenticated(user)),
    );
  }
}
```

### BLoC Transformers (`bloc_concurrency`)

| Transformer     | Behaviour                           | Use for                        |
|-----------------|-------------------------------------|--------------------------------|
| `droppable()`   | Ignores new events while processing | Login, scan, any submit button |
| `restartable()` | Cancels current, starts new         | Search, filter, typeahead      |
| `sequential()`  | Queues events one by one            | Pagination                     |
| `concurrent()`  | Runs all in parallel                | Independent data fetches       |

### UI — `BlocConsumer` pattern

```dart
BlocConsumer<AuthBloc, AuthState>(
  // only trigger listener for side effects (navigation, toasts)
  listenWhen: (prev, curr) => curr is AuthAuthenticated || curr is AuthFailure,
  listener: (context, state) {
    state.whenOrNull(
      authenticated: (_)  => context.go(RoutePaths.home),
      failure: (failure)  => AppToast.show(context, failure.message),
    );
  },
  // only rebuild for visual state changes
  buildWhen: (prev, curr) => curr is AuthLoading || curr is AuthInitial,
  builder: (context, state) {
    return state.maybeWhen(
      loading: () => const FullScreenLoader(),
      orElse:  () => const LoginForm(),
    );
  },
)
```

### when / maybeWhen / whenOrNull

| Method       | Use when                                                                                                        |
|--------------|-----------------------------------------------------------------------------------------------------------------|
| `when`       | All states must be handled — compiler error if any missed. Use in `builder` when every state has a distinct UI. |
| `maybeWhen`  | Only some states need handling, rest share a default. Use in `builder`.                                         |
| `whenOrNull` | Only some states need handling, rest return null. Use in `listener`.                                            |

### `AppBlocObserver`
`app/bloc_observer.dart` — logs all BLoC transitions and errors in debug mode.

---

## Dependency Injection

**get_it** with a global `sl` service locator. The DI strategy is built around one rule: **only pay for what you use, and only when you use it.**

### How it works

```
main() — async
  └── EnvironmentConfig.initialize(flavor)
  └── await Firebase.initializeApp()
  └── initCoreDependencies()     registers AppConfig (lazy), GoRouter (lazy)
        └── runApp()             first frame renders (native splash covers Firebase init)

  User navigates to /login
    └── pageBuilder fires
          └── registerAuthDependencies()   registers auth layers for the first time
                └── LoginPage renders     AuthBloc now available via sl<AuthBloc>()
```

### Global service locator

```dart
// Always import injection.dart directly — never through a barrel.
import 'package:fresh_check/app/di/injection.dart';

final myRepo = sl<MyRepository>();
```

### Registration types

| Type       | Method                  | When to use                   |
|------------|-------------------------|-------------------------------|
| BLoC       | `registerFactory`       | New instance per screen mount |
| Repository | `registerLazySingleton` | Shared stateless service      |
| UseCase    | `registerLazySingleton` | Shared stateless service      |
| DataSource | `registerLazySingleton` | Shared stateless service      |
| Core infra | `registerLazySingleton` | GoRouter, Dio, SecureStorage  |

> `registerSingleton` (eager) is **never used** in this project. It constructs the instance at registration time, blocking startup before the first frame.

### Startup registration (`app/di/injection.dart`)

Only core infrastructure goes here. `initCoreDependencies()` is sync — no `await`, no `Future`:

```dart
void initCoreDependencies() {
  _registerConfig();   // ← AppConfig (env-specific)
  _registerRouter();
  // _registerNetwork();  ← Dio + interceptors (uncomment when core/network is built)
  // _registerStorage();  ← FlutterSecureStorage (uncomment when core/storage is built)
}
```

### Async services (SharedPreferences)

`Firebase.initializeApp()` is called in `main.dart` before `runApp()` — the native splash screen covers the brief delay.

`SharedPreferences` requires `await` and will be initialized inside `SplashBloc` (after the first frame) when the splash feature is built:

```dart
// Future: Inside SplashBloc — NOT in main() or injection.dart
final prefs = await SharedPreferences.getInstance();
sl.registerSingleton<SharedPreferences>(prefs);
// Feature injections can now safely call sl<SharedPreferences>()
```

### Feature injection files

Each feature owns its dependency registration in `features/<name>/di/<name>_injection.dart`. The function is called from `app_router.dart`'s `pageBuilder` — lazily, only when that route is first navigated to.

**Structure (using auth as example):**

```dart
// features/auth/di/auth_injection.dart
void registerAuthDependencies() {
  if (sl.isRegistered<AuthBloc>()) return;  // guard — safe to call on every navigation

  // Data layer
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl()),
  );

  // Domain layer
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));

  // Presentation layer — factory: fresh BLoC per screen mount
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(loginUseCase: sl()),
  );
}
```

**The `isRegistered` guard is mandatory on every injection function.** It prevents duplicate registration crashes on hot restart, deep-link double-fires, and any future re-entry.

---

## Routing

**go_router** (`^17.1.0`) — registered as a lazy singleton in GetIt, consumed via `sl<GoRouter>()`.

### How it is wired

```
main()
  └── initCoreDependencies()
        └── registerLazySingleton<GoRouter>(() {
              final router = AppRouter.build();       // pure factory, no side effects
              NavigationService.router = router;      // explicit wiring
              return router;
            })

  FreshCheckApp.build()
    └── sl<GoRouter>()           GoRouter is instantiated HERE (first access, lazy)
          └── MaterialApp.router
```

`AppRouter.build()` is a **pure factory** — it returns a `GoRouter` and performs no side effects. `NavigationService` is wired explicitly by the caller in `injection.dart`.

### Key files

| File                      | Responsibility                                             |
|---------------------------|------------------------------------------------------------|
| `route_paths.dart`        | URL constants — `RoutePaths.scan`, `RoutePaths.scanResult` |
| `route_names.dart`        | Named route labels — `RouteNames.scan`, `RouteNames.login` |
| `route_guards.dart`       | `RouteGuard.authGuard` — plugged into `GoRouter.redirect`  |
| `navigation_service.dart` | Static helpers to navigate without `BuildContext`          |
| `app_router.dart`         | All `GoRoute` definitions + feature injection calls        |

> `app_router.dart` is **not exported** via `app_exports.dart`. It is internal wiring — feature screens never import it.

### Defined routes

| Path            | Name constant             | Notes                |
|-----------------|---------------------------|----------------------|
| `/`             | `RouteNames.splash`       | Initial route        |
| `/login`        | `RouteNames.login`        |                      |
| `/register`     | `RouteNames.register`     |                      |
| `/home`         | `RouteNames.home`         |                      |
| `/scan`         | `RouteNames.scan`         |                      |
| `/scan/result`  | `RouteNames.scanResult`   | Nested under `/scan` |
| `/history`      | `RouteNames.history`      |                      |
| `/profile`      | `RouteNames.profile`      |                      |
| `/settings`     | `RouteNames.settings`     |                      |
| `/subscription` | `RouteNames.subscription` |                      |

### Navigating from a widget

Always use `context.go` / `context.push` from go_router — never `Navigator.push`.

```dart
import 'package:go_router/go_router.dart';
import 'package:fresh_check/app/app_exports.dart'; // re-exports RoutePaths, RouteNames

// Replace current stack (no back button)
context.go(RoutePaths.home);

// Push on top (back button available)
context.push(RoutePaths.scan);

// Navigate by name (preferred — refactor-safe)
context.goNamed(RouteNames.login);
```

### Passing data to a screen

**Simple scalar data** — use path or query parameters:

```dart
// Navigate with a query param
context.go('${RoutePaths.profile}?userId=42');

// Read it on the receiving page
final userId = GoRouterState.of(context).uri.queryParameters['userId'];
```

**Rich objects (models, entities)** — use `extra`:

```dart
// Send
context.push(RoutePaths.scanResult, extra: scanResultEntity);

// Receive in the route builder
GoRoute(
  path: RoutePaths.scanResultSegment,
  name: RouteNames.scanResult,
  pageBuilder: (context, state) {
    registerScanDependencies();
    final result = state.extra as ScanResultEntity;
    return AppRouteTransitions.buildPage(
      context: context,
      state: state,
      child: ScanResultPage(result: result),
    );
  },
),
```

> **Note:** `extra` is lost on deep-link or app restart. For deep-link-safe data, use path/query params and reload the object from the repository by ID.

### Navigating from a BLoC (without BuildContext)

`NavigationService` holds a static reference to the `GoRouter` instance. Use it anywhere outside the widget tree:

```dart
import 'package:fresh_check/app/app_exports.dart'; // re-exports NavigationService

// Inside a BLoC, service, or use-case callback
NavigationService.go(RoutePaths.home);
NavigationService.goNamed(RouteNames.scanResult, extra: result);
NavigationService.pop();
```

### Adding a new route (step-by-step)

1. **Add the path constant** in `route_paths.dart`:
   ```dart
   static const String notifications = '/notifications';
   ```

2. **Add the name constant** in `route_names.dart`:
   ```dart
   static const String notifications = 'notifications';
   ```

3. **Register the route** in `app_router.dart` — call the feature injection and return the page:
   ```dart
   GoRoute(
     path: RoutePaths.notifications,
     name: RouteNames.notifications,
     pageBuilder: (context, state) {
       registerNotificationsDependencies(); // lazy, guarded
       return AppRouteTransitions.buildPage(
         context: context,
         state: state,
         child: const NotificationsPage(),
       );
     },
   ),
   ```

4. **Wire the feature injection** in `features/notifications/di/notifications_injection.dart` — uncomment the `isRegistered` guard and the registrations.

5. **Navigate** from anywhere:
   ```dart
   context.goNamed(RouteNames.notifications);
   // or from a BLoC:
   NavigationService.goNamed(RouteNames.notifications);
   ```

### Auth guard

`RouteGuard.authGuard` in `route_guards.dart` is plugged into `GoRouter.redirect`. It runs on every navigation event. Currently it allows all routes (dev skeleton).

To enable real auth protection, replace the placeholder inside `authGuard`:

```dart
// route_guards.dart — uncomment and wire when auth feature is ready
final bool isAuthenticated = sl<AuthRepository>().isAuthenticated;
final bool isPublicRoute =
    state.matchedLocation == RoutePaths.splash ||
    state.matchedLocation == RoutePaths.login ||
    state.matchedLocation == RoutePaths.register;
if (!isAuthenticated && !isPublicRoute) return RoutePaths.login;
```

---

## Page Transitions

All route animations are centralised in `lib/app/routes/app_route_transitions.dart`. Feature screens know nothing about animations — they are plain widgets.

### Available transition types

| `AppTransition` value | Visual behaviour                                      |
|-----------------------|-------------------------------------------------------|
| `slide` *(default)*   | Slides in from right on push; reverses on pop         |
| `fade`                | Fades in on push; fades out on pop                    |
| `scale`               | Scales up from 85 % + fade on push; reverses on pop   |
| `bottomToTop`         | Slides up from bottom on push; slides down on pop     |

### Usage in the router

```dart
// Default — slide at global duration (omit both optional arguments)
pageBuilder: (context, state) => AppRouteTransitions.buildPage(
  context: context,
  state: state,
  child: const LoginPage(),
),

// Custom animation type, global duration
pageBuilder: (context, state) => AppRouteTransitions.buildPage(
  context: context,
  state: state,
  child: const SplashPage(),
  transition: AppTransition.fade,
),

// Custom animation type AND custom duration for this route only
pageBuilder: (context, state) => AppRouteTransitions.buildPage(
  context: context,
  state: state,
  child: const ScanPage(),
  transition: AppTransition.fade,
  duration: const Duration(milliseconds: 200),
),
```

### Changing the global animation speed

Edit one constant in `app_route_transitions.dart`:

```dart
const Duration _kTransitionDuration = Duration(milliseconds: 300); // ← change this
```

All routes that do **not** pass an explicit `duration:` are immediately affected.

### Adding a new animation type

Edit only `app_route_transitions.dart` — the router never needs to change:

1. Add an entry to `AppTransition`:
   ```dart
   enum AppTransition { slide, fade, scale, bottomToTop, myNewAnim }
   ```
2. Write the static builder:
   ```dart
   static Widget _myNewAnim(
     BuildContext context,
     Animation<double> animation,
     Animation<double> secondaryAnimation,
     Widget child,
   ) { ... }
   ```
3. Add a branch to the switch in `buildPage`:
   ```dart
   AppTransition.myNewAnim => _myNewAnim,
   ```

Flutter automatically reverses every animation on pop — no extra logic needed.

---

## Error Handling

```
DataSource throws Exception
  → Repository catches → returns Left(Failure)
    → UseCase propagates Either<Failure, T>
      → BLoC fold → emits failure state
        → UI listener reacts (toast / dialog / navigate)
```

### Exceptions — data layer only

Defined in `core/error/exceptions.dart`. Thrown by datasources, caught by repositories. Never leave the data layer.

| Exception               | Thrown when                            |
|-------------------------|----------------------------------------|
| `ServerException`       | API returns 5xx or unexpected response |
| `UnauthorizedException` | API returns 401                        |
| `NetworkException`      | No internet / timeout                  |
| `CacheException`        | Local storage read/write fails         |

### Failures — domain layer + above

Defined in `core/error/failures.dart`. Returned by repositories via `Left(failure)`. Used by BLoC to determine what to emit or where to navigate.

```dart
sealed class Failure extends Equatable {
  const Failure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class ServerFailure       extends Failure { const ServerFailure(super.message); }
class NetworkFailure      extends Failure { const NetworkFailure() : super('No internet connection'); }
class CacheFailure        extends Failure { const CacheFailure(super.message); }
class UnauthorizedFailure extends Failure { const UnauthorizedFailure() : super('Session expired'); }
```

### BLoC handles failures with exhaustive switch

`sealed class` + `switch` = compiler warns when a new Failure type is added but not handled.

```dart
result.fold(
  (failure) {
    switch (failure) {
      case UnauthorizedFailure(): NavigationService.go(RoutePaths.login);
      case NetworkFailure():      emit(ScanState.failure(failure));
      case ServerFailure():       emit(ScanState.failure(failure));
      case CacheFailure():        emit(ScanState.failure(failure));
    }
  },
  (result) => emit(ScanState.success(result)),
);
```

Return types always use `Either<Failure, T>` from the `dartz` package.

---

## Code Generation

This project uses `freezed` and `json_serializable`. After adding or modifying annotated classes, always regenerate:

```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

For watch mode during active development:

```bash
fvm flutter pub run build_runner watch --delete-conflicting-outputs
```

Files that trigger generation:
- `@freezed` classes → generates `.freezed.dart`
- `@JsonSerializable()` classes → generates `.g.dart`

Never edit `.freezed.dart` or `.g.dart` files manually — they are overwritten on every build.

---

## Adding a New Feature

### 1. Create the directory tree

```
lib/features/my_feature/
├── di/
│   └── my_feature_injection.dart      # ← DI registration for this feature
├── data/
│   ├── datasources/
│   │   ├── my_feature_remote_datasource.dart
│   │   └── my_feature_local_datasource.dart
│   ├── models/
│   │   └── my_feature_model.dart      # @JsonSerializable, maps to domain entity
│   └── repositories/
│       └── my_feature_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── my_feature.dart            # Pure Dart, no external imports
│   ├── repositories/
│   │   └── my_feature_repository.dart # Abstract interface
│   └── usecases/
│       └── do_something_usecase.dart  # Extends UseCase<ReturnType, Params>
└── presentation/
    ├── bloc/
    │   ├── my_feature_bloc.dart
    │   ├── my_feature_event.dart
    │   └── my_feature_state.dart      # @freezed
    ├── screens/
    │   └── my_feature_screen.dart
    └── widgets/
```

### 2. Write the feature injection file

```dart
// features/my_feature/di/my_feature_injection.dart
import 'package:fresh_check/app/di/injection.dart';
import '...'; // feature-local imports only

void registerMyFeatureDependencies() {
  if (sl.isRegistered<MyFeatureBloc>()) return; // mandatory guard

  sl.registerLazySingleton<MyFeatureRemoteDataSource>(
    () => MyFeatureRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<MyFeatureRepository>(
    () => MyFeatureRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<DoSomethingUseCase>(() => DoSomethingUseCase(sl()));
  sl.registerFactory<MyFeatureBloc>(() => MyFeatureBloc(doSomething: sl()));
}
```

### 3. Add routes (3 files)

- `route_paths.dart` — add path constant
- `route_names.dart` — add name constant
- `app_router.dart` — add `GoRoute` entry, call `registerMyFeatureDependencies()` in `pageBuilder`, import the page

```dart
// app_router.dart
import 'package:fresh_check/features/my_feature/di/my_feature_injection.dart';
import 'package:fresh_check/features/my_feature/presentation/screens/my_feature_screen.dart';

GoRoute(
  path: RoutePaths.myFeature,
  name: RouteNames.myFeature,
  pageBuilder: (context, state) {
    registerMyFeatureDependencies();
    return AppRouteTransitions.buildPage(
      context: context,
      state: state,
      child: const MyFeaturePage(),
    );
  },
),
```

### 4. Run code generation

```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

### 5. Verify

```bash
fvm flutter analyze
```

Zero issues expected. Do not proceed if there are any errors.

---

## Key Packages

| Package                                 | Purpose                                   |
|-----------------------------------------|-------------------------------------------|
| `flutter_bloc`                          | State management                          |
| `go_router`                             | Declarative routing + deep links          |
| `get_it`                                | Dependency injection                      |
| `dartz`                                 | Functional types (`Either`, `Option`)     |
| `dio`                                   | HTTP client                               |
| `pretty_dio_logger`                     | Request/response logging in debug         |
| `freezed` + `freezed_annotation`        | Immutable models, sealed states           |
| `json_serializable` + `json_annotation` | JSON (de)serialization                    |
| `shared_preferences`                    | Simple key-value storage                  |
| `flutter_secure_storage`                | Encrypted storage (tokens)                |
| `connectivity_plus`                     | Network connectivity detection            |
| `permission_handler`                    | Camera, storage permissions               |
| `image_picker`                          | Camera capture                            |
| `firebase_core` + `firebase_messaging`  | Push notifications                        |
| `firebase_remote_config`                | Feature flags / remote config             |
| `flutter_local_notifications`           | Local notification display                |
| `cached_network_image`                  | Image loading + caching                   |
| `flutter_svg`                           | SVG asset rendering                       |
| `shimmer`                               | Loading skeleton UI                       |
| `pinput`                                | OTP input field                           |
| `intl`                                  | Date/number formatting, localization      |
| `carousel_slider`                       | Image carousels                           |
| `smooth_page_indicator`                 | Page indicator dots                       |
| `equatable`                             | Value equality for entities/events/states |

---

## Lint & Static Analysis

Strict linting is configured in `analysis_options.yaml`. Base: `package:flutter_lints/flutter.yaml`.
Verified clean on Dart 3.11.0 — `fvm flutter analyze` reports 0 issues.

**Run the analyzer:**
```bash
fvm flutter analyze
```

**Rule categories enforced:**

| Category            | Key Rules                                                                                              |
|---------------------|--------------------------------------------------------------------------------------------------------|
| Const / Performance | `prefer_const_constructors`, `prefer_const_literals_to_create_immutables`, `prefer_const_declarations` |
| Widget Efficiency   | `use_key_in_widget_constructors`, `sized_box_for_whitespace`, `avoid_unnecessary_containers`           |
| Memory Safety       | `cancel_subscriptions`, `close_sinks`, `avoid_slow_async_io`                                           |
| Type Safety         | `avoid_dynamic_calls`, `avoid_annotating_with_dynamic`                                                 |
| Async Correctness   | `unawaited_futures`, `discarded_futures`, `avoid_void_async`                                           |
| Style               | `prefer_single_quotes`, `always_use_package_imports`, `directives_ordering`, `avoid_print`             |
| Class Design        | `use_super_parameters`, `prefer_final_fields`, `prefer_final_locals`                                   |

**Promoted to errors (hard — not just warnings):**
`invalid_assignment`, `missing_return`, `dead_code`, `unused_import`, `missing_required_param`, `body_might_complete_normally`

**Excluded from analysis:**
`*.g.dart`, `*.freezed.dart`, `lib/generated/**`, `build/**` — never lint generated files.

**Suppression:**
```dart
// ignore: rule_name              ← single line
// ignore_for_file: rule_name     ← whole file
```

---

## Naming Conventions

| Item                | Convention                                                      | Example                     |
|---------------------|-----------------------------------------------------------------|-----------------------------|
| Files               | `snake_case.dart`                                               | `scan_result_screen.dart`   |
| Classes             | `PascalCase`                                                    | `ScanResultScreen`          |
| Variables / methods | `camelCase`                                                     | `fetchScanHistory()`        |
| Constants           | `camelCase`                                                     | `RoutePaths.scanResult`     |
| BLoC files          | `feature_bloc.dart`, `feature_event.dart`, `feature_state.dart` | `scan_bloc.dart`            |
| Model files         | `feature_model.dart`                                            | `scan_result_model.dart`    |
| Entity files        | `feature.dart` (no suffix)                                      | `scan_result.dart`          |
| UseCase files       | `verb_noun_usecase.dart`                                        | `analyse_food_usecase.dart` |
| Injection files     | `feature_injection.dart` in `features/<name>/di/`               | `auth_injection.dart`       |
| Private members     | `_camelCase`                                                    | `_controller`               |
| Generated files     | `*.freezed.dart`, `*.g.dart`                                    | auto-generated, do not edit |

---

## Known Issues / In Progress

### Splash screen does not navigate

The current splash screen (`_SplashPlaceholder` in `app_router.dart`) is a static `StatelessWidget` — it displays the app name and stays there indefinitely. It has no timer or auth check.

**Planned implementation:**
1. `SplashBloc` — on `SplashStarted` event: initializes SharedPreferences (async), then checks `flutter_secure_storage` for an auth token. (Firebase is already initialized in `main.dart`.)
2. `SplashPage` — `StatefulWidget` with a `BlocListener` that navigates to `/home` (authenticated) or `/login` (unauthenticated) once the BLoC emits.
3. `RouteGuard.authGuard` — currently allows all routes (dev skeleton); will be wired to `AuthRepository.isAuthenticated` when the auth feature is built.

### Core layer not yet built

The following files are defined in the architecture but not yet implemented:
- `lib/core/error/exceptions.dart`, `failures.dart`
- `lib/core/usecase/usecase.dart`
- `lib/core/constants/api_constants.dart`, `storage_keys.dart`
- `lib/core/network/api_client.dart`, `auth_interceptor.dart`, `connectivity_interceptor.dart`
- `lib/core/extensions/string_extensions.dart`, `context_extensions.dart`

### App theme not yet built

- `lib/app/theme/app_colors.dart`, `app_theme.dart` — export lines in `app_exports.dart` are commented until these files exist.

### AppBlocObserver not yet built

- `lib/app/bloc_observer.dart` — `AppBlocObserver extends BlocObserver` stub pending.
