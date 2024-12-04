import 'package:flutter/material.dart';
import 'package:go_ride_sharing/models/conversation.dart';
import 'package:go_ride_sharing/models/post.dart';
import 'package:go_ride_sharing/services/message_service.dart';
import 'package:go_ride_sharing/theme.dart';
import 'package:go_ride_sharing/widgets/map_window.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_ride_sharing/services/post_service.dart';
import 'package:go_ride_sharing/pages/conversation_detail_page.dart';
class PostDetailPage extends StatelessWidget {
  final Post post;
  late final Map<MarkerId, Marker> markers;


  //require some conversation details too. If not provided then dont show it.
  //works perfectly becuase when opened from my post page, contact button doesnt appear
  //but when clicked from search page, it does appear.
  PostDetailPage({super.key, required this.post}) {
    markers = {
      MarkerId('Origin'): Marker(
        markerId: MarkerId('Origin'),
        position: LatLng(post.originLat, post.originLng),
        infoWindow: InfoWindow(
          title: 'Origin',
          snippet: post.originName,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      MarkerId('Destination'): Marker(
        markerId: MarkerId('Destination'),
        position: LatLng(post.destinationLat, post.destinationLng),
        infoWindow: InfoWindow(
          title: 'Destination',
          snippet: post.destinationName,
        ),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              post.postName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 16),
            MapWindow(markers: markers),
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
        ),
      ),
    );
  }
}
