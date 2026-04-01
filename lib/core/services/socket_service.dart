import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  bool isConnected = false;

  final String baseUrl =
      'https://superambitious-noninclusively-dorcas.ngrok-free.dev';

  void connect(token) {
    socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .enableReconnection()
          .setReconnectionAttempts(9999)
          .setReconnectionDelay(2000)
          .setReconnectionDelayMax(10000)
          .setAuth({'token': token})
          .disableAutoConnect()
          .build(),
    );

    _registerListeners();
    socket.connect();
  }

  void _registerListeners() {
    socket.onConnect((_) {
      isConnected = true;
      debugPrint('Connected');
    });

    socket.onDisconnect((reason) {
      isConnected = false;
      debugPrint('Disconnected: $reason');
    });

    socket.onConnectError((err) {
      isConnected = false;
      debugPrint('Connect error: $err');
    });

    socket.onReconnect((_) {
      debugPrint('Reconnected');
    });
  }

  void emit(String event, dynamic data) {
    if (socket.connected) {
      socket.emit(event, data);
    }
  }

  void disconnect() {
    socket.disconnect();
    socket.dispose();
    isConnected = false;
  }

  void listenEvent(String eventName, dynamic Function(dynamic) onData) {
    socket.on(eventName, (data) {
      onData(data);
    });
  }

  void stopListening(String eventName) {
    socket.off(eventName);
  }
}
