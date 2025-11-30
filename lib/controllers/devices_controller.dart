import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/device.dart';
import '../services/api_service.dart';
import '../services/websocket_service.dart';
import 'users_controller.dart'; // Import to access providers

final devicesProvider = StateNotifierProvider<DevicesController, AsyncValue<List<Device>>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final wsService = ref.watch(webSocketServiceProvider);
  return DevicesController(apiService, wsService);
});

class DevicesController extends StateNotifier<AsyncValue<List<Device>>> {
  final ApiService _apiService;
  final WebSocketService _wsService;

  DevicesController(this._apiService, this._wsService) : super(const AsyncValue.loading()) {
    _fetchDevices();
    _listenToEvents();
  }

  Future<void> _fetchDevices() async {
    try {
      final devices = await _apiService.getDevices();
      state = AsyncValue.data(devices);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void _listenToEvents() {
    _wsService.events.listen((event) {
      if (event['type'] == 'device.updated') {
        _fetchDevices();
      }
    });
  }

  Future<void> attachDevice(String userId, String sipPeer) async {
    try {
      await _apiService.attachDevice(userId, sipPeer);
      _fetchDevices();
    } catch (e) {
      print('Error attaching device: $e');
    }
  }
}
