import 'package:fl_test/screens/login_page.dart';
import 'package:fl_test/screens/verification_page.dart';
import 'package:fl_test/screens/views/note_view.dart';
import 'package:fl_test/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.fireBase().initialze(),
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.fireBase().currentUser;
              if (user != null) {
                if (user.isEmailVerified) {
                  return const NoteView();
                } else {
                  return const VerificationPage();
                }
              } else {
                return const LoginPage();
              }
            default:
              return const CircularProgressIndicator();
          }
        }));
  }
}
