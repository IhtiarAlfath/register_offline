import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:register_offline/features/profile/data/repositories/profile_repositories_impl.dart';
import 'package:register_offline/features/profile/domain/entities/user_profile.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class ProfileEventGetProfile extends ProfileEvent {
  final String token;
  const ProfileEventGetProfile({required this.token});

  @override
  List<Object?> get props => [token];
}

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

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfile getProfile;

  ProfileBloc({required this.getProfile}) : super(ProfileStateInitial()) {
    on<ProfileEventGetProfile>((event, emit) async {
      try {
        emit(ProfileStateLoading());
        final result = await getProfile.call(event.token);
        result.fold(
          (l) => emit(ProfileStateError(message: l.message)),
          (r) => emit(ProfileStateLoaded(profile: r)),
        );
      } catch (e) {
        emit(ProfileStateError(message: e.toString()));
      }
    });
  }
}
