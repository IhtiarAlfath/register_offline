import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:register_offline/core/utils/logger.dart';
import 'package:register_offline/features/member/domain/entities/member.dart';
import 'package:register_offline/features/member/domain/usecases/delete_member_local.dart';
import 'package:register_offline/features/member/domain/usecases/get_draft_members.dart';
import 'package:register_offline/features/member/domain/usecases/get_remote_members.dart';
import 'package:register_offline/features/member/domain/usecases/save_member_local.dart';
import 'package:register_offline/features/member/domain/usecases/sync_all_drafts.dart';
import 'package:register_offline/features/member/domain/usecases/update_member_local.dart';
import 'package:register_offline/features/member/domain/usecases/upload_member.dart';

part 'member_state.dart';
part 'member_event.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  final SaveMemberLocal saveMemberLocal;
  final UpdateMemberLocal updateMemberLocal;
  final GetDraftMembers getDraftMembers;
  final UploadMember uploadMember;
  final GetRemoteMembers getRemoteMembers;
  final SyncAllDrafts syncAllDrafts;
  final DeleteMemberLocal deleteMemberLocal;

  MemberBloc({
    required this.saveMemberLocal,
    required this.updateMemberLocal,
    required this.getDraftMembers,
    required this.uploadMember,
    required this.getRemoteMembers,
    required this.syncAllDrafts,
    required this.deleteMemberLocal,
  }) : super(MemberStateInitial()) {
    on<MemberEventSaveDraft>((event, emit) async {
      try {
        emit(MemberStateLoading());
        final result = await saveMemberLocal.call(event.member);
        result.fold(
          (l) => emit(MemberStateError(message: l.message)),
          (r) => emit(MemberStateSaveSuccess(message: r.message)),
        );
      } catch (e) {
        emit(MemberStateError(message: e.toString()));
      }
    });

    on<MemberEventUpdateDraft>((event, emit) async {
      try {
        emit(MemberStateLoading());
        final result = await updateMemberLocal.call(event.member);
        result.fold(
          (l) => emit(MemberStateError(message: l.message)),
          (r) => emit(MemberStateSaveSuccess(message: 'Draft berhasil diperbarui')),
        );
      } catch (e) {
        emit(MemberStateError(message: e.toString()));
      }
    });

    on<MemberEventGetDrafts>((event, emit) async {
      try {
        emit(MemberStateLoading());
        final result = await getDraftMembers.call();
        result.fold(
          (l) => emit(MemberStateError(message: l.message)),
          (r) => emit(MemberStateDraftLoaded(drafts: r)),
        );
      } catch (e) {
        emit(MemberStateError(message: e.toString()));
      }
    });

    on<MemberEventUpload>((event, emit) async {
      try {
        emit(MemberStateLoading());

        if (event.member.id != null) {
          await updateMemberLocal.call(event.member);
        }

        final result = await uploadMember.call(event.member, event.token);
        result.fold(
          (l) => emit(MemberStateError(message: l.message)),
          (r) => emit(MemberStateUploadSuccess(message: r.message)),
        );
      } catch (e) {
        emit(MemberStateError(message: e.toString()));
      }
    });

    on<MemberEventGetRemote>((event, emit) async {
      try {
        emit(MemberStateLoading());
        final result = await getRemoteMembers.call(event.token);
        result.fold(
          (l) => emit(MemberStateError(message: l.message)),
          (r) => emit(MemberStateRemoteLoaded(members: r)),
        );
      } catch (e) {
        emit(MemberStateError(message: e.toString()));
      }
    });

    on<MemberEventSyncAll>((event, emit) async {
      try {
        emit(MemberStateLoading());
        final result = await syncAllDrafts.call(event.token);
        result.fold(
          (l) => emit(MemberStateError(message: l.message)),
          (r) => emit(MemberStateSyncSuccess(message: r.message)),
        );
      } catch (e) {
        emit(MemberStateError(message: e.toString()));
      }
    });

    on<MemberEventDelete>((event, emit) async {
      try {
        final result = await deleteMemberLocal.call(event.id);
        result.fold(
          (l) => emit(MemberStateError(message: l.message)),
          (r) {
            logInfo('Member deleted');
            add(const MemberEventGetDrafts());
          },
        );
      } catch (e) {
        emit(MemberStateError(message: e.toString()));
      }
    });
  }
}
