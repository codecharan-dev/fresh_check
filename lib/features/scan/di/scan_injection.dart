// Scan feature — dependency registration.
//
// Called from app_router.dart pageBuilder for /scan and /scan/result routes.
// The nested result route calls this too — the isRegistered guard ensures
// no duplicate work on the second call.
//
// Registration order: datasource → repository → use cases → bloc
// import 'package:fresh_check/app/di/injection.dart';
// import 'package:fresh_check/features/scan/data/datasources/scan_remote_datasource.dart';
// import 'package:fresh_check/features/scan/data/repositories/scan_repository_impl.dart';
// import 'package:fresh_check/features/scan/domain/repositories/scan_repository.dart';
// import 'package:fresh_check/features/scan/domain/usecases/analyse_food_usecase.dart';
// import 'package:fresh_check/features/scan/presentation/bloc/scan_bloc.dart';

void registerScanDependencies() {
  // if (sl.isRegistered<ScanBloc>()) return;

  // ── Data layer ──────────────────────────────────────────────────────────────
  // sl.registerLazySingleton<ScanRemoteDataSource>(
  //   () => ScanRemoteDataSourceImpl(apiClient: sl()),
  // );

  // ── Domain layer ────────────────────────────────────────────────────────────
  // sl.registerLazySingleton<ScanRepository>(
  //   () => ScanRepositoryImpl(remoteDataSource: sl()),
  // );
  // sl.registerLazySingleton<AnalyseFoodUseCase>(() => AnalyseFoodUseCase(sl()));

  // ── Presentation layer ──────────────────────────────────────────────────────
  // sl.registerFactory<ScanBloc>(
  //   () => ScanBloc(analyseFood: sl()),
  // );
}
