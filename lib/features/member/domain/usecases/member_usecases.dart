import 'package:register_offline/core/error/failures.dart';
import 'package:register_offline/core/success/success.dart';
import 'package:register_offline/core/utils/either.dart';
import 'package:register_offline/features/member/domain/entities/member.dart';
import 'package:register_offline/features/member/domain/repositories/member_repositories.dart';

class SaveMemberLocal {
  final MemberRepositories memberRepositories;
  const SaveMemberLocal({required this.memberRepositories});

  Future<Either<Failure, Success>> call(MemberLocal member) async {
    return await memberRepositories.saveMemberLocal(member);
  }
}

class UpdateMemberLocal {
  final MemberRepositories memberRepositories;
  const UpdateMemberLocal({required this.memberRepositories});

  Future<Either<Failure, Success>> call(MemberLocal member) async {
    return await memberRepositories.updateMemberLocal(member);
  }
}

class GetDraftMembers {
  final MemberRepositories memberRepositories;
  const GetDraftMembers({required this.memberRepositories});

  Future<Either<Failure, List<MemberLocal>>> call() async {
    return await memberRepositories.getDraftMembers();
  }
}

class UploadMember {
  final MemberRepositories memberRepositories;
  const UploadMember({required this.memberRepositories});

  Future<Either<Failure, Success>> call(
      MemberLocal member, String token) async {
    return await memberRepositories.uploadMember(member, token);
  }
}

class GetRemoteMembers {
  final MemberRepositories memberRepositories;
  const GetRemoteMembers({required this.memberRepositories});

  Future<Either<Failure, List<MemberRemote>>> call(String token) async {
    return await memberRepositories.getRemoteMembers(token);
  }
}

class SyncAllDrafts {
  final MemberRepositories memberRepositories;
  const SyncAllDrafts({required this.memberRepositories});

  Future<Either<Failure, Success>> call(String token) async {
    return await memberRepositories.syncAllDrafts(token);
  }
}

class DeleteMemberLocal {
  final MemberRepositories memberRepositories;
  const DeleteMemberLocal({required this.memberRepositories});

  Future<Either<Failure, Success>> call(int id) async {
    return await memberRepositories.deleteMemberLocal(id);
  }
}
