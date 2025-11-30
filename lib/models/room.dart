import 'user.dart';

class Room {
  final String id;
  final String name;
  final List<User> users;

  Room({
    required this.id,
    required this.name,
    this.users = const [],
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as String,
      name: json['name'] as String,
      users: (json['users'] as List<dynamic>?)
              ?.map((e) => User.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'users': users.map((e) => e.toJson()).toList(),
    };
  }
}
