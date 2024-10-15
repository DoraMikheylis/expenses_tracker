// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC1B6js8jco0I_6H-dfQ0fMfDGgSEgQg_8',
    appId: '1:472153105907:web:f31642f111994f3fb65e86',
    messagingSenderId: '472153105907',
    projectId: 'expense-tracker-581c2',
    authDomain: 'expense-tracker-581c2.firebaseapp.com',
    storageBucket: 'expense-tracker-581c2.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCWrA9HrLl4YD1z35sui9-Un5cgy8IfyiE',
    appId: '1:472153105907:android:729343556a4f26adb65e86',
    messagingSenderId: '472153105907',
    projectId: 'expense-tracker-581c2',
    storageBucket: 'expense-tracker-581c2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyALlQgEc2eVdX8d6MbdEm5Pgqxjhx6QODA',
    appId: '1:472153105907:ios:fa211e65cda0d665b65e86',
    messagingSenderId: '472153105907',
    projectId: 'expense-tracker-581c2',
    storageBucket: 'expense-tracker-581c2.appspot.com',
    iosBundleId: 'com.example.expensesTrackerDasha',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyALlQgEc2eVdX8d6MbdEm5Pgqxjhx6QODA',
    appId: '1:472153105907:ios:f4bcc3f6978a80e1b65e86',
    messagingSenderId: '472153105907',
    projectId: 'expense-tracker-581c2',
    storageBucket: 'expense-tracker-581c2.appspot.com',
    iosBundleId: 'com.example.expensesTracker',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC1B6js8jco0I_6H-dfQ0fMfDGgSEgQg_8',
    appId: '1:472153105907:web:2b2c66bb21e6e876b65e86',
    messagingSenderId: '472153105907',
    projectId: 'expense-tracker-581c2',
    authDomain: 'expense-tracker-581c2.firebaseapp.com',
    storageBucket: 'expense-tracker-581c2.appspot.com',
  );
}