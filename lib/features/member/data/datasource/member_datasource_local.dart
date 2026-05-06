import 'package:hive/hive.dart';
import 'package:register_offline/core/error/failures.dart';
import 'package:register_offline/core/success/success.dart';
import 'package:register_offline/features/member/data/models/member_local_model.dart';
import 'package:register_offline/features/member/domain/entities/member.dart';

abstract class MemberDatasourceLocal {
  Future<GeneralSuccess> saveMember(MemberLocal member);
  Future<GeneralSuccess> updateMember(MemberLocal member);
  Future<List<MemberLocalModel>> getDraftMembers();
  Future<GeneralSuccess> updateSyncStatus(dynamic hiveKey, SyncStatus status);
  Future<GeneralSuccess> deleteMember(dynamic hiveKey);
  Future<List<MemberLocalModel>> getAllMembers();
}

class MemberDatasourceLocalImpl implements MemberDatasourceLocal {
  final Box<MemberLocalModel> memberBox;

  MemberDatasourceLocalImpl({required this.memberBox});

  @override
  Future<GeneralSuccess> saveMember(MemberLocal member) async {
    try {
      final model = MemberLocalModel.fromEntity(member);
      model.createdAt = DateTime.now();
      final key = await memberBox.add(model);
      model.id = key as int;
      await memberBox.put(key, model);
      return const GeneralSuccess(message: 'Member saved as draft');
    } catch (e) {
      throw CacheException(message: 'Cannot save member: $e');
    }
  }

  @override
  Future<GeneralSuccess> updateMember(MemberLocal member) async {
    try {
      if (member.id == null) {
        throw const CacheException(message: 'Member id is null, cannot update');
      }

      final existingModel = memberBox.get(member.id);
      if (existingModel == null) {
        throw CacheException(
            message: 'Member dengan id ${member.id} tidak ditemukan');
      }

      final updatedModel = MemberLocalModel.fromEntity(member);
      updatedModel.createdAt = existingModel.createdAt;
      await memberBox.put(member.id, updatedModel);

      return const GeneralSuccess(message: 'Member updated');
    } catch (e) {
      throw CacheException(message: 'Cannot update member: $e');
    }
  }

  @override
  Future<List<MemberLocalModel>> getDraftMembers() async {
    try {
      final drafts = <MemberLocalModel>[];
      for (final key in memberBox.keys) {
        final model = memberBox.get(key);
        if (model != null && model.syncStatusIndex == SyncStatus.draft.index) {
          model.id = key as int;
          drafts.add(model);
        }
      }
      return drafts;
    } catch (e) {
      throw CacheException(message: 'Cannot get draft members: $e');
    }
  }

  @override
  Future<GeneralSuccess> updateSyncStatus(
      dynamic hiveKey, SyncStatus status) async {
    try {
      final model = memberBox.get(hiveKey);
      if (model != null) {
        model.syncStatusIndex = status.index;
        await memberBox.put(hiveKey, model);
      }
      return const GeneralSuccess(message: 'Sync status updated');
    } catch (e) {
      throw CacheException(message: 'Cannot update sync status: $e');
    }
  }

  @override
  Future<GeneralSuccess> deleteMember(dynamic hiveKey) async {
    try {
      await memberBox.delete(hiveKey);
      return const GeneralSuccess(message: 'Member deleted');
    } catch (e) {
      throw CacheException(message: 'Cannot delete member: $e');
    }
  }

  @override
  Future<List<MemberLocalModel>> getAllMembers() async {
    try {
      final members = <MemberLocalModel>[];
      for (final key in memberBox.keys) {
        final model = memberBox.get(key);
        if (model != null) {
          model.id = key as int;
          members.add(model);
        }
      }
      return members;
    } catch (e) {
      throw CacheException(message: 'Cannot get all members: $e');
    }
  }
}
