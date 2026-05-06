part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class ProfileStateInitial extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileStateLoading extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileStateLoaded extends ProfileState {
  final UserProfile profile;
  const ProfileStateLoaded({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class ProfileStateError extends ProfileState {
  final String message;
  const ProfileStateError({required this.message});

  @override
  List<Object?> get props => [message];
}