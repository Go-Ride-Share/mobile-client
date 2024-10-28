import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_ride_sharing/services/message_service.dart';
import 'package:go_ride_sharing/models/conversation.dart';
import 'package:go_ride_sharing/models/message.dart';

class ConversationDetailPage extends StatefulWidget {
  final Conversation conversation;

  ConversationDetailPage({required this.conversation});

  @override
  _ConversationDetailPageState createState() => _ConversationDetailPageState();
}

class _ConversationDetailPageState extends State<ConversationDetailPage> {
  List<Message> _messages = [];
  Timer? _timer;
  DateTime _lastTimestamp = DateTime.now();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _pollMessages();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _fetchMessages() async {
    try {
      final messages = await MessageService().getMessagesForConversation(widget.conversation.conversationId);
      setState(() {
        _messages = messages;
        if (messages.isNotEmpty) {
          _lastTimestamp = messages.last.timestamp;
        }
      });
      _scrollToBottom();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _pollMessages() async {
    try {
      final newMessages = await MessageService().pollMessages(widget.conversation.conversationId, _lastTimestamp);
      if (newMessages.isNotEmpty) {
        setState(() {
          _messages.addAll(newMessages);
          _lastTimestamp = newMessages.last.timestamp;
        });
        _scrollToBottom(); // Scroll to bottom when new messages arrive
      }
    } catch (e) {
      // Handle error
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isNotEmpty) {
      final message = Message(
        conversationId: widget.conversation.conversationId,
        posterId: '', // Leave posterId empty as per the requirement
        timestamp: DateTime.now(),
        contents: content,
      );
      try {
        await MessageService().postMessage(widget.conversation.conversationId, message);
        _messageController.clear();
        await _pollMessages(); // Poll for new messages after sending
      } catch (e) {
        // Handle error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conversation.conversationPartner ?? 'Unknown Partner'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isMine = message.posterId == 'user1';
                      return MessageBubble(
                        message: message,
                        alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final Message message;
  final Alignment alignment;

  MessageBubble({required this.message, required this.alignment});

  @override
  Widget build(BuildContext context) {
    final textAlign = alignment == Alignment.centerRight ? TextAlign.right : TextAlign.left;
    final crossAxisAlignment = alignment == Alignment.centerRight ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Align(
      alignment: alignment,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xffeec232), // Updated color
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            Text(
              message.contents,
              style: TextStyle(fontSize: 16),
              textAlign: textAlign,
            ),
            SizedBox(height: 5),
            Text(
              message.timestamp.toString(),
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: textAlign,
            ),
          ],
        ),
      ),
    );
  }
}