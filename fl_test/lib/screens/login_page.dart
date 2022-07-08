import 'package:fl_test/constant/consts.dart';
import 'package:fl_test/services/auth/auth_exception.dart';
import 'package:fl_test/services/auth/auth_service.dart';
import 'package:fl_test/services/auth/bloc/auth_bloc.dart';
import 'package:fl_test/services/auth/bloc/bloc_event.dart';
import 'package:fl_test/utils/dialog/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _email;
  late final TextEditingController _pass;

  @override
  void initState() {
    _email = TextEditingController();
    _pass = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Lottie.network(
                  'https://assets3.lottiefiles.com/private_files/lf30_d8vue0c7.json',
                  alignment: Alignment.topCenter,
                  fit: BoxFit.contain,
                  height: double.infinity,
                  width: double.infinity),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.network(
                      'https://assets3.lottiefiles.com/packages/lf20_0w4fvbov.json',
                      alignment: Alignment.topCenter,
                      height: 200,
                      width: double.infinity),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: SizedBox(
                      // width: 200,
                      child: TextField(
                        controller: _email,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          hintText: 'Enter email address',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: TextField(
                      controller: _pass,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Enter password',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                    child: SizedBox(
                      height: 46,
                      width: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                        onPressed: () async {
                          final email = _email.text;
                          final password = _pass.text;
                          try {
                            context.read<AuthBloc>().add(
                                  AuthEventLogin(email, password),
                                );
                          } on UserNotFoundAuthException {
                            await showErrorDialog(
                              context,
                              'User not found',
                            );
                          } on WrongPasswordAuthException {
                            await showErrorDialog(
                              context,
                              'Password is wrong',
                            );
                          } on GenericAuthException {
                            await showErrorDialog(
                              context,
                              'Authentication error',
                            );
                          }
                        },
                        child: const Text("Login"),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('you dont have account?'),
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      signupRoute, (_) => false);
                                },
                                child: const Text('please sign up'),
                              )
                            ])),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
