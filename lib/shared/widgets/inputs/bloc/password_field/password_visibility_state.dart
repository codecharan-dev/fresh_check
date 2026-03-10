import 'package:freezed_annotation/freezed_annotation.dart';

part 'password_visibility_state.freezed.dart';

@freezed
sealed class PasswordVisibilityState with _$PasswordVisibilityState {
  const factory PasswordVisibilityState.obscured() = PasswordObscured;
  const factory PasswordVisibilityState.visible() = PasswordVisible;
}
