// File: lib/pages/home_page.dart

import 'package:flutter/material.dart';
import 'profile_page.dart';  // Import the ProfilePage here
import 'post_form_page.dart';  // Import the CreatePostPage here

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ProfilePage(),  // Use the ProfilePage widget
    const Center(child: Text('Create Post Page')),
    const Center(child: Text('Search Page')),
    const Center(child: Text('Messages Page')),
  ];

  void _onTabTapped(int index) {
    if (index == 1) {
      // Show the CreatePostPage as a bottom sheet
      showModalBottomSheet(
        context: context,
        builder: (context) => const PostFormPage(),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _pages[_currentIndex],  // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.black,  // Set the selected item color to black
        unselectedItemColor: Colors.black,  // Set the unselected item color to black
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
        ],
      ),
    );
  }
}
