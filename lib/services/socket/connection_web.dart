import 'dart:async';

import 'package:custom_services/services/socket/connection.dart';
import 'package:custom_services/services/socket/exceptions.dart';
import 'package:custom_services/util/logger.dart';
import 'package:universal_html/html.dart';

class WebSocketConnection extends SocketConnection {
  final String url;
  final Duration pingInterval;
  final Duration timeout;
  final Duration retryReconnectDuration;
  final int retryAttempts;

  WebSocket? _socket;
  BackendState _state = BackendState.STATE_DISCONNECTED;
  Timer? _pingTimer;

  WebSocketConnection({
    required this.url,
    VoidCallback? onDisconnected,
    this.pingInterval = const Duration(seconds: 10),
    this.timeout = const Duration(seconds: 20),
    this.retryReconnectDuration = const Duration(seconds: 1),
    this.retryAttempts = 15,
  }) : super(onDisconnected: onDisconnected);

  @override
  Future<void> connect() async {
    int attempt = 0;

    while (attempt < retryAttempts) {
      try {
        await _singleConnectAttempt();
        return;
      } on TimeoutException catch (_) {
        rethrow;
      } catch (error) {
        attempt++;
        _state = BackendState.STATE_DISCONNECTED;

        if (attempt >= retryAttempts) {
          throw SocketException(
            message: 'Failed to connect in $retryAttempts tries',
            url: url,
          );
        } else {
          // wait before next try
          await Future.delayed(retryReconnectDuration);
        }
      }
    }
  }

  @override
  void sendMessage(String message) {
    try {
      _socket!.sendString(message);
    } catch (err) {
      _state = BackendState.STATE_DISCONNECTED;
      onDisconnected?.call();
    }
  }

  Future<void> _singleConnectAttempt() async {
    // if already connected, just perform the connectedCallback
    if (_state == BackendState.STATE_CONNECTED) {
      Logger.instance.info(
        module: runtimeType,
        message: 'No new connection was established, because STATE_CONNECTED',
      );
      return;
    }

    // otherwise connect
    _state = BackendState.STATE_CONNECTING;
    _socket = WebSocket(url);

    // check for connection until timeout
    DateTime start = DateTime.now();
    bool connected = false;
    bool error = false;
    _socket!.onOpen.listen((event) => connected = true);
    _socket!.onClose.listen((event) => error = true);
    _socket!.onError.listen((event) => error = true);

    while (true) {
      if (!connected) {
        int time = DateTime.now().millisecondsSinceEpoch -
            start.millisecondsSinceEpoch;
        if (Duration(milliseconds: time) > timeout) {
          _state = BackendState.STATE_DISCONNECTED;
          _socket = null;
          throw TimeoutException('Connection timeout $timeout');
        } else {
          await Future.delayed(const Duration(milliseconds: 50));
        }
      } else if (error) {
        _state = BackendState.STATE_DISCONNECTED;
        _socket = null;
        throw SocketException(message: 'Connection failed', url: url);
      } else {
        break;
      }
    }

    // if this point is reached, connection was successful
    _state = BackendState.STATE_CONNECTED;
    _pingTimer = Timer.periodic(pingInterval, (timer) {
      if (_socket?.readyState == WebSocket.OPEN) {
        _socket?.sendString('{}');
      }
    });

    // listen for messages
    _socket!.onMessage.listen(handleMessage);

    // register callback for connection close
    _socket!.onClose.listen((_) {
      _state = BackendState.STATE_DISCONNECTED;
      _pingTimer?.cancel();
      _pingTimer = null;
      onDisconnected?.call();
    });
  }
}
