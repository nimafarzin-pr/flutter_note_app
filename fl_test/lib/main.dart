import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:fl_test/constant/consts.dart';
import 'package:fl_test/firebase_options.dart';
import 'package:fl_test/screens/home_page.dart';
import 'package:fl_test/screens/login_page.dart';
import 'package:fl_test/screens/signup_page.dart';
import 'package:fl_test/screens/verification_page.dart';
import 'package:fl_test/screens/views/create_or_update_note_view.dart';
import 'package:fl_test/screens/views/note_view.dart';
import 'package:flutter/material.dart';

import 'dart:developer' as devtool show log;
import 'package:meta/meta.dart';

// extension Log on Object {
//   void log() => devtool.log(toString());
// }

// extension GetOnUri on Object {
//   Future<HttpClientResponse> getUrl(String url) => HttpClient()
//       .getUrl(
//         Uri.parse(url),
//       )
//       .then(
//         (req) => req.close(),
//       );
// }

// //spacify mixin on type of Animal
// mixin canMakeGetCall {
//   String get url;
//   @useResult
//   Future<String> getString() => getUrl(url).then(
//         (response) => response.transform(utf8.decoder).join(),
//       );
// }

// @immutable
// class GetEmploee with canMakeGetCall {
//   const GetEmploee();

//   @override
//   // TODO: implement url
//   String get url => 'http://127.0.0.1:5500/lib/apis/employee.json';
// }

// void testIt() async {
//   final emploee = await const GetEmploee().getString();
//   emploee.log();
// }

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const _MyApp());
}

// class _Root extends StatelessWidget {
//   const _Root({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const _MyApp();
//   }
// }

class _MyApp extends StatefulWidget {
  const _MyApp({Key? key}) : super(key: key);

  @override
  __MyAppState createState() => __MyAppState();
}

class __MyAppState extends State<_MyApp> {
  @override
  Widget build(BuildContext context) {
    // testIt();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: <String, WidgetBuilder>{
        loginRoute: (BuildContext context) => const LoginPage(),
        signupRoute: (BuildContext context) => const SignUpPage(),
        verificationRoute: (BuildContext context) => const VerificationPage(),
        homeRoute: (BuildContext context) => const HomePage(),
        noteViewRoute: (BuildContext context) => const NoteView(),
        createOrUpdateNoteViewRoute: (BuildContext context) =>
            const CreateOrUpdateNoteView(),
      },
      // home: Scaffold(
      //     resizeToAvoidBottomInset: false,
      //     backgroundColor: Colors.green[50],
      //     body: const LoginPage()),
    );
  }
}
