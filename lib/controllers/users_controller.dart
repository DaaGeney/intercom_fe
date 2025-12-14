import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/websocket_service.dart';
import '../config.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(baseUrl: Config.backendUrl);
});

final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  return WebSocketService(url: Config.backendUrl);
});

final currentUserProvider = StateProvider<User?>((ref) => null);

final usersProvider = StateNotifierProvider<UsersController, AsyncValue<List<User>>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final wsService = ref.watch(webSocketServiceProvider);
  final currentUserController = ref.watch(currentUserProvider.notifier);
  return UsersController(apiService, wsService, currentUserController);
});

class UsersController extends StateNotifier<AsyncValue<List<User>>> {
  final ApiService _apiService;
  final WebSocketService _wsService;
  final StateController<User?> _currentUserController;

  UsersController(this._apiService, this._wsService, this._currentUserController) : super(const AsyncValue.loading()) {
    _fetchUsers();
    _listenToEvents();
    _wsService.connect();
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
        _fetchUsers();
      }
    });
  }

  Future<void> createUser(String name) async {
    try {
      final user = await _apiService.createUser(name);
      _currentUserController.state = user; // Set current user
      _fetchUsers();
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }
}
