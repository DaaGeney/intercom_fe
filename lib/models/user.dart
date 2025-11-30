class User {
  final String id;
  final String username;
  final String status; // 'online', 'offline', 'busy'
  final String? avatarUrl;

  User({
    required this.id,
    required this.username,
    this.status = 'offline',
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      status: json['status'] as String? ?? 'offline',
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'status': status,
      'avatarUrl': avatarUrl,
    };
  }
}
