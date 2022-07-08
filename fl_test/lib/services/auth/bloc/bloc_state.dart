import 'package:fl_test/services/auth/auth_user.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateLogedInFailure extends AuthState {
  final Exception exception;
  const AuthStateLogedInFailure(this.exception);
}

class AuthStateNeedVerification extends AuthState {
  const AuthStateNeedVerification();
}

class AuthStateLoggedOut extends AuthState {
  const AuthStateLoggedOut();
}

class AuthStateLogedOutFailure extends AuthState {
  final Exception exception;
  const AuthStateLogedOutFailure(this.exception);
}
