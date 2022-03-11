import 'dart:typed_data';

import 'package:custom_services/services/socket/message_handler.dart';
import 'package:universal_html/html.dart';

typedef RequestCallback = void Function(String message);

enum BackendState { STATE_DISCONNECTED, STATE_CONNECTING, STATE_CONNECTED }

abstract class SocketConnection {
  final void Function()? onDisconnected;
  final List<MessageHandler> _listeners = [];

  SocketConnection({this.onDisconnected});

  Future<void> connect();

  void registerListener(MessageHandler listener) {
    _listeners.add(listener);
  }

  void unregisterListener(MessageHandler listener) {
    _listeners.remove(listener);
  }

  void handleMessage(dynamic message) {
    for (var listener in _listeners) {
      if (message is String) {
        listener.handleMessage(message);
      } else if (message is Uint8List) {
        if (message.isNotEmpty) {
          listener.handleMessage(String.fromCharCodes(message));
        }
      } else if (message is MessageEvent) {
        listener.handleMessage(message.data as String);
      } else {
        throw 'Unable to handle message of type ${message.runtimeType}';
      }
    }
  }

  void sendMessage(String message);
}
