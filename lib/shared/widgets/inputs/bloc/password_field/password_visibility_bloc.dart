import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fresh_check/shared/widgets/inputs/bloc/password_field/password_visibility_event.dart';
import 'package:fresh_check/shared/widgets/inputs/bloc/password_field/password_visibility_state.dart';

class PasswordVisibilityBloc
    extends Bloc<PasswordVisibilityEvent, PasswordVisibilityState> {
  PasswordVisibilityBloc()
      : super(const PasswordVisibilityState.obscured()) {
    on<PasswordVisibilityToggled>(_onToggled);
  }

  void _onToggled(
    PasswordVisibilityToggled event,
    Emitter<PasswordVisibilityState> emit,
  ) {
    emit(
      state is PasswordObscured
          ? const PasswordVisibilityState.visible()
          : const PasswordVisibilityState.obscured(),
    );
  }
}
