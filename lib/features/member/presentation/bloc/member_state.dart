part of 'member_bloc.dart';

abstract class MemberState extends Equatable {
  const MemberState();
}

class MemberStateInitial extends MemberState {
  @override
  List<Object?> get props => [];
}

class MemberStateLoading extends MemberState {
  @override
  List<Object?> get props => [];
}

class MemberStateDraftLoaded extends MemberState {
  final List<MemberLocal> drafts;
  const MemberStateDraftLoaded({required this.drafts});

  @override
  List<Object?> get props => [drafts];
}

class MemberStateRemoteLoaded extends MemberState {
  final List<MemberRemote> members;
  const MemberStateRemoteLoaded({required this.members});

  @override
  List<Object?> get props => [members];
}

class MemberStateSaveSuccess extends MemberState {
  final String message;
  const MemberStateSaveSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class MemberStateUploadSuccess extends MemberState {
  final String message;
  const MemberStateUploadSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class MemberStateSyncSuccess extends MemberState {
  final String message;
  const MemberStateSyncSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class MemberStateSyncing extends MemberState {
  final int current;
  final int total;
  const MemberStateSyncing({required this.current, required this.total});

  @override
  List<Object?> get props => [current, total];
}

class MemberStateError extends MemberState {
  final String message;
  const MemberStateError({required this.message});

  @override
  List<Object?> get props => [message];
}