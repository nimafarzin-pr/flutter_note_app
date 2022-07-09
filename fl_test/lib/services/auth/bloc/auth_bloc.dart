import 'package:fl_test/services/auth/auth_provider.dart';
import 'package:fl_test/services/auth/bloc/bloc_event.dart';
import 'package:fl_test/services/auth/bloc/bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUnInitialized(isLoading: true)) {
    //* initialize
    on<AuthEventInitialized>(
      (event, emit) async {
        await provider.initialze();
        final user = provider.currentUser;
        if (user == null) {
          emit(
            const AuthStateLoggedOut(exception: null, isLoading: false),
          );
        } else if (!user.isEmailVerified) {
          emit(const AuthStateNeedVerification(isLoading: false));
        } else {
          emit(AuthStateLoggedIn(user: user, isLoading: false));
        }
      },
    );

    //* forgot password
    on<AuthEvenForgotPassword>(
      (event, emit) async {
        emit(
          const AuthStateForgotPassword(
              exception: null, hasSendEmail: false, isLoading: false),
        );
        final email = event.email;
        if (email != null) {
          return; // user just wants to go to forgot-password screen
        }
        // user wants to actually send a forgot-password email
        emit(
          const AuthStateForgotPassword(
              exception: null, hasSendEmail: false, isLoading: true),
        );

        bool didSendEmail;
        Exception? exception;

        try {
          await provider.sendPasswordReset(toEmail: email!);
          didSendEmail = true;
          exception = null;
        } on Exception catch (e) {
          didSendEmail = false;
          exception = e;
        }

        emit(
          AuthStateForgotPassword(
              exception: exception,
              hasSendEmail: didSendEmail,
              isLoading: false),
        );
      },
    );

    //* registering
    on<AuthEventRegister>(
      (event, emit) async {
        final email = event.email;
        final password = event.password;
        try {
          await provider.createUser(
            email: email,
            password: password,
          );
          await provider.sendEmailVerification();
          emit(const AuthStateNeedVerification(isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateRegistering(exception: e, isLoading: false));
        }
      },
    );

    //* should register
    on<AuthEventShouldRegister>(
      (event, emit) async {
        emit(const AuthStateRegistering(exception: null, isLoading: false));
      },
    );

    //* send email verification
    on<AuthEventSendEmailVerification>(
      (event, emit) async {
        await provider.sendEmailVerification();
        emit(state);
      },
    );

    //* logged in
    on<AuthEventLogin>(
      (event, emit) async {
        emit(
          const AuthStateLoggedOut(
              exception: null,
              isLoading: true,
              loadingText: 'Please wait while i log you in'),
        );
        final email = event.email;
        final password = event.password;
        try {
          final user = await provider.login(email: email, password: password);
          if (!user.isEmailVerified) {
            emit(
              const AuthStateLoggedOut(exception: null, isLoading: false),
            );
            emit(const AuthStateNeedVerification(isLoading: false));
          } else {
            emit(
              const AuthStateLoggedOut(exception: null, isLoading: false),
            );
            emit(AuthStateLoggedIn(user: user, isLoading: false));
          }
        } on Exception catch (e) {
          emit(
            AuthStateLoggedOut(exception: e, isLoading: false),
          );
        }
      },
    );

    //* logout
    on<AuthEventLogOut>(
      (event, emit) async {
        try {
          await provider.logOut();
          emit(
            const AuthStateLoggedOut(exception: null, isLoading: false),
          );
        } on Exception catch (e) {
          emit(
            AuthStateLoggedOut(exception: e, isLoading: false),
          );
        }
      },
    );
  }
}
