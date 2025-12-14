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
        // Parse call data from event
        try {
          final callData = event['data'];
          if (callData != null) {
            final call = Call.fromJson(callData);
            state = call;
            
            // Note: The receiving user needs to get their own token
            // This should be handled in the UI layer (navigate to call screen,
            // then CallScreen will get token via joinRoom or getLiveKitToken)
          }
        } catch (e) {
          print('Error parsing call.started event: $e');
        }
      } else if (event['type'] == 'call.ended') {
        state = null;
      }
    });
  }

  Future<void> startCall(String fromUserId, String toUserId) async {
    try {
      final call = await _apiService.startCall(fromUserId, toUserId);
      // Backend now returns LiveKit token, url and roomName
      state = Call(
        id: call.id,
        fromUserId: fromUserId,
        toUserId: toUserId,
        status: call.status,
        roomName: call.roomName,
        token: call.token,
        url: call.url,
        startTime: call.startTime,
      );
    } catch (e) {
      print('Error starting call: $e');
      rethrow;
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
