class Device {
  final String peer;
  final String status; // 'ONLINE', 'OFFLINE'
  final String? address;
  final String? userId;
  final String lastUpdated;

  Device({
    required this.peer,
    required this.status,
    this.address,
    this.userId,
    required this.lastUpdated,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      peer: json['peer'] as String,
      status: json['status'] as String,
      address: json['address'] as String?,
      userId: json['userId'] as String?,
      lastUpdated: json['lastUpdated'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'peer': peer,
      'status': status,
      'address': address,
      'userId': userId,
      'lastUpdated': lastUpdated,
    };
  }
  
  // Helper for UI compatibility
  String get id => peer;
  String get name => peer;
  String get type => 'SIP Device';
}
