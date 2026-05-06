part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState([List<dynamic> props = const <dynamic>[]]);
}

class AuthenticationStateEmpty extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class AuthenticationStateEmptyDataLogin extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class AuthenticationStateLoading extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class AuthenticationStateError extends AuthenticationState {
  final String message;

  const AuthenticationStateError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthenticationStateLoginSuccess extends AuthenticationState {
  final DataLogin dataLogin;

  const AuthenticationStateLoginSuccess({required this.dataLogin});

  @override
  List<Object?> get props => [dataLogin];
}

class AuthenticationStateLogoutSuccess extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class AuthenticationStateAlreadyLogin extends AuthenticationState {
  final DataLogin dataLogin;

  const AuthenticationStateAlreadyLogin({required this.dataLogin});

  @override
  List<Object?> get props => [dataLogin];
}

class AuthenticationStateShowPassword extends AuthenticationState {
  final bool showPassword;

  const AuthenticationStateShowPassword({required this.showPassword});

  @override
  List<Object?> get props => [showPassword];
}
