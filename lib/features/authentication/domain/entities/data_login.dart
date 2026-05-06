import 'package:equatable/equatable.dart';

class DataLogin extends Equatable {
  final String token;

  const DataLogin({
    required this.token,
  });

  @override
  List<Object?> get props => [token,];
}

class DataLoginParameter extends Equatable {
  final String email;
  final String password;

  const DataLoginParameter({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
