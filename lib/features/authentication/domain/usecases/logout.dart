import 'package:register_offline/core/error/failures.dart';
import 'package:register_offline/core/success/success.dart';
import 'package:register_offline/core/utils/either.dart';
import 'package:register_offline/features/authentication/domain/repositories/authentication_repositories.dart';

class Logout {
  final AuthenticationRepositories authenticationRepositories;

  const Logout({required this.authenticationRepositories});

  Future<Either<Failure, Success>> call() async {
    return await authenticationRepositories.logout();
  }
}
