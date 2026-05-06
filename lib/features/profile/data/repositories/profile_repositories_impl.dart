import 'package:register_offline/core/error/failures.dart';
import 'package:register_offline/core/services/network_services.dart';
import 'package:register_offline/core/utils/either.dart';
import 'package:register_offline/features/profile/data/datasource/profile_datasource_remote.dart';
import 'package:register_offline/features/profile/domain/entities/user_profile.dart';
import 'package:register_offline/features/profile/domain/repositories/profile_repositories.dart';

class ProfileRepositoriesImpl implements ProfileRepositories {
  final ProfileDatasourceRemoteImpl profileDatasourceRemote;
  final NetworkServices networkServices;

  ProfileRepositoriesImpl({
    required this.profileDatasourceRemote,
    required this.networkServices,
  });

  @override
  Future<Either<Failure, UserProfile>> getProfile(String token) async {
    try {
      bool isConnected = await networkServices.isConnected();
      if (!isConnected) {
        return left(const ConnectionFailure(message: 'No Internet Connection'));
      }
      final profile = await profileDatasourceRemote.getProfile(token);
      return right(profile);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    } catch (e) {
      return left(GeneralFailure(message: e.toString()));
    }
  }
}

class GetProfile {
  final ProfileRepositories profileRepositories;
  const GetProfile({required this.profileRepositories});

  Future<Either<Failure, UserProfile>> call(String token) async {
    return await profileRepositories.getProfile(token);
  }
}
