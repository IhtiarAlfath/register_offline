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

}
