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
    apiKey: 'AIzaSyCyyJP9-Ca2fseZHzun-tiz36Bh-ZGxwic',
    appId: '1:1084925483913:web:7c0f3831a9e3dc717b9f58',
    messagingSenderId: '1084925483913',
    projectId: 'btap-attendance',
    authDomain: 'btap-attendance.firebaseapp.com',
    storageBucket: 'btap-attendance.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBSMe86e1eWXbe5KGrzBQhAS-0P84Qlr2c',
    appId: '1:1084925483913:android:8e4662e0922aaccd7b9f58',
    messagingSenderId: '1084925483913',
    projectId: 'btap-attendance',
    storageBucket: 'btap-attendance.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDzdzfVdnTNDuU7JiAscijH_E1Jf6xCFR4',
    appId: '1:1084925483913:ios:382c498887822ceb7b9f58',
    messagingSenderId: '1084925483913',
    projectId: 'btap-attendance',
    storageBucket: 'btap-attendance.firebasestorage.app',
    iosBundleId: 'com.example.attBlue',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDzdzfVdnTNDuU7JiAscijH_E1Jf6xCFR4',
    appId: '1:1084925483913:ios:c061c67d2d930ff37b9f58',
    messagingSenderId: '1084925483913',
    projectId: 'btap-attendance',
    storageBucket: 'btap-attendance.firebasestorage.app',
    iosBundleId: 'com.attendance.attBlue',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCyyJP9-Ca2fseZHzun-tiz36Bh-ZGxwic',
    appId: '1:1084925483913:web:1229eedc9cc53d0e7b9f58',
    messagingSenderId: '1084925483913',
    projectId: 'btap-attendance',
    authDomain: 'btap-attendance.firebaseapp.com',
    storageBucket: 'btap-attendance.firebasestorage.app',
  );

}