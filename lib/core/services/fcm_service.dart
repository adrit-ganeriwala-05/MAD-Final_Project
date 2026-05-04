// lib/core/services/fcm_service.dart

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tropicaguide/core/utils/logger.dart';

/// Handles FCM permission, token management, topic subscriptions,
/// and foreground notification display.
class FcmService {
  /// Creates an [FcmService].
  const FcmService(this._messaging);

  final FirebaseMessaging _messaging;

  /// Initialises FCM — requests permission, logs token, sets foreground
  /// notification presentation options.
  Future<void> init() async {
    final settings = await _messaging.requestPermission();

    appLogger.i(
      'FCM: permission status → ${settings.authorizationStatus}',
    );

    final token = await _messaging.getToken();
    appLogger.i('FCM: device token → $token');

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      appLogger.i(
        'FCM: foreground message → ${message.notification?.title}',
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      appLogger.i(
        'FCM: opened from notification → ${message.data}',
      );
    });

    appLogger.i('FCM: initialised');
  }

  /// Subscribes the device to a trip topic so it receives
  /// notifications for that trip.
  Future<void> subscribeToTrip(String tripId) async {
    await _messaging.subscribeToTopic('trip_$tripId');
    appLogger.i('FCM: subscribed to trip_$tripId');
  }

  /// Unsubscribes the device from a trip topic.
  Future<void> unsubscribeFromTrip(String tripId) async {
    await _messaging.unsubscribeFromTopic('trip_$tripId');
    appLogger.i('FCM: unsubscribed from trip_$tripId');
  }
}
