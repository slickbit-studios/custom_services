import 'dart:async';
import 'dart:io';

import 'package:custom_services/services/crash_report/logger.dart';
import 'package:custom_services/services/socket/connection.dart';
import 'package:custom_services/services/socket/exceptions.dart';
import 'package:flutter/foundation.dart';

class NativeSocketConnection extends SocketConnection {
  final String url;
  final Duration pingInterval;
  final Duration timeout;
  final Duration retryReconnectDuration;
  final int retryAttempts;
  final Map<String, dynamic> headers;

  WebSocket? _socket;
  BackendState _state = BackendState.STATE_DISCONNECTED;

  NativeSocketConnection({
    required this.url,
    VoidCallback? onDisconnected,
    this.pingInterval = const Duration(seconds: 10),
    this.timeout = const Duration(seconds: 20),
    this.retryReconnectDuration = const Duration(seconds: 1),
    this.retryAttempts = 15,
    this.headers = const {},
  }) : super(onDisconnected: onDisconnected);

  @override
  Future<void> connect({String path = '', Duration? timeout}) async {
    int attempt = 0;

    while (attempt < retryAttempts) {
      try {
        await _singleConnectAttempt(path: path, timeout: timeout);
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
  void disconnect([int? status]) {
    _socket?.close(status);
    _state = BackendState.STATE_DISCONNECTED;
  }

  @override
  void sendMessage(String message) {
    try {
      _socket!.add(message);
    } catch (err) {
      _state = BackendState.STATE_DISCONNECTED;
      onDisconnected?.call();
    }
  }

  Future<void> _singleConnectAttempt({
    required String path,
    Duration? timeout,
  }) async {
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

    _socket = await WebSocket.connect(
      '$url/$path',
      headers: headers,
    ).timeout(timeout ?? this.timeout);

    // set up handler
    _state = BackendState.STATE_CONNECTED;
    _socket!.pingInterval = pingInterval;
    _socket!.listen(handleMessage);

    // register callback for connection close
    _socket!.done.then((_) {
      _state = BackendState.STATE_DISCONNECTED;
      //  send disconnected event
      onDisconnected?.call();
    });
  }
}
