class Call {
  final String id;
  final String fromUserId;
  final String toUserId;
  final String status; // 'initiated', 'active', 'ended'
  final String? roomName;
  final String? token;
  final String? url;
  final String? startTime;

  Call({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.status,
    this.roomName,
    this.token,
    this.url,
    this.startTime,
  });

  factory Call.fromJson(Map<String, dynamic> json) {
    return Call(
      id: json['callId'] as String? ?? json['id'] as String,
      fromUserId: json['fromUserId'] as String? ?? '',
      toUserId: json['toUserId'] as String? ?? '',
      status: json['status'] as String,
      roomName: json['roomName'] as String?,
      token: json['token'] as String?,
      url: json['url'] as String?,
      startTime: json['startTime'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'status': status,
      'roomName': roomName,
      'token': token,
      'url': url,
      'startTime': startTime,
    };
  }
}
