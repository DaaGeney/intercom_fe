class Room {
  final String id;
  final String name;
  final String? roomName;
  final List<String> participants; // List of User IDs

  Room({
    required this.id,
    required this.name,
    this.roomName,
    this.participants = const [],
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as String,
      name: json['name'] as String,
      roomName: json['roomName'] as String?,
      participants: (json['participants'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'roomName': roomName,
      'participants': participants,
    };
  }
}
