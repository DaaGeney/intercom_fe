class Device {
  final String id;
  final String name;
  final String type;
  final String? userId;

  Device({
    required this.id,
    required this.name,
    required this.type,
    this.userId,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      userId: json['userId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'userId': userId,
    };
  }
}
