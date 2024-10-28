import 'package:flutter/material.dart';
import 'package:go_ride_sharing/models/post.dart';
import 'package:go_ride_sharing/pages/post_form_page.dart';
import 'package:go_ride_sharing/services/post_service.dart';
import 'package:go_ride_sharing/services/message_service.dart';
import 'package:go_ride_sharing/models/conversation.dart';
import 'package:go_ride_sharing/pages/conversation_detail_page.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   // Navigator.push(
      //   //   context,
      //   //   MaterialPageRoute(builder: (context) => PostFormPage(post: post)),
      //   // );
      // },
      child: Card(
        color: Color(0xFFFFF9C4), // Light shade of yellow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostInformation(post: post),
              SizedBox(height: 10.0),
              TripDetails(post: post),
            ],
          ),
        ),
      ),
    );
  }
}

class PostInformation extends StatelessWidget {
  final Post post;

  const PostInformation({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage('assets/images/profile_image.png'),
          radius: 30.0,
        ),
        SizedBox(width: 10.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.postName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              post.description,
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TripDetails extends StatelessWidget {
  final Post post;

  const TripDetails({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Posted by: ${post.posterName}',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${post.seatsAvailable} seats',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Date: ${post.departureDate.toLocal().toString().split(' ')[0]}',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
            Text(
              'Time: ${post.departureDate.toLocal().toString().split(' ')[1].substring(0, 5)}',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
            Text(
              '\$${post.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.0),
        Text(
          '(${post.startLatitude}, ${post.startLongitude}) to (${post.destinationLatitude}, ${post.destinationLongitude})',
          style: TextStyle(
            fontSize: 14.0,
          ),
        ),
        SizedBox(height: 10.0),
        FutureBuilder<String?>(
          future: PostService().userID,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasData && snapshot.data != post.posterId) {
              return ElevatedButton(
                onPressed: () async {
                  String conversationId = await MessageService().createConversation(post.posterId);
                  Conversation conversation = Conversation(
                    conversationId: conversationId,
                    conversationPartner: post.posterName,
                    messages: [],
                    lastMessage: '',
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConversationDetailPage(conversation: conversation),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Contact'),
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}
