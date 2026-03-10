import 'package:dartz/dartz.dart';
import 'package:fresh_check/core/core_exports.dart';
import 'package:fresh_check/features/auth/domain/entities/login_entity.dart';

abstract class LoginRepository {
  Future<Either<Failure, LoginEntity>> login(LoginEntity entity);
}
