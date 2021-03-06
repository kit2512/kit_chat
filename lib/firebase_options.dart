// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAtjurHdBlDI40kit9aDmpQE3vmtw-Ww7s',
    appId: '1:48859694134:android:c4858917c0ea3986304497',
    messagingSenderId: '48859694134',
    projectId: 'fir-config-a4806',
    storageBucket: 'fir-config-a4806.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBfylZEfWW0YnYz0Xf0NPnN9td6KQv1gDI',
    appId: '1:48859694134:ios:f56914ea378ba8e3304497',
    messagingSenderId: '48859694134',
    projectId: 'fir-config-a4806',
    storageBucket: 'fir-config-a4806.appspot.com',
    androidClientId: '48859694134-iin59uokh1b96mocljcgm5550jsgqg4n.apps.googleusercontent.com',
    iosClientId: '48859694134-vt6koj7423voqc6tsecjuf42s85jrdk4.apps.googleusercontent.com',
    iosBundleId: 'com.example.kitChat',
  );
}
