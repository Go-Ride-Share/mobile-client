import 'message.dart';

class Conversation {
  final String conversationId;
  final String? conversationPartner;
  final List<Message> messages;
  final String lastMessage;

  Conversation({
    required this.conversationId,
    required this.conversationPartner,
    required this.messages,
    required this.lastMessage,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      conversationId: json['conversationId'],
      conversationPartner: json['conversationPartner'],
      messages: (json['messages'] as List).map((message) => Message.fromJson(message)).toList(),
      lastMessage: json['lastMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversationId': conversationId,
      'conversationPartner': conversationPartner,
      'messages': messages.map((message) => message.toJson()).toList(),
      'lastMessage': lastMessage,
    };
  }
}