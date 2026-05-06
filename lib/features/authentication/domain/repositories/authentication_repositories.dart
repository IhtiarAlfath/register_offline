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

  Future<Either<Failure, Success>> cacheDataLoginParameter(
      DataLoginParameter dataLoginParameter);
  Future<Either<Failure, DataLoginParameter>> getCacheDataLoginParameter();
  Future<Either<Failure, Success>> deleteCacheDataLoginParameter();

  Future<Either<Failure, Success>> cacheRememberMe(
      DataLoginParameter dataLoginParameter);
  Future<Either<Failure, DataLoginParameter?>> getCacheRememberMe();
  Future<Either<Failure, Success>> deleteCacheRememberMe();
}
