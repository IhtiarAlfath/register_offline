part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class ProfileEventGetProfile extends ProfileEvent {
  final String token;
  const ProfileEventGetProfile({required this.token});

  @override
  List<Object?> get props => [token];
}
