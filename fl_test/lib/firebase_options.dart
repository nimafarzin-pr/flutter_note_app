// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCiDHMThbECZTWPs4kBiBHdUP9vAZoazPY',
    appId: '1:324355555530:web:b28352e3619f7ba8623433',
    messagingSenderId: '324355555530',
    projectId: 'nimafiretest',
    authDomain: 'nimafiretest.firebaseapp.com',
    storageBucket: 'nimafiretest.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDdHGvOEIefTZmqHMqW9ra23z355RCEIQM',
    appId: '1:324355555530:android:f198a69d4f346dbe623433',
    messagingSenderId: '324355555530',
    projectId: 'nimafiretest',
    storageBucket: 'nimafiretest.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBka48aepEp7R7cBZDhy20fkUm8iqStClg',
    appId: '1:324355555530:ios:916bb10bf9f50ef6623433',
    messagingSenderId: '324355555530',
    projectId: 'nimafiretest',
    storageBucket: 'nimafiretest.appspot.com',
    iosClientId: '324355555530-2otabrrjfk7bk1adev0pr6dg9kmf2qr5.apps.googleusercontent.com',
    iosBundleId: 'com.example.flTest',
  );
}
