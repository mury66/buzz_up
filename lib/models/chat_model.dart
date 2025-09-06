import 'package:buzz_up/models/user_model.dart';

import 'message_model.dart';

class ChatModel {
  final String id;
  List<UserModel> participants;
  List<MessageModel> messages;
  DateTime lastUpdated;

  ChatModel(this.id, this.participants, this.messages, this.lastUpdated);

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      json['id'],
      (json['participants'] as List)
          .map((participant) => UserModel.fromJson(participant))
          .toList(),
      (json['messages'] as List)
          .map((message) => MessageModel.fromJson(message))
          .toList(),
      DateTime.parse(json['lastUpdated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participants': participants.map((participant) => participant.toJson()).toList(),
      'messages': messages.map((message) => message.toJson()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}