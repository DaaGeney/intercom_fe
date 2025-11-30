class Call {
  final String id;
  final String fromUserId;
  final String toUserId;
  final String status; // 'initiated', 'active', 'ended'
  final String? channel;
  final String? uniqueId;
  final String? startTime;

  Call({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.status,
    this.channel,
    this.uniqueId,
    this.startTime,
  });

  factory Call.fromJson(Map<String, dynamic> json) {
    return Call(
      id: json['callId'] as String? ?? json['id'] as String,
      fromUserId: json['fromUserId'] as String? ?? '',
      toUserId: json['toUserId'] as String? ?? '',
      status: json['status'] as String,
      channel: json['channel'] as String?,
      uniqueId: json['uniqueId'] as String?,
      startTime: json['startTime'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'status': status,
      'channel': channel,
      'uniqueId': uniqueId,
      'startTime': startTime,
    };
  }
}
