import 'package:fresh_check/features/auth/domain/entities/login_entity.dart';

class ValidateLogin {
  const ValidateLogin();

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final _passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]{8,}$',
  );

  List<String> call(LoginEntity entity) {
    return [
      ?_validateEmail(entity.email),
      ?_validatePassword(entity.password),
    ];
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) return 'Email is required';
    if (!_emailRegex.hasMatch(email)) return 'Enter a valid email address';
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) return 'Password is required';
    if (!_passwordRegex.hasMatch(password)) {
      return 'Must be 8+ chars with uppercase, lowercase, number & special character';
    }
    return null;
  }
}
