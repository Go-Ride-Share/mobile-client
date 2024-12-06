import 'package:flutter/material.dart';
import 'package:go_ride_sharing/services/message_service.dart';
import 'package:go_ride_sharing/models/conversation.dart';
import 'package:go_ride_sharing/pages/conversation_detail_page.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({super.key});

  @override
  _ConversationsPageState createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  late Future<List<Conversation>> _conversations;

  @override
  void initState() {
    super.initState();
    _conversations = MessageService().getAllConversations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Conversations'),
      ),
      body: FutureBuilder<List<Conversation>>(
        future: _conversations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data?.isEmpty == true) {
            return const Center(child: Text('No conversations found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final conversation = snapshot.data![index];
                return ConversationPreview(
                  conversation: conversation,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConversationDetailPage(
                          conversation: conversation,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ConversationPreview extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;

  const ConversationPreview({super.key, required this.conversation, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        conversation.conversationPartner ?? 'Unknown Partner',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(conversation.lastMessage),
      trailing: const Icon(Icons.arrow_forward_ios), // Added arrow icon here
      onTap: onTap,
    );
  }
}

