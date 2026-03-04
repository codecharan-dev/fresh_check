// Settings feature — dependency registration.
//
// Called from app_router.dart pageBuilder for /settings route.
// Registration order: datasource → repository → use cases → bloc
// import 'package:fresh_check/app/di/injection.dart';
// import 'package:fresh_check/features/settings/data/datasources/settings_local_datasource.dart';
// import 'package:fresh_check/features/settings/data/repositories/settings_repository_impl.dart';
// import 'package:fresh_check/features/settings/domain/repositories/settings_repository.dart';
// import 'package:fresh_check/features/settings/domain/usecases/get_settings_usecase.dart';
// import 'package:fresh_check/features/settings/domain/usecases/update_settings_usecase.dart';
// import 'package:fresh_check/features/settings/presentation/bloc/settings_bloc.dart';

void registerSettingsDependencies() {
  // if (sl.isRegistered<SettingsBloc>()) return;

  // ── Data layer ──────────────────────────────────────────────────────────────
  // Settings are typically local-only (SharedPreferences / SecureStorage).
  // sl.registerLazySingleton<SettingsLocalDataSource>(
  //   () => SettingsLocalDataSourceImpl(preferences: sl()),
  // );

  // ── Domain layer ────────────────────────────────────────────────────────────
  // sl.registerLazySingleton<SettingsRepository>(
  //   () => SettingsRepositoryImpl(localDataSource: sl()),
  // );
  // sl.registerLazySingleton<GetSettingsUseCase>(() => GetSettingsUseCase(sl()));
  // sl.registerLazySingleton<UpdateSettingsUseCase>(() => UpdateSettingsUseCase(sl()));

  // ── Presentation layer ──────────────────────────────────────────────────────
  // sl.registerFactory<SettingsBloc>(
  //   () => SettingsBloc(
  //     getSettings: sl(),
  //     updateSettings: sl(),
  //   ),
  // );
}
