class Room {
  final String id;
  final String name;
  final String conferenceId;
  final List<String> participants; // List of User IDs

  Room({
    required this.id,
    required this.name,
    required this.conferenceId,
    this.participants = const [],
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as String,
      name: json['name'] as String,
      conferenceId: json['conferenceId'] as String,
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
      'conferenceId': conferenceId,
      'participants': participants,
    };
  }
}
