import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/device.dart';
import '../models/room.dart';
import '../models/call.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<User> createUser(String name) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user: ${response.body}');
    }
  }

  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => User.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> attachDevice(String userId, String sipPeer) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/$userId/attach-device'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'sipPeer': sipPeer}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to attach device');
    }
  }

  Future<List<Device>> getDevices() async {
    final response = await http.get(Uri.parse('$baseUrl/devices'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Device.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load devices');
    }
  }

  Future<Call> startCall(String fromUserId, String toUserId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/calls'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'fromUserId': fromUserId, 'toUserId': toUserId}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Call.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to start call');
    }
  }

  Future<void> endCall(String callId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/calls/$callId/end'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to end call');
    }
  }

  Future<Room> createRoom(String name) async {
    final response = await http.post(
      Uri.parse('$baseUrl/rooms'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Room.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create room');
    }
  }

  Future<List<Room>> getRooms() async {
    final response = await http.get(Uri.parse('$baseUrl/rooms'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Room.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load rooms');
    }
  }

  Future<List<User>> getRoomUsers(String roomId) async {
    final response = await http.get(Uri.parse('$baseUrl/rooms/$roomId/users'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => User.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load room users');
    }
  }

  Future<void> joinRoom(String roomId, String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/rooms/$roomId/join'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to join room');
    }
  }
}
