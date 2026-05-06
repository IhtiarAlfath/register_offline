import 'package:register_offline/core/error/failures.dart';
import 'package:register_offline/core/success/success.dart';
import 'package:register_offline/core/utils/either.dart';
import 'package:register_offline/features/member/domain/entities/member.dart';
import 'package:register_offline/features/member/domain/repositories/member_repositories.dart';

class UploadMember {
  final MemberRepositories memberRepositories;
  const UploadMember({required this.memberRepositories});

  Future<Either<Failure, Success>> call(
      MemberLocal member, String token) async {
    return await memberRepositories.uploadMember(member, token);
  }
}
