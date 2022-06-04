import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:lottie/lottie.dart';

import '../../screens/login_page.dart';

class CodePage extends StatelessWidget {
  const CodePage({Key? key}) : super(key: key);

  final String requiredNumber = '';
  Column code({required String title, context}) {
    return Column(
      children: [
        Container(
          width: 1200,
          margin: const EdgeInsets.only(
            right: 10,
            top: 20,
          ),
          child: Text(
            title,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25.0,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20.0),
          child: PinCodeTextField(
            textStyle: const TextStyle(color: Colors.white),
            appContext: context,
            length: 6,
            cursorColor: Colors.white,
            onChanged: (value) {
              print(value);
            },
            pinTheme: PinTheme(
              activeFillColor: Colors.white,
              activeColor: Color(0xFFFeaedf0),
              inactiveFillColor: Color(0xFFFeaedf0),
              inactiveColor: Color(0xFFFeaedf0),
              selectedColor: Color(0xFFFeaedf0),
              selectedFillColor: Color(0xFFFeaedf0),
            ),
            onCompleted: (value) {
              if (value == requiredNumber) {
                print('valid pin');
              } else {
                print('invalid pin');
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        // Lottie.asset(
        //   'assets/waves.json',
        //   height: 1200,
        //   width: 1200,
        //   fit: BoxFit.cover,
        // ),
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              code(title: 'رمز اپلیکیشن ', context: context),
              code(title: 'تکرار رمز عبور ', context: context),
              Container(
                margin: const EdgeInsets.only(left: 20, top: 40, right: 20),
                child: TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Color.fromARGB(255, 97, 226, 213),
                      textStyle: TextStyle(fontSize: 20)),
                  child: Text('تایید'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
