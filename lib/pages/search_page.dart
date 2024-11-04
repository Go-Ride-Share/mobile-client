import 'package:flutter/material.dart';
import 'package:go_ride_sharing/services/post_service.dart';
import 'package:go_ride_sharing/widgets/post_card.dart';
import 'package:go_ride_sharing/models/post.dart'; // Assuming you have a Post model

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<List<Post>>? _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = PostService().fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No posts found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: PostCard(post: snapshot.data![index]),
                );
              },
            );
          }
        },
      ),
    );
  }
}