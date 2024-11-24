import 'package:flutter/material.dart';
import 'package:go_ride_sharing/widgets/filter_button.dart';
import 'package:go_ride_sharing/services/post_service.dart';
import 'package:go_ride_sharing/widgets/post_card.dart';
import 'package:go_ride_sharing/models/post.dart';

enum FilterType { today, future, past }

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Set to store selected filters
  Set<FilterType> _selectedFilters = {FilterType.today};

  // Method to update selected filters
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
      appBar: AppBar(
        title: const Text('My Listings'),
      ),
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
            final departureDate = DateTime(post.departureDate.year,
                post.departureDate.month, post.departureDate.day);
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

// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const CustomAppBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return PreferredSize(
//       // preferredSize: const Size.fromHeight(1.0),
//       child: AppBar(
//         flexibleSpace: const Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   WelcomeHeader(),
//                   Subtitle(),
//                 ],
//               ),
//               CircleAvatar(
//                 radius: 35,
//                 backgroundImage: AssetImage('assets/images/profile_image.png'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(100.0);
// }