import 'package:firebase_core/firebase_core.dart';
import 'package:fl_test/firebase_options.dart';
import 'package:fl_test/services/auth/auth_provider.dart';
import 'package:fl_test/services/auth/auth_user.dart';
import 'package:fl_test/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider authProvider;

  const AuthService(this.authProvider);

  //* make instance of AuthService
  factory AuthService.fireBase() => AuthService(
        FireBaseAuthProvider(),
      );

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      authProvider.createUser(email: email, password: password);

  @override
  AuthUser? get currentUser => authProvider.currentUser;

  @override
  Future<void> logOut() => authProvider.logOut();

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) =>
      authProvider.login(email: email, password: password);

  @override
  Future<void> sendEmailVerification() => authProvider.sendEmailVerification();

  @override
  Future<void> initialze() => authProvider.initialze();
}
