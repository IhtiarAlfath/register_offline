import 'package:register_offline/core/error/failures.dart';
import 'package:register_offline/core/success/success.dart';
import 'package:register_offline/core/utils/either.dart';
import 'package:register_offline/features/member/domain/repositories/member_repositories.dart';

class SyncAllDrafts {
  final MemberRepositories memberRepositories;
  const SyncAllDrafts({required this.memberRepositories});

  Future<Either<Failure, Success>> call(String token) async {
    return await memberRepositories.syncAllDrafts(token);
  }
}