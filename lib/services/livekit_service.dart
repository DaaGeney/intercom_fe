import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';

class LiveKitService {
  Room? _room;
  LocalParticipant? get localParticipant => _room?.localParticipant;
  Room? get room => _room;

  Future<Room> connect({
    required String url,
    required String token,
  }) async {
    try {
      // Create room instance
      _room = Room();

      // Setup room listeners
      _room!.addListener(_onRoomUpdate);

      // Connect to the room
      await _room!.connect(
        url,
        token,
        roomOptions: const RoomOptions(
          adaptiveStream: true,
          dynacast: true,
        ),
      );

      // Enable camera and microphone
      try {
        await _room!.localParticipant?.setCameraEnabled(false); // Start with camera off for voice calls
        await _room!.localParticipant?.setMicrophoneEnabled(true);
      } catch (e) {
        debugPrint('Error enabling devices: $e');
      }

      return _room!;
    } catch (e) {
      debugPrint('Error connecting to LiveKit: $e');
      rethrow;
    }
  }

  Future<void> disconnect() async {
    try {
      await _room?.disconnect();
      _room?.removeListener(_onRoomUpdate);
      _room?.dispose();
      _room = null;
    } catch (e) {
      debugPrint('Error disconnecting from LiveKit: $e');
    }
  }

  Future<void> toggleMicrophone() async {
    final enabled = _room?.localParticipant?.isMicrophoneEnabled() ?? false;
    await _room?.localParticipant?.setMicrophoneEnabled(!enabled);
  }

  Future<void> toggleCamera() async {
    final enabled = _room?.localParticipant?.isCameraEnabled() ?? false;
    await _room?.localParticipant?.setCameraEnabled(!enabled);
  }

  Future<void> toggleSpeaker() async {
    // Toggle speaker on/off (for mobile)
    // Note: Speaker toggling is platform-specific
    // For now, this is a placeholder that can be customized per platform
    try {
      // On mobile, you might use platform channels or package-specific methods
      // LiveKit will handle audio routing automatically
      debugPrint('Speaker toggle requested');
    } catch (e) {
      debugPrint('Error toggling speaker: $e');
    }
  }

  bool get isMicrophoneEnabled => _room?.localParticipant?.isMicrophoneEnabled() ?? false;
  bool get isCameraEnabled => _room?.localParticipant?.isCameraEnabled() ?? false;

  void _onRoomUpdate() {
    debugPrint('Room updated');
  }

  void dispose() {
    disconnect();
  }
}

