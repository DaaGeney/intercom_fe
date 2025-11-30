import 'dart:convert';
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final String url;
  WebSocketChannel? _channel;
  final _controller = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get events => _controller.stream;

  WebSocketService({required this.url});

  void connect() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _channel!.stream.listen(
        (message) {
          final data = jsonDecode(message);
          _controller.add(data);
        },
        onError: (error) {
          print('WebSocket error: $error');
          // Implement reconnection logic here if needed
        },
        onDone: () {
          print('WebSocket closed');
          // Implement reconnection logic here if needed
        },
      );
    } catch (e) {
      print('WebSocket connection failed: $e');
    }
  }

  void disconnect() {
    _channel?.sink.close();
  }
}
