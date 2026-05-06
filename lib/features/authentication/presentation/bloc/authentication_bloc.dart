import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:register_offline/core/error/failures.dart';
import 'package:register_offline/core/utils/logger.dart';
import 'package:register_offline/features/authentication/domain/entities/data_login.dart';
import 'package:register_offline/features/authentication/domain/usecases/login.dart';
import 'package:register_offline/features/authentication/domain/usecases/logout.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final Login login;
  final Logout logout;

  AuthenticationBloc({
    required this.login,
    required this.logout,
  }) : super(AuthenticationStateEmpty()) {
    on<AuthenticationEventShowPassword>((event, emit) async {
      try {
        emit(AuthenticationStateShowPassword(showPassword: event.showPassword));
      } catch (e) {
        emit(const AuthenticationStateError(message: 'Cannot show Password'));
      }
    });

    on<AuthenticationEventLogin>((event, emit) async {
      try {
        emit(AuthenticationStateLoading());

        final loginResult =
            await login.call(event.dataLoginParameter);

        await loginResult.fold(
          (lLogin) async {
            if (lLogin is ConnectionFailure) {
              emit(AuthenticationStateError(message: lLogin.message));
            } else if (lLogin is ServerFailure) {
              emit(AuthenticationStateError(message: lLogin.message));
            } else if (lLogin is GeneralFailure) {
              emit(AuthenticationStateError(message: lLogin.message));
            } else {
              emit(const AuthenticationStateError(message: 'Login Failed'));
            }
          },
          (rLogin) async {
            emit(AuthenticationStateLoginSuccess(dataLogin: rLogin));
          },
        );
      } catch (e) {
        logInfo('Login bloc error: $e');
        emit(const AuthenticationStateError(message: 'Login gagal'));
      }
    });

    on<AuthenticationEventLogout>((event, emit) async {
      try {
        emit(AuthenticationStateLoading());
        final result = await logout.call();
        result.fold(
          (l) => emit(AuthenticationStateError(message: l.message)),
          (r) => emit(AuthenticationStateLogoutSuccess()),
        );
      } catch (e) {
        emit(const AuthenticationStateError(message: 'Logout gagal'));
      }
    });

    on<AuthenticationEventCheckLogin>((event, emit) async {
      emit(AuthenticationStateEmptyDataLogin());
    });
  }
}
