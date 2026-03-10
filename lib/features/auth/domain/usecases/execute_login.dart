import 'package:dartz/dartz.dart';
import 'package:fresh_check/core/core_exports.dart';
import 'package:fresh_check/core/error/failures/failures.dart';
import 'package:fresh_check/features/auth/domain/entities/login_entity.dart';
import 'package:fresh_check/features/auth/domain/repositories/login_repository.dart';

class ExecuteLogin {
  const ExecuteLogin(this._repository);

  final LoginRepository _repository;

  Future<Either<Failure, LoginEntity>> call(LoginEntity entity) {
    return _repository.login(entity);
  }
}
