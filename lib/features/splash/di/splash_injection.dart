import 'package:fresh_check/app/di/injection.dart';
import 'package:fresh_check/features/splash/splash_exports.dart';

void registerSplashDependencies() {
  if (sl.isRegistered<SplashBloc>()) return;
  sl.registerFactory<SplashBloc>(SplashBloc.new);
}
