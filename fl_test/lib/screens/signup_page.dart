import 'dart:convert';

import 'package:fl_test/constant/consts.dart';
import 'package:fl_test/services/auth/auth_exception.dart';
import 'package:fl_test/services/auth/auth_service.dart';
import 'package:fl_test/utils/dialog/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
            Lottie.network(
                'https://assets6.lottiefiles.com/packages/lf20_ZdVYgO.json',
                alignment: Alignment.topCenter,
                fit: BoxFit.contain,
                height: double.infinity,
                width: double.infinity),
            SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.network(
                    'https://assets3.lottiefiles.com/packages/lf20_0w4fvbov.json',
                    alignment: Alignment.topCenter,
                    height: 200,
                    width: double.infinity),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: SizedBox(
                    child: TextField(
                      controller: _email,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'User name',
                        hintText: 'Enter user name',
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
                      hintText: 'Enter Password',
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
                          await AuthService.fireBase()
                              .createUser(email: email, password: password);
                          AuthService.fireBase().sendEmailVerification();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              verificationRoute, (_) => false);
                        } on WeakPasswordAuthException {
                          await showErrorDialog(
                            context,
                            'Weak password',
                          );
                        } on EmailAlreadyInUseAuthException {
                          await showErrorDialog(
                            context,
                            'Email already in use',
                          );
                        } on InvalidEmailAuthException {
                          await showErrorDialog(
                            context,
                            'Email is invalid',
                          );
                        } on GenericAuthException {
                          await showErrorDialog(
                            context,
                            'Faild to register',
                          );
                        }
                      },
                      child: const Text("SignUp"),
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
                            const Text('you have account?'),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    loginRoute, (_) => false);
                              },
                              child: const Text('please login'),
                            )
                          ])),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
