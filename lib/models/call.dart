class Call {
  final String id;
  final String callerId;
  final String receiverId;
  final String status; // 'ringing', 'active', 'ended'

  Call({
    required this.id,
    required this.callerId,
    required this.receiverId,
    required this.status,
  });

  factory Call.fromJson(Map<String, dynamic> json) {
    return Call(
      id: json['id'] as String,
      callerId: json['callerId'] as String,
      receiverId: json['receiverId'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'callerId': callerId,
      'receiverId': receiverId,
      'status': status,
    };
  }
}
