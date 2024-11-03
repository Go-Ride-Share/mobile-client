class Message {
  final String conversationId;
  final String posterId;
  final DateTime timestamp;
  final String contents;

  Message({
    required this.conversationId,
    required this.posterId,
    required this.timestamp,
    required this.contents,
  });

  factory Message.fromJson(Map<String, dynamic> json, String conversationId) {
    return Message(
      conversationId: conversationId,
      posterId: json['senderId'],
      timestamp: DateTime.parse(json['timeStamp']),
      contents: json['contents'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversationId': conversationId,
      'posterId': posterId,
      'timestamp': timestamp.toIso8601String(),
      'contents': contents,
    };
  }
}