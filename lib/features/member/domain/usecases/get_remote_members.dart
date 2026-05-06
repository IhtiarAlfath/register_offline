import 'package:register_offline/core/error/failures.dart';
import 'package:register_offline/core/utils/either.dart';
import 'package:register_offline/features/member/domain/entities/member.dart';
import 'package:register_offline/features/member/domain/repositories/member_repositories.dart';

class GetRemoteMembers {
  final MemberRepositories memberRepositories;
  const GetRemoteMembers({required this.memberRepositories});

  Future<Either<Failure, List<MemberRemote>>> call(String token) async {
    return await memberRepositories.getRemoteMembers(token);
  }
}