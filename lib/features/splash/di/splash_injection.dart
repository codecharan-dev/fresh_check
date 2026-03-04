import 'package:fresh_check/app/di/injection.dart';
import 'package:fresh_check/features/splash/presentation/bloc/splash_bloc.dart';

void registerSplashDependencies() {
  if (sl.isRegistered<SplashBloc>()) return;
  sl.registerFactory<SplashBloc>(SplashBloc.new);
}
