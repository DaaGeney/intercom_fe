import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/call.dart';
import '../services/api_service.dart';
import '../services/websocket_service.dart';
import 'users_controller.dart';

final callsProvider = StateNotifierProvider<CallsController, Call?>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final wsService = ref.watch(webSocketServiceProvider);
  return CallsController(apiService, wsService);
});

class CallsController extends StateNotifier<Call?> {
  final ApiService _apiService;
  final WebSocketService _wsService;

  CallsController(this._apiService, this._wsService) : super(null) {
    _listenToEvents();
  }

  void _listenToEvents() {
    _wsService.events.listen((event) {
      if (event['type'] == 'call.started') {
        // Assuming event data contains call info
        // state = Call.fromJson(event['data']);
        // For now, we might need to fetch or just update state if data is provided
        print('Call started event received');
      } else if (event['type'] == 'call.ended') {
        state = null;
      }
    });
  }

  Future<void> startCall(String callerId, String receiverId) async {
    try {
      final call = await _apiService.startCall(callerId, receiverId);
      state = call;
    } catch (e) {
      print('Error starting call: $e');
    }
  }

  Future<void> endCall(String callId) async {
    try {
      await _apiService.endCall(callId);
      state = null;
    } catch (e) {
      print('Error ending call: $e');
    }
  }
}
