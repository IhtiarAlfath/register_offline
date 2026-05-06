import 'package:register_offline/core/error/failures.dart';
import 'package:register_offline/core/utils/either.dart';
import 'package:register_offline/features/authentication/domain/entities/data_login.dart';
import 'package:register_offline/features/authentication/domain/repositories/authentication_repositories.dart';

class Login {
  final AuthenticationRepositories authenticationRepositories;

  const Login({required this.authenticationRepositories});

  Future<Either<Failure, DataLogin>> call(
      DataLoginParameter dataLoginParameter) async {
    return await authenticationRepositories.login(dataLoginParameter);
  }
}
