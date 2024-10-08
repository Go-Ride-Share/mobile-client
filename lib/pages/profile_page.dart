// File: lib/pages/profile_page.dart

import 'package:flutter/material.dart';
import 'package:go_ride_sharing/widgets/filter_button.dart'; // Update with your actual project name
import 'package:go_ride_sharing/services/post_service.dart'; // Import your PostService
import 'package:go_ride_sharing/widgets/post_card.dart'; // Import your PostCard
import 'package:go_ride_sharing/models/post.dart'; // Import your Post model

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: FilterButtonRow(),
          ),
          Expanded(
            child: PostList(),
          ),
        ],
      ),
    );
  }
}

class PostList extends StatelessWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: PostService().fetchProfilePosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No posts available'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return PostCard(post: snapshot.data![index]);
            },
          );
        }
      },
    );
  }
}

class FilterButtonRow extends StatelessWidget {
  const FilterButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        FilterButton(
          label: 'Today',
          onPressed: () {
            // Add your logic here
            print('Today printing out');
          },
        ),
        const SizedBox(width: 8),
        FilterButton(
          label: 'Future',
          onPressed: () {
            // Add your logic here
          },
        ),
        const SizedBox(width: 8),
        FilterButton(
          label: 'Past',
          onPressed: () {
            // Add your logic here
          },
        ),
      ],
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(1.0), // Set a spacious height
      child: AppBar(
        //backgroundColor: Colors.blue, // Set the background color to blue
        flexibleSpace: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start, // Align to the left
                children: [
                  WelcomeHeader(),
                  Subtitle(),
                ],
              ),
              CircleAvatar(
                radius: 35, // Adjust the radius as needed
                backgroundImage: AssetImage('assets/images/profile_image.png'), // Replace with your image asset
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100.0);
}

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.red, // Set the background color to red
      //padding: const EdgeInsets.all(8.0), // Add some padding if needed
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'Welcome ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: 'John!',
            ),
          ],
          style: TextStyle(fontSize: 30, color: Colors.black),
        ),
      ),
    );
  }
}

class Subtitle extends StatelessWidget {
  const Subtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'See all your trips',
      style: TextStyle(fontSize: 20),
    );
  }
}
