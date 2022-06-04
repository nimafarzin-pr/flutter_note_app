import 'package:fl_test/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;

  Future<void> initialze();

  Future<AuthUser> login({required String email, required String password});

  Future<AuthUser> createUser(
      {required String email, required String password});

  Future<void> logOut();

  Future<void> sendEmailVerification();
}
