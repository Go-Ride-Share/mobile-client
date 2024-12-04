import 'package:flutter/material.dart';
import 'package:go_ride_sharing/models/post.dart';
import 'package:go_ride_sharing/services/post_service.dart';
import 'package:go_ride_sharing/services/message_service.dart';
import 'package:go_ride_sharing/models/conversation.dart';
import 'package:go_ride_sharing/pages/conversation_detail_page.dart';
import 'package:go_ride_sharing/pages/post_form_page.dart';
import 'package:go_ride_sharing/theme.dart';
import 'package:go_ride_sharing/pages/post_detail_page.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    // TODO: ON TAP, NAVIGATE TO POST DETAILS PAGE (something that shows more details with user details and map view)
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PostDetailPage(post: post)),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: notYellow, width: 2.0),
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

  PostInformation({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage('assets/images/profile_image.png'),
          radius: 30.0,
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.postName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 5.0),
              Text(
                post.description,
                style: TextStyle(
                  fontSize: 14.0,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TripDetails extends StatelessWidget {
  final Post post;

  const TripDetails({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Origin: ',
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: post.originName,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5.0),
        RichText(
          text: TextSpan(
            text: 'Destination: ',
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: post.destinationName,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                text: 'Date: ',
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: post.departureDate.toLocal().toString().split(' ')[0],
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 5.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Max ${post.seatsAvailable} passengers',
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
            Text(
              '\$${post.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        FutureBuilder<String?>(
          future: PostService().userID,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasData && snapshot.data != post.posterId) {
              return ElevatedButton(
                onPressed: () async {
                  Conversation conversation =
                      await MessageService().createConversation(post.posterId);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ConversationDetailPage(conversation: conversation),
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                    backgroundColor: notYellow,
                    foregroundColor: notBlack,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: notBlack),
                child: const Text('Contact'),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}
