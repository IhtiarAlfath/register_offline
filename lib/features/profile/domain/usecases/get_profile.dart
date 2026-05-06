import 'package:register_offline/core/error/failures.dart';
import 'package:register_offline/core/utils/either.dart';
import 'package:register_offline/features/profile/domain/entities/user_profile.dart';
import 'package:register_offline/features/profile/domain/repositories/profile_repositories.dart';

class GetProfileUsecase {
  final ProfileRepositories profileRepositories;

  const GetProfileUsecase({required this.profileRepositories});

  Future<Either<Failure, UserProfile>> call(String token) async {
    return await profileRepositories.getProfile(token);
  }
}
