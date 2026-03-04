// Subscription feature — dependency registration.
//
// Called from app_router.dart pageBuilder for /subscription route.
// Registration order: datasource → repository → use cases → bloc
// import 'package:fresh_check/app/di/injection.dart';
// import 'package:fresh_check/features/subscription/data/datasources/subscription_remote_datasource.dart';
// import 'package:fresh_check/features/subscription/data/repositories/subscription_repository_impl.dart';
// import 'package:fresh_check/features/subscription/domain/repositories/subscription_repository.dart';
// import 'package:fresh_check/features/subscription/domain/usecases/get_subscription_status_usecase.dart';
// import 'package:fresh_check/features/subscription/domain/usecases/purchase_subscription_usecase.dart';
// import 'package:fresh_check/features/subscription/presentation/bloc/subscription_bloc.dart';

void registerSubscriptionDependencies() {
  // if (sl.isRegistered<SubscriptionBloc>()) return;

  // ── Data layer ──────────────────────────────────────────────────────────────
  // sl.registerLazySingleton<SubscriptionRemoteDataSource>(
  //   () => SubscriptionRemoteDataSourceImpl(apiClient: sl()),
  // );

  // ── Domain layer ────────────────────────────────────────────────────────────
  // sl.registerLazySingleton<SubscriptionRepository>(
  //   () => SubscriptionRepositoryImpl(remoteDataSource: sl()),
  // );
  // sl.registerLazySingleton<GetSubscriptionStatusUseCase>(
  //   () => GetSubscriptionStatusUseCase(sl()),
  // );
  // sl.registerLazySingleton<PurchaseSubscriptionUseCase>(
  //   () => PurchaseSubscriptionUseCase(sl()),
  // );

  // ── Presentation layer ──────────────────────────────────────────────────────
  // sl.registerFactory<SubscriptionBloc>(
  //   () => SubscriptionBloc(
  //     getSubscriptionStatus: sl(),
  //     purchaseSubscription: sl(),
  //   ),
  // );
}
