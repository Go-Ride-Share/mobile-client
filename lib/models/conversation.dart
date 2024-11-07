import 'message.dart';

class Conversation {
  final String conversationId;
  final String? conversationPartner;
  final String? conversationPartnerId;
  final List<Message> messages;
  final String lastMessage;

  Conversation({
    required this.conversationId,
    required this.conversationPartner,
    required this.conversationPartnerId,
    required this.messages,
    required this.lastMessage,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {

    List<Message> messages = (json['messages'] as List).map((message) => Message.fromJson(message, json['conversationId'])).toList();
    return Conversation(
      conversationId: json['conversationId'],
      conversationPartner: json['user']['name'],
      conversationPartnerId: json['user']['userId'],
      messages: messages,
      lastMessage: messages.isNotEmpty ? messages.last.contents : ''
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