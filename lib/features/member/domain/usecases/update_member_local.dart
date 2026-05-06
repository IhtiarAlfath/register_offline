import 'package:register_offline/core/error/failures.dart';
import 'package:register_offline/core/success/success.dart';
import 'package:register_offline/core/utils/either.dart';
import 'package:register_offline/features/member/domain/entities/member.dart';
import 'package:register_offline/features/member/domain/repositories/member_repositories.dart';

class UpdateMemberLocal {
  final MemberRepositories memberRepositories;
  const UpdateMemberLocal({required this.memberRepositories});

  Future<Either<Failure, Success>> call(MemberLocal member) async {
    return await memberRepositories.updateMemberLocal(member);
  }
}