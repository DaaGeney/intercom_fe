import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class WebSocketService {
  final String url;
  IO.Socket? _socket;
  final _controller = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get events => _controller.stream;

  WebSocketService({required this.url});

  void connect() {
    _socket = IO.io(url, IO.OptionBuilder()
      .setTransports(['websocket', 'polling'])
      .disableAutoConnect()
      .build());

    _socket!.connect();

    _socket!.onConnect((_) {
      print('Connected to WebSocket Server');
    });

    _socket!.onDisconnect((_) {
      print('Disconnected from WebSocket Server');
    });

    _socket!.on('device.updated', (data) => _handleEvent('device.updated', data));
    _socket!.on('user.registered', (data) => _handleEvent('user.registered', data));
    _socket!.on('call.started', (data) => _handleEvent('call.started', data));
    _socket!.on('call.ended', (data) => _handleEvent('call.ended', data));
    _socket!.on('room.created', (data) => _handleEvent('room.created', data));
    _socket!.on('room.joined', (data) => _handleEvent('room.joined', data));
  }

  void _handleEvent(String eventName, dynamic payload) {
    // The server sends { event: "name", data: { ... } } inside the payload?
    // Based on the guide:
    // socket.on('device.updated', (payload) => { console.log(payload.data) });
    // So payload has a 'data' field.
    
    if (payload is Map<String, dynamic>) {
      // We'll normalize it to our stream format
      _controller.add({
        'type': eventName,
        'data': payload['data'] ?? payload,
      });
    } else {
      print('Received unexpected payload format for $eventName: $payload');
    }
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
  }
}
