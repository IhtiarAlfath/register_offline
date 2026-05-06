import 'package:register_offline/core/error/failures.dart';
import 'package:register_offline/core/utils/either.dart';
import 'package:register_offline/features/profile/domain/entities/user_profile.dart';

abstract class ProfileRepositories {
  Future<Either<Failure, UserProfile>> getProfile(String token);
}
