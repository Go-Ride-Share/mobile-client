// File: lib/pages/profile_page.dart

import 'package:flutter/material.dart';
import 'package:go_ride_sharing/widgets/filter_button.dart'; // Update with your actual project name
import 'package:go_ride_sharing/services/post_service.dart'; // Import your PostService
import 'package:go_ride_sharing/widgets/post_card.dart'; // Import your PostCard
import 'package:go_ride_sharing/models/post.dart'; // Import your Post model

enum FilterType { today, future, past }

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Set<FilterType> _selectedFilters = {FilterType.today};

  void _updateFilter(FilterType filter) {
    setState(() {
      if (_selectedFilters.contains(filter)) {
        _selectedFilters.remove(filter);
      } else {
        _selectedFilters.add(filter);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FilterButtonRow(
              selectedFilters: _selectedFilters,
              onFilterChanged: _updateFilter,
            ),
          ),
          Expanded(
            child: PostList(filters: _selectedFilters),
          ),
        ],
      ),
    );
  }
}

class PostList extends StatelessWidget {
  final Set<FilterType> filters;

  const PostList({super.key, required this.filters});

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
          final now = DateTime.now();
            final filteredPosts = snapshot.data!.where((post) {
            final departureDate = DateTime(post.departureDate.year, post.departureDate.month, post.departureDate.day);
            final today = DateTime(now.year, now.month, now.day);
            return filters.any((filter) {
              switch (filter) {
              case FilterType.today:
                return departureDate == today;
              case FilterType.future:
                return departureDate.isAfter(today);
              case FilterType.past:
                return departureDate.isBefore(today);
              }
            });
            }).toList();
          return ListView.builder(
            itemCount: filteredPosts.length,
            itemBuilder: (context, index) {
              return PostCard(post: filteredPosts[index]);
            },
          );
        }
      },
    );
  }
}

class FilterButtonRow extends StatelessWidget {
  final Set<FilterType> selectedFilters;
  final ValueChanged<FilterType> onFilterChanged;

  const FilterButtonRow({
    super.key,
    required this.selectedFilters,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        FilterButton(
          label: 'Today',
          onPressed: () => onFilterChanged(FilterType.today),
          isSelected: selectedFilters.contains(FilterType.today),
        ),
        const SizedBox(width: 8),
        FilterButton(
          label: 'Future',
          onPressed: () => onFilterChanged(FilterType.future),
          isSelected: selectedFilters.contains(FilterType.future),
        ),
        const SizedBox(width: 8),
        FilterButton(
          label: 'Past',
          onPressed: () => onFilterChanged(FilterType.past),
          isSelected: selectedFilters.contains(FilterType.past),
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
