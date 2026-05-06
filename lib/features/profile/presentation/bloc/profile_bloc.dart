import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:register_offline/features/profile/data/repositories/profile_repositories_impl.dart';
import 'package:register_offline/features/profile/domain/entities/user_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';


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
