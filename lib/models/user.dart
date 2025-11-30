class User {
  final String id;
  final String name;
  final String? sipPeer;

  User({
    required this.id,
    required this.name,
    this.sipPeer,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      sipPeer: json['sipPeer'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sipPeer': sipPeer,
    };
  }
  
  // Helper for UI compatibility
  String get username => name;
  String get status => sipPeer != null ? 'online' : 'offline';
  String? get avatarUrl => null; // API doesn't provide avatar
}
