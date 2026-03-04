// History feature — dependency registration.
//
// Called from app_router.dart pageBuilder for /history route.
// Registration order: datasource → repository → use cases → bloc
// import 'package:fresh_check/app/di/injection.dart';
// import 'package:fresh_check/features/history/data/datasources/history_local_datasource.dart';
// import 'package:fresh_check/features/history/data/datasources/history_remote_datasource.dart';
// import 'package:fresh_check/features/history/data/repositories/history_repository_impl.dart';
// import 'package:fresh_check/features/history/domain/repositories/history_repository.dart';
// import 'package:fresh_check/features/history/domain/usecases/get_scan_history_usecase.dart';
// import 'package:fresh_check/features/history/domain/usecases/delete_scan_record_usecase.dart';
// import 'package:fresh_check/features/history/presentation/bloc/history_bloc.dart';

void registerHistoryDependencies() {
  // if (sl.isRegistered<HistoryBloc>()) return;

  // ── Data layer ──────────────────────────────────────────────────────────────
  // sl.registerLazySingleton<HistoryRemoteDataSource>(
  //   () => HistoryRemoteDataSourceImpl(apiClient: sl()),
  // );
  // sl.registerLazySingleton<HistoryLocalDataSource>(
  //   () => HistoryLocalDataSourceImpl(preferences: sl()),
  // );

  // ── Domain layer ────────────────────────────────────────────────────────────
  // sl.registerLazySingleton<HistoryRepository>(
  //   () => HistoryRepositoryImpl(
  //     remoteDataSource: sl(),
  //     localDataSource: sl(),
  //   ),
  // );
  // sl.registerLazySingleton<GetScanHistoryUseCase>(() => GetScanHistoryUseCase(sl()));
  // sl.registerLazySingleton<DeleteScanRecordUseCase>(() => DeleteScanRecordUseCase(sl()));

  // ── Presentation layer ──────────────────────────────────────────────────────
  // sl.registerFactory<HistoryBloc>(
  //   () => HistoryBloc(
  //     getScanHistory: sl(),
  //     deleteScanRecord: sl(),
  //   ),
  // );
}
