import 'package:register_offline/core/error/failures.dart';
import 'package:register_offline/core/success/success.dart';
import 'package:register_offline/core/utils/either.dart';
import 'package:register_offline/features/authentication/domain/entities/data_login.dart';
import 'package:register_offline/features/authentication/domain/repositories/authentication_repositories.dart';

class CacheDataLogin {
  final AuthenticationRepositories authenticationRepositories;

  const CacheDataLogin({required this.authenticationRepositories});

  Future<Either<Failure, Success>> call(DataLogin dataLogin) async {
    return await authenticationRepositories.cacheDataLogin(dataLogin);
  }
}
