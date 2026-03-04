// Auth feature — dependency registration.
//
// Called from app_router.dart pageBuilder for /login and /register routes.
// Guarded by isRegistered — safe to call on every navigation, registers once.
//
// Registration order (uncomment from bottom of stack up as files are created):
//   datasource → repository → use cases → bloc
//
// When wiring real dependencies, uncomment the imports and registrations below.
// Do not add any other file imports here — this file must only depend on:
//   - injection.dart (for sl)
//   - auth feature files (datasources, repositories, use cases, bloc)
// import 'package:fresh_check/app/di/injection.dart';
// import 'package:fresh_check/features/auth/data/datasources/auth_local_datasource.dart';
// import 'package:fresh_check/features/auth/data/datasources/auth_remote_datasource.dart';
// import 'package:fresh_check/features/auth/data/repositories/auth_repository_impl.dart';
// import 'package:fresh_check/features/auth/domain/repositories/auth_repository.dart';
// import 'package:fresh_check/features/auth/domain/usecases/login_usecase.dart';
// import 'package:fresh_check/features/auth/domain/usecases/logout_usecase.dart';
// import 'package:fresh_check/features/auth/domain/usecases/refresh_token_usecase.dart';
// import 'package:fresh_check/features/auth/presentation/bloc/auth_bloc.dart';

void registerAuthDependencies() {
  // Guard: isRegistered on the BLoC factory covers all registrations below it.
  // If AuthBloc factory is registered, datasource/repository/usecases are too.
  // if (sl.isRegistered<AuthBloc>()) return;

  // ── Data layer ──────────────────────────────────────────────────────────────
  // sl.registerLazySingleton<AuthRemoteDataSource>(
  //   () => AuthRemoteDataSourceImpl(apiClient: sl()),
  // );
  // sl.registerLazySingleton<AuthLocalDataSource>(
  //   () => AuthLocalDataSourceImpl(secureStorage: sl()),
  // );

  // ── Domain layer ────────────────────────────────────────────────────────────
  // sl.registerLazySingleton<AuthRepository>(
  //   () => AuthRepositoryImpl(
  //     remoteDataSource: sl(),
  //     localDataSource: sl(),
  //   ),
  // );
  // sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));
  // sl.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(sl()));
  // sl.registerLazySingleton<RefreshTokenUseCase>(() => RefreshTokenUseCase(sl()));

  // ── Presentation layer ──────────────────────────────────────────────────────
  // registerFactory: new AuthBloc instance per screen mount.
  // Repositories and use cases above are lazy singletons — shared, not recreated.
  // sl.registerFactory<AuthBloc>(
  //   () => AuthBloc(
  //     loginUseCase: sl(),
  //     logoutUseCase: sl(),
  //     refreshTokenUseCase: sl(),
  //   ),
  // );
}
