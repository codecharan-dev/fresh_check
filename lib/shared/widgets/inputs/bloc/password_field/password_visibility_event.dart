import 'package:freezed_annotation/freezed_annotation.dart';

part 'password_visibility_event.freezed.dart';

@freezed
sealed class PasswordVisibilityEvent with _$PasswordVisibilityEvent {
  const factory PasswordVisibilityEvent.toggled() = PasswordVisibilityToggled;
}
