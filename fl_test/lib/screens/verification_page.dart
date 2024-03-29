import 'package:fl_test/constant/consts.dart';
import 'package:fl_test/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({Key? key}) : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            const Text(
                'We Have send you verification email please open it to verify your email'),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.green),
              onPressed: () async {
                await AuthService.fireBase().sendEmailVerification();
              },
              child: const Text('Send email verification'),
            ),
            TextButton(
                onPressed: () async {
                  AuthService.fireBase().logOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(signupRoute, (_) => false);
                },
                child: const Text(
                  'Restart',
                  style: TextStyle(color: Colors.blue),
                ))
          ]),
        ),
      ),
    );
  }
}
