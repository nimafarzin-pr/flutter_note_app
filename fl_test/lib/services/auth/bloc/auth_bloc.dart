import 'package:fl_test/services/auth/auth_provider.dart';
import 'package:fl_test/services/auth/bloc/bloc_event.dart';
import 'package:fl_test/services/auth/bloc/bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    //* initialize
    on<AuthEventInitialized>(
      (event, emit) async {
        await provider.initialze();
        final user = provider.currentUser;
        if (user == null) {
          emit(const AuthStateLoggedOut());
        } else if (!user.isEmailVerified) {
          emit(const AuthStateNeedVerification());
        } else {
          emit(AuthStateLoggedIn(user));
        }
      },
    );

    //* logged in
    on<AuthEventLogin>(
      (event, emit) async {
        final email = event.email;
        final password = event.password;
        try {
          final user = await provider.login(email: email, password: password);
          emit(AuthStateLoggedIn(user));
        } on Exception catch (e) {
          emit(AuthStateLogedInFailure(e));
        }
      },
    );

    //* logout
    on<AuthEventLogOut>(
      (event, emit) async {
        try {
          emit(const AuthStateLoading());
          await provider.logOut();
          emit(const AuthStateLoggedOut());
        } on Exception catch (e) {
          emit(AuthStateLogedOutFailure(e));
        }
      },
    );
  }
}
