import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fresh_check/features/splash/presentation/bloc/splash_event.dart';
import 'package:fresh_check/features/splash/presentation/bloc/splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(const SplashState.initial()) {
    on<SplashStarted>(_onStarted);
  }

  Future<void> _onStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    emit(const SplashState.loaded());
    await Future.delayed(const Duration(seconds: 2));
    emit(const SplashState.completed());
  }
}
