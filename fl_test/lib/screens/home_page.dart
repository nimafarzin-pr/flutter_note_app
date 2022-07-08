import 'package:fl_test/screens/login_page.dart';
import 'package:fl_test/screens/verification_page.dart';
import 'package:fl_test/screens/views/note_view.dart';
import 'package:fl_test/services/auth/bloc/auth_bloc.dart';
import 'package:fl_test/services/auth/bloc/bloc_event.dart';
import 'package:fl_test/services/auth/bloc/bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialized());

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NoteView();
        } else if (state is AuthStateNeedVerification) {
          return const VerificationPage();
        } else if (state is AuthStateLoggedOut) {
          return const LoginPage();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
