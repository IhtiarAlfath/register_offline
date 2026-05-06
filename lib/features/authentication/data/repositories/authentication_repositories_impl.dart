import 'package:register_offline/core/error/failures.dart';
import 'package:register_offline/core/services/network_services.dart';
import 'package:register_offline/core/success/success.dart';
import 'package:register_offline/core/utils/either.dart';
import 'package:register_offline/core/utils/logger.dart';
import 'package:register_offline/features/authentication/data/datasource/authentication_datasource_local.dart';
import 'package:register_offline/features/authentication/data/datasource/authentication_datasource_remote.dart';
import 'package:register_offline/features/authentication/domain/entities/data_login.dart';
import 'package:register_offline/features/authentication/domain/repositories/authentication_repositories.dart';

class AuthenticationRepositoriesImpl implements AuthenticationRepositories {
  final AuthenticationDatasourceRemote authenticationDatasourceRemote;
  final AuthenticationDatasourceLocal authenticationDatasourceLocal;
  final NetworkServices networkServices;

  AuthenticationRepositoriesImpl({
    required this.authenticationDatasourceRemote,
    required this.authenticationDatasourceLocal,
    required this.networkServices,
  });

  @override
  Future<Either<Failure, DataLogin>> login(
      DataLoginParameter dataLoginParameter) async {
    try {
      bool isConnected = await networkServices.isConnected();
      if (!isConnected) {
        return left(const ConnectionFailure(message: 'No Internet Connection'));
      }

      final dataLoginModel =
          await authenticationDatasourceRemote.login(dataLoginParameter);

      await authenticationDatasourceLocal.cacheDataLogin(dataLoginModel);
      return right(dataLoginModel);
    } on ServerException catch (e) {
      logInfo('ServerFailure: ${e.message}');
      return left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      logInfo('CacheFailure: ${e.message}');
      return left(CacheFailure(message: e.message));
    } catch (e) {
      logInfo('GeneralFailure on login: $e');
      return left(const GeneralFailure(message: 'Cannot login'));
    }
  }

  @override
  Future<Either<Failure, Success>> cacheDataLogin(DataLogin dataLogin) async {
    try {
      final result =
          await authenticationDatasourceLocal.cacheDataLogin(dataLogin);
      return right(result);
    } on CacheException catch (e) {
      return left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, DataLogin>> getDataLogin() async {
    try {
      final result =
          await authenticationDatasourceLocal.getLastDataLogin();
      return right(result);
    } on CacheException catch (e) {
      return left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Success>> logout() async {
    try {
      final result = await authenticationDatasourceLocal.deleteDataLogin();
      return right(result);
    } on CacheException catch (e) {
      return left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Success>> cacheDataLoginParameter(
      DataLoginParameter dataLoginParameter) async {
    try {
      final result = await authenticationDatasourceLocal
          .cacheDataLoginParameter(dataLoginParameter);
      return right(result);
    } on CacheException catch (e) {
      return left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, DataLoginParameter>> getCacheDataLoginParameter() async {
    try {
      final result =
          await authenticationDatasourceLocal.getLastDataLoginParameter();
      if (result == null) {
        return left(const CacheFailure(message: 'No cached login param'));
      }
      return right(result);
    } on CacheException catch (e) {
      return left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Success>> deleteCacheDataLoginParameter() async {
    try {
      final result = await authenticationDatasourceLocal
          .deleteCacheDataLoginParameter();
      return right(result);
    } on CacheException catch (e) {
      return left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Success>> cacheRememberMe(
      DataLoginParameter dataLoginParameter) async {
    try {
      final result = await authenticationDatasourceLocal
          .cacheRememberMe(dataLoginParameter);
      return right(result);
    } on CacheException catch (e) {
      return left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, DataLoginParameter?>> getCacheRememberMe() async {
    try {
      final result = await authenticationDatasourceLocal.getRememberMe();
      return right(result);
    } on CacheException catch (e) {
      return left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Success>> deleteCacheRememberMe() async {
    try {
      final result =
          await authenticationDatasourceLocal.deleteCacheRememberMe();
      return right(result);
    } on CacheException catch (e) {
      return left(CacheFailure(message: e.message));
    }
  }
}
