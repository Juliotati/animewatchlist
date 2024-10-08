// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

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
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCvq4B176Eo1f75SNkNw0TR7Zg04g0eFk8',
    appId: '1:638684765228:web:9771eba431bca8c1f30589',
    messagingSenderId: '638684765228',
    projectId: 'aniwavewatchlist',
    authDomain: 'aniwavewatchlist.firebaseapp.com',
    storageBucket: 'aniwavewatchlist.appspot.com',
    measurementId: 'G-7F8H19XXW2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAMbG-F64-Kd-MloiNVW9UbxYvBIJjfrGM',
    appId: '1:638684765228:android:c4f848239516ef48f30589',
    messagingSenderId: '638684765228',
    projectId: 'aniwavewatchlist',
    storageBucket: 'aniwavewatchlist.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCdGSs9mOiY9nv450vL7nnZ4s8tYHz8-vA',
    appId: '1:638684765228:ios:800b35a7095495a6f30589',
    messagingSenderId: '638684765228',
    projectId: 'aniwavewatchlist',
    storageBucket: 'aniwavewatchlist.appspot.com',
    iosBundleId: 'com.juliotati.anime',
  );
}
