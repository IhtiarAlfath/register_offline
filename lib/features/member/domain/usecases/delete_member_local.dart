import 'package:register_offline/core/error/failures.dart';
import 'package:register_offline/core/success/success.dart';
import 'package:register_offline/core/utils/either.dart';
import 'package:register_offline/features/member/domain/repositories/member_repositories.dart';

class DeleteMemberLocal {
  final MemberRepositories memberRepositories;
  const DeleteMemberLocal({required this.memberRepositories});

  Future<Either<Failure, Success>> call(int id) async {
    return await memberRepositories.deleteMemberLocal(id);
  }
}