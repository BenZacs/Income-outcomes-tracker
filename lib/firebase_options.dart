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
    apiKey: 'AIzaSyAOmzd76TA6PREOH-G7QlOAmDNMyQLxx_w',
    appId: '1:918419546040:web:b82fa65ca571c57e5db94d',
    messagingSenderId: '918419546040',
    projectId: 'incomeexpensetracker-75c21',
    authDomain: 'incomeexpensetracker-75c21.firebaseapp.com',
    storageBucket: 'incomeexpensetracker-75c21.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCGQueUU9D9Sv6OLOgq2GhmdIdoenUW3MQ',
    appId: '1:918419546040:android:6b10dcf60aa3ebf05db94d',
    messagingSenderId: '918419546040',
    projectId: 'incomeexpensetracker-75c21',
    storageBucket: 'incomeexpensetracker-75c21.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAaN9az-xVBk4KzLxf_TSm8j5CDnQeCo-4',
    appId: '1:918419546040:ios:77f2df14c836a5c05db94d',
    messagingSenderId: '918419546040',
    projectId: 'incomeexpensetracker-75c21',
    storageBucket: 'incomeexpensetracker-75c21.appspot.com',
    iosClientId: '918419546040-uhatt7uma0t1kv133528vaoa4a4sua5t.apps.googleusercontent.com',
    iosBundleId: 'com.example.incomeOutcomeTracker',
  );
}
