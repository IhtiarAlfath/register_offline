import 'package:register_offline/core/error/failures.dart';
import 'package:register_offline/core/success/success.dart';
import 'package:register_offline/core/utils/either.dart';
import 'package:register_offline/features/authentication/domain/entities/data_login.dart';

abstract class AuthenticationRepositories {
  Future<Either<Failure, DataLogin>> login(
      DataLoginParameter dataLoginParameter);

  Future<Either<Failure, Success>> cacheDataLogin(DataLogin dataLogin);
  Future<Either<Failure, DataLogin>> getDataLogin();
  Future<Either<Failure, Success>> logout();

}
