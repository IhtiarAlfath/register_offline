import 'package:register_offline/core/error/failures.dart';
import 'package:register_offline/core/success/success.dart';
import 'package:register_offline/core/utils/either.dart';
import 'package:register_offline/features/member/domain/entities/member.dart';

abstract class MemberRepositories {
  Future<Either<Failure, Success>> saveMemberLocal(MemberLocal member);
  Future<Either<Failure, Success>> updateMemberLocal(MemberLocal member);
  Future<Either<Failure, List<MemberLocal>>> getDraftMembers();
  Future<Either<Failure, Success>> deleteMemberLocal(int id);

  Future<Either<Failure, Success>> uploadMember(
      MemberLocal member, String token);
  Future<Either<Failure, List<MemberRemote>>> getRemoteMembers(String token);

  Future<Either<Failure, Success>> syncAllDrafts(String token);
}
