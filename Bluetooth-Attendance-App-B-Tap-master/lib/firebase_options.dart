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
    apiKey: 'AIzaSyBXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
    appId: '1:XXXXXXXXXXXX:web:XXXXXXXXXXXXXXXXXXXXXXXXXXXX',
    messagingSenderId: 'XXXXXXXXXXXX',
    projectId: 'your-project-id',
    authDomain: 'your-project-id.firebaseapp.com',
    storageBucket: 'your-project-id.appspot.com',
    measurementId: 'G-XXXXXXXXXX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
    appId: '1:XXXXXXXXXXXX:android:XXXXXXXXXXXXXXXXXXXXXXXXXXXX',
    messagingSenderId: 'XXXXXXXXXXXX',
    projectId: 'your-project-id',
    storageBucket: 'your-project-id.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
    appId: '1:XXXXXXXXXXXX:ios:XXXXXXXXXXXXXXXXXXXXXXXXXXXX',
    messagingSenderId: 'XXXXXXXXXXXX',
    projectId: 'your-project-id',
    storageBucket: 'your-project-id.appspot.com',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
    appId: '1:XXXXXXXXXXXX:macos:XXXXXXXXXXXXXXXXXXXXXXXXXXXX',
    messagingSenderId: 'XXXXXXXXXXXX',
    projectId: 'your-project-id',
    storageBucket: 'your-project-id.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
    appId: '1:XXXXXXXXXXXX:windows:XXXXXXXXXXXXXXXXXXXXXXXXXXXX',
    messagingSenderId: 'XXXXXXXXXXXX',
    projectId: 'your-project-id',
    storageBucket: 'your-project-id.appspot.com',
  );
}
