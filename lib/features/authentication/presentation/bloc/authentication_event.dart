part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent([List<dynamic> props = const <dynamic>[]]);
}

class AuthenticationEventEmpty extends AuthenticationEvent {
  const AuthenticationEventEmpty();

  @override
  List<Object?> get props => [];
}

class AuthenticationEventLogin extends AuthenticationEvent {
  final DataLoginParameter dataLoginParameter;

  const AuthenticationEventLogin({
    required this.dataLoginParameter,
  });

  @override
  List<Object?> get props => [dataLoginParameter];
}

class AuthenticationEventLogout extends AuthenticationEvent {
  const AuthenticationEventLogout();

  @override
  List<Object?> get props => [];
}

class AuthenticationEventShowPassword extends AuthenticationEvent {
  final bool showPassword;

  const AuthenticationEventShowPassword({required this.showPassword});

  @override
  List<Object?> get props => [showPassword];
}

class AuthenticationEventCheckLogin extends AuthenticationEvent {
  const AuthenticationEventCheckLogin();

  @override
  List<Object?> get props => [];
}
