import 'package:register_offline/core/error/failures.dart';
import 'package:register_offline/core/utils/either.dart';
import 'package:register_offline/features/member/domain/entities/member.dart';
import 'package:register_offline/features/member/domain/repositories/member_repositories.dart';

class GetDraftMembers {
  final MemberRepositories memberRepositories;
  const GetDraftMembers({required this.memberRepositories});

  Future<Either<Failure, List<MemberLocal>>> call() async {
    return await memberRepositories.getDraftMembers();
  }
}