import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livekit_client/livekit_client.dart';
import '../services/livekit_service.dart';

// Provider for LiveKit Service
final liveKitServiceProvider = Provider<LiveKitService>((ref) {
  final service = LiveKitService();
  ref.onDispose(() {
    service.dispose();
  });
  return service;
});

// Provider for current Room
final liveKitRoomProvider = StateProvider<Room?>((ref) => null);

// Provider for microphone state
final microphoneStateProvider = StateProvider<bool>((ref) => true);

// Provider for speaker state
final speakerStateProvider = StateProvider<bool>((ref) => false);

// Connection state provider
final liveKitConnectionStateProvider = StateProvider<bool>((ref) => false);

