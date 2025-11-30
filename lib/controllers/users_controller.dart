import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/websocket_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  // Replace with actual server IP
  return ApiService(baseUrl: 'http://localhost:3000/api');
});

final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  // Replace with actual server IP
  return WebSocketService(url: 'ws://localhost:3000/ws');
});

final usersProvider = StateNotifierProvider<UsersController, AsyncValue<List<User>>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final wsService = ref.watch(webSocketServiceProvider);
  return UsersController(apiService, wsService);
});

class UsersController extends StateNotifier<AsyncValue<List<User>>> {
  final ApiService _apiService;
  final WebSocketService _wsService;

  UsersController(this._apiService, this._wsService) : super(const AsyncValue.loading()) {
    _fetchUsers();
    _listenToEvents();
  }

  Future<void> _fetchUsers() async {
    try {
      final users = await _apiService.getUsers();
      state = AsyncValue.data(users);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void _listenToEvents() {
    _wsService.events.listen((event) {
      if (event['type'] == 'user.registered') {
        _fetchUsers(); // Refresh list on new user
      }
      // Handle other user-related events if needed
    });
  }

  Future<void> createUser(String username) async {
    try {
      await _apiService.createUser(username);
      _fetchUsers();
    } catch (e) {
      // Handle error
      print('Error creating user: $e');
    }
  }
}
