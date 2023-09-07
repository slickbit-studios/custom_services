import 'package:custom_services/services/notifications/message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationHandler {
  static NotificationMessage transformMessage(RemoteMessage message) =>
      NotificationMessage(
        id: message.messageId,
        empty: message.notification == null,
        title: message.notification?.title,
        body: message.notification?.body,
        data: message.data,
      );

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
