import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fresh_check/features/auth/domain/entities/login_entity.dart';
import 'package:fresh_check/features/auth/domain/usecases/validate_login.dart';
import 'package:fresh_check/features/auth/presentation/bloc/login/login_event.dart';
import 'package:fresh_check/features/auth/presentation/bloc/login/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required ValidateLogin validateLogin})
      : _validateLogin = validateLogin,
        super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  final ValidateLogin _validateLogin;

  void _onEmailChanged(
    LoginEmailChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(
      email: event.email,
      toastMessage: null,
    ));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(
      password: event.password,
      toastMessage: null,
    ));
  }

  void _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) {
    final entity = LoginEntity(
      email: state.email,
      password: state.password,
    );

    final errors = _validateLogin(entity);

    if (errors.isNotEmpty) {
      emit(state.copyWith(toastMessage: null));
      emit(state.copyWith(
        isSubmitted: true,
        toastMessage: errors.join('\n'),
      ));
      return;
    }

    emit(state.copyWith(
      isSubmitted: true,
      toastMessage: null,
    ));

    // TODO: Call login API use case
  }
}
