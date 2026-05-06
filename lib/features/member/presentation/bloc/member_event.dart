part of 'member_bloc.dart';
abstract class MemberEvent extends Equatable {
  const MemberEvent();
}

class MemberEventSaveDraft extends MemberEvent {
  final MemberLocal member;
  const MemberEventSaveDraft({required this.member});

  @override
  List<Object?> get props => [member];
}

class MemberEventUpdateDraft extends MemberEvent {
  final MemberLocal member;
  const MemberEventUpdateDraft({required this.member});

  @override
  List<Object?> get props => [member];
}

class MemberEventGetDrafts extends MemberEvent {
  const MemberEventGetDrafts();

  @override
  List<Object?> get props => [];
}

class MemberEventUpload extends MemberEvent {
  final MemberLocal member;
  final String token;
  const MemberEventUpload({required this.member, required this.token});

  @override
  List<Object?> get props => [member, token];
}

class MemberEventGetRemote extends MemberEvent {
  final String token;
  const MemberEventGetRemote({required this.token});

  @override
  List<Object?> get props => [token];
}

class MemberEventSyncAll extends MemberEvent {
  final String token;
  const MemberEventSyncAll({required this.token});

  @override
  List<Object?> get props => [token];
}

class MemberEventDelete extends MemberEvent {
  final int id;
  const MemberEventDelete({required this.id});

  @override
  List<Object?> get props => [id];
}
