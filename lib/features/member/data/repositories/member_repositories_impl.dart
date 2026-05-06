import 'package:register_offline/core/error/failures.dart';
import 'package:register_offline/core/services/network_services.dart';
import 'package:register_offline/core/success/success.dart';
import 'package:register_offline/core/utils/either.dart';
import 'package:register_offline/core/utils/logger.dart';
import 'package:register_offline/features/member/data/datasource/member_datasource_local.dart';
import 'package:register_offline/features/member/data/datasource/member_datasource_remote.dart';
import 'package:register_offline/features/member/domain/entities/member.dart';
import 'package:register_offline/features/member/domain/repositories/member_repositories.dart';

class MemberRepositoriesImpl implements MemberRepositories {
  final MemberDatasourceLocal memberDatasourceLocal;
  final MemberDatasourceRemote memberDatasourceRemote;
  final NetworkServices networkServices;

  MemberRepositoriesImpl({
    required this.memberDatasourceLocal,
    required this.memberDatasourceRemote,
    required this.networkServices,
  });

  @override
  Future<Either<Failure, Success>> saveMemberLocal(MemberLocal member) async {
    try {
      final result = await memberDatasourceLocal.saveMember(member);
      return right(result);
    } on CacheException catch (e) {
      return left(CacheFailure(message: e.message));
    } catch (e) {
      return left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Success>> updateMemberLocal(MemberLocal member) async {
    try {
      final result = await memberDatasourceLocal.updateMember(member);
      return right(result);
    } on CacheException catch (e) {
      return left(CacheFailure(message: e.message));
    } catch (e) {
      return left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MemberLocal>>> getDraftMembers() async {
    try {
      final models = await memberDatasourceLocal.getDraftMembers();
      return right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Success>> deleteMemberLocal(int id) async {
    try {
      final result = await memberDatasourceLocal.deleteMember(id);
      return right(result);
    } on CacheException catch (e) {
      return left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Success>> uploadMember(
    MemberLocal member,
    String token,
  ) async {
    try {
      bool isConnected = await networkServices.isConnected();
      if (!isConnected) {
        return left(const ConnectionFailure(message: 'No Internet Connection'));
      }

      await memberDatasourceRemote.uploadMember(member, token);

      if (member.id != null) {
        await memberDatasourceLocal.updateSyncStatus(
          member.id!,
          SyncStatus.synced,
        );
      }

      return right(GeneralSuccess(message: 'Member berhasil diupload'));
    } on ServerException catch (e) {
      logInfo('Upload server failure: ${e.message}');
      return left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return left(CacheFailure(message: e.message));
    } catch (e) {
      return left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MemberRemote>>> getRemoteMembers(
    String token,
  ) async {
    try {
      bool isConnected = await networkServices.isConnected();
      if (!isConnected) {
        return left(const ConnectionFailure(message: 'No Internet Connection'));
      }

      final members = await memberDatasourceRemote.getMembers(token);
      return right(members);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    } catch (e) {
      return left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Success>> syncAllDrafts(String token) async {
    try {
      bool isConnected = await networkServices.isConnected();
      if (!isConnected) {
        return left(const ConnectionFailure(message: 'No Internet Connection'));
      }

      final drafts = await memberDatasourceLocal.getDraftMembers();
      int successCount = 0;

      for (final draft in drafts) {
        try {
          await memberDatasourceRemote.uploadMember(draft.toEntity(), token);
          if (draft.id != null) {
            await memberDatasourceLocal.updateSyncStatus(
              draft.id!,
              SyncStatus.synced,
            );
          }
          successCount++;
        } catch (e) {
          logError('Failed to sync member ${draft.nik}: $e');
        }
      }

      if (successCount == 0 && drafts.isNotEmpty) {
        return left(const ServerFailure(message: 'Semua upload gagal'));
      }

      return right(
        GeneralSuccess(
          message: '$successCount dari ${drafts.length} berhasil diupload',
        ),
      );
    } catch (e) {
      return left(GeneralFailure(message: e.toString()));
    }
  }
}
