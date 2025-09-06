class MessageModel {
  final String id;
  final String senderId;
  final String content;
  final DateTime time;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.content,
    required this.time,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      senderId: json['senderId'],
      content: json['content'],
      time: DateTime.parse(json['time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'content': content,
      'time': time.toIso8601String(),
    };
  }
}