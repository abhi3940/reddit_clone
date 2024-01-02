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
    apiKey: 'AIzaSyA-v19paNdZ9sxBh1Q5BgBbe_t5b5tbSio',
    appId: '1:819493082482:web:852e5285e269708d22f9eb',
    messagingSenderId: '819493082482',
    projectId: 'reddit-clone-6875c',
    authDomain: 'reddit-clone-6875c.firebaseapp.com',
    storageBucket: 'reddit-clone-6875c.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC0ORvHDa4ESNtDylIXuVQoYBAqfzl1Pik',
    appId: '1:819493082482:android:a0b2adc2d95d86ae22f9eb',
    messagingSenderId: '819493082482',
    projectId: 'reddit-clone-6875c',
    storageBucket: 'reddit-clone-6875c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD1OMlFFM1EwDaIHiJk1duJY95XY7vqNDA',
    appId: '1:819493082482:ios:541577c5f4736c3b22f9eb',
    messagingSenderId: '819493082482',
    projectId: 'reddit-clone-6875c',
    storageBucket: 'reddit-clone-6875c.appspot.com',
    iosBundleId: 'com.example.redditClone',
  );
}
