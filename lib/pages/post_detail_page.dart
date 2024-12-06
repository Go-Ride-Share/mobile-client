import 'package:flutter/material.dart';
import 'package:go_ride_sharing/widgets/trip_details.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_ride_sharing/models/post.dart';
import 'package:go_ride_sharing/widgets/map_window.dart';
import 'package:go_ride_sharing/theme.dart';

class PostDetailPage extends StatelessWidget {
  final Post post;
  late final Map<MarkerId, Marker> markers;

  PostDetailPage({super.key, required this.post}) {
    markers = {
      const MarkerId('Origin'): Marker(
        markerId: const MarkerId('Origin'),
        position: LatLng(post.originLat, post.originLng),
        infoWindow: InfoWindow(
          title: 'Origin',
          snippet: post.originName,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      const MarkerId('Destination'): Marker(
        markerId: const MarkerId('Destination'),
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
        title: const Text('Post Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildInfoCard(
              title: post.postName,
              subtitle: post.description,
              titleStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              subtitleStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 10),
            buildInfoCard(
              title: 'Travel Details',
              content: TripDetails(post: post),
            ),
            const SizedBox(height: 10),
            MapWindow(markers: markers),
          ],
        ),
      ),
    );
  }

  Widget buildInfoCard({
    required String title,
    String? subtitle,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    Widget? content,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(color: notYellow, width: 2),
      ),
      shadowColor: notBlack,
      elevation: 2, // Increased elevation for a more prominent shadow
      child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(title,
          style: titleStyle ??
            const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: notBlack)),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(subtitle,
            style: subtitleStyle ??
              const TextStyle(fontSize: 16, color: notBlack)),
        ],
        if (content != null) ...[
          const SizedBox(height: 10),
          content,
        ],
        ],
      ),
      ),
    );
  }
}
