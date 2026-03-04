// Profile feature — dependency registration.
//
// Called from app_router.dart pageBuilder for /profile route.
// Registration order: datasource → repository → use cases → bloc
// import 'package:fresh_check/app/di/injection.dart';
// import 'package:fresh_check/features/profile/data/datasources/profile_remote_datasource.dart';
// import 'package:fresh_check/features/profile/data/repositories/profile_repository_impl.dart';
// import 'package:fresh_check/features/profile/domain/repositories/profile_repository.dart';
// import 'package:fresh_check/features/profile/domain/usecases/get_profile_usecase.dart';
// import 'package:fresh_check/features/profile/domain/usecases/update_profile_usecase.dart';
// import 'package:fresh_check/features/profile/presentation/bloc/profile_bloc.dart';

void registerProfileDependencies() {
  // if (sl.isRegistered<ProfileBloc>()) return;

  // ── Data layer ──────────────────────────────────────────────────────────────
  // sl.registerLazySingleton<ProfileRemoteDataSource>(
  //   () => ProfileRemoteDataSourceImpl(apiClient: sl()),
  // );

  // ── Domain layer ────────────────────────────────────────────────────────────
  // sl.registerLazySingleton<ProfileRepository>(
  //   () => ProfileRepositoryImpl(remoteDataSource: sl()),
  // );
  // sl.registerLazySingleton<GetProfileUseCase>(() => GetProfileUseCase(sl()));
  // sl.registerLazySingleton<UpdateProfileUseCase>(() => UpdateProfileUseCase(sl()));

  // ── Presentation layer ──────────────────────────────────────────────────────
  // sl.registerFactory<ProfileBloc>(
  //   () => ProfileBloc(
  //     getProfile: sl(),
  //     updateProfile: sl(),
  //   ),
  // );
}
