import 'package:custom_services/services/notifications/message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _onBackgroundMessage(RemoteMessage message) =>
    NotificationHandler.handleMessage(message, true);

Future<void> _onForegroundMessage(RemoteMessage message) =>
    NotificationHandler.handleMessage(message, false);

typedef NotificationHandlingMethod = Future<void> Function(
    NotificationMessage message, bool background);

class NotificationHandler {
  static NotificationMessage _transformMessage(RemoteMessage message) =>
      NotificationMessage(
        id: message.messageId,
        empty: message.notification == null,
        title: message.notification?.title,
        body: message.notification?.body,
        data: message.data,
      );

  static NotificationHandlingMethod? _messageHandler;

  static void setMessageHandler(
    Future<void> Function(NotificationMessage message, bool background) handler,
  ) async {
    _messageHandler = handler;

    // provided function must be top level (not in class)
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
  }

  static Future<void> handleMessage(
    RemoteMessage message,
    bool background,
  ) async {
    if (_messageHandler == null) {
      return;
    }
    return _messageHandler!.call(_transformMessage(message), background);
  }

  static void onForegroundMessage(
      Future<void> Function(NotificationMessage message) onMessage) {}

  static Future<String?> getToken(String? key) async {
    try {
      return await FirebaseMessaging.instance.getToken(vapidKey: key);
    } catch (err) {
      // result may be null, e.g. when permission for notifications not granted
      return null;
    }
  }

  static Future<bool> requestPermission() async =>
      (await FirebaseMessaging.instance.requestPermission())
          .authorizationStatus ==
      AuthorizationStatus.authorized;

  static Future<void> subscribeTopic(String topic, bool subscribe) async {
    if (subscribe) {
      await FirebaseMessaging.instance.subscribeToTopic(topic);
    } else {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    }
  }
}
