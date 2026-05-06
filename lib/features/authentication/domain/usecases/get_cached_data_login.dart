import 'package:register_offline/core/error/failures.dart';
import 'package:register_offline/core/utils/either.dart';
import 'package:register_offline/features/authentication/domain/entities/data_login.dart';
import 'package:register_offline/features/authentication/domain/repositories/authentication_repositories.dart';

class GetCachedDataLogin {
  final AuthenticationRepositories authenticationRepositories;

  const GetCachedDataLogin({required this.authenticationRepositories});

  Future<Either<Failure, DataLogin>> call() async {
    return await authenticationRepositories.getDataLogin();
  }
}
