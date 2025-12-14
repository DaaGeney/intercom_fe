import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/room.dart';
import '../services/api_service.dart';
import '../services/websocket_service.dart';
import 'users_controller.dart';

final roomsProvider = StateNotifierProvider<RoomsController, AsyncValue<List<Room>>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final wsService = ref.watch(webSocketServiceProvider);
  return RoomsController(apiService, wsService);
});

class RoomsController extends StateNotifier<AsyncValue<List<Room>>> {
  final ApiService _apiService;
  final WebSocketService _wsService;

  RoomsController(this._apiService, this._wsService) : super(const AsyncValue.loading()) {
    _fetchRooms();
    _listenToEvents();
  }

  Future<void> _fetchRooms() async {
    try {
      final rooms = await _apiService.getRooms();
      state = AsyncValue.data(rooms);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void _listenToEvents() {
    _wsService.events.listen((event) {
      if (event['type'] == 'room.created' || event['type'] == 'room.joined') {
        _fetchRooms();
      }
    });
  }

  Future<void> createRoom(String name) async {
    try {
      await _apiService.createRoom(name);
      _fetchRooms();
    } catch (e) {
      print('Error creating room: $e');
    }
  }

  Future<Map<String, dynamic>> joinRoom(String roomId, String userId) async {
    try {
      final response = await _apiService.joinRoom(roomId, userId);
      _fetchRooms();
      return response; // Returns { success, token, url, roomName }
    } catch (e) {
      print('Error joining room: $e');
      rethrow;
    }
  }
}
