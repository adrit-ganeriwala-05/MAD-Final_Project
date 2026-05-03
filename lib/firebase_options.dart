// File generated manually from Firebase project config.
// Project: tropicaguide-adrit-2026

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  /// Returns the [FirebaseOptions] for the current platform.
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Web is not a supported platform for TropicaGuide.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'iOS is not a supported platform for TropicaGuide.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'macOS is not a supported platform for TropicaGuide.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'Windows is not a supported platform for TropicaGuide.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'Linux is not a supported platform for TropicaGuide.',
        );
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'Fuchsia is not a supported platform for TropicaGuide.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB5KhbMm7MzbRqnMh5ZWhyDAT_HFM-HxOs',
    appId: '1:635161622057:android:fd11e40649f05da0f0ce38',
    messagingSenderId: '635161622057',
    projectId: 'tropicaguide-adrit-2026',
    storageBucket: 'tropicaguide-adrit-2026.firebasestorage.app',
  );

  /// Firebase options for Android.
}