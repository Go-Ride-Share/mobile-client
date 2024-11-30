import 'package:flutter/material.dart';
import 'package:go_ride_sharing/pages/map_page.dart';
import 'package:go_ride_sharing/services/post_service.dart';
import 'package:go_ride_sharing/theme.dart';
import 'package:go_ride_sharing/widgets/post_card.dart';
import 'package:go_ride_sharing/models/post.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  Future<List<Post>>? _postsFuture;
  final _seatsAvailableController = TextEditingController();
  final _departureDateController = TextEditingController();
  final _priceController = TextEditingController();

  LatLng? origin;
  LatLng? destination;
  Map<MarkerId, Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _postsFuture = PostService().fetchAllPosts();
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _seatsAvailableController.dispose();
    _departureDateController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // Function to select a date using a date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _departureDateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _navigateAndDisplayMap(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    Map<MarkerId, Marker> result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapPage()),
    );

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    if (!context.mounted) return;

    setState(() {
      markers = result;
      origin = result.values.first.position;
      destination = result.values.last.position;
    });
  }
  // void _applyFilters() {
  //   setState(() {
  //     _filteredItems = _items.where((item) {
  //       final matchesName = item['name']
  //           .toString()
  //           .toLowerCase()
  //           .contains(_nameController.text.toLowerCase());
  //       final matchesCategory = _selectedCategory == 'All' ||
  //           item['category'] == _selectedCategory;
  //       final matchesPrice =
  //           item['price'] >= _minPrice && item['price'] <= _maxPrice;

  //       return matchesName && matchesCategory && matchesPrice;
  //     }).toList();
  //   });
  // }

  void _openSearchModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes the modal expandable to full height.
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        side: BorderSide(color: notYellow),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Search Filters',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: _priceController,
                          decoration: const InputDecoration(
                            labelText: 'Price',
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: notYellow, width: 3.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: _seatsAvailableController,
                          decoration: const InputDecoration(
                            labelText: 'Number of Seats',
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: notYellow, width: 3.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _departureDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                        ),
                        labelText: 'Departure Date',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: notYellow, width: 3.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // _applyFilters();
                      Navigator.pop(context); // Close the modal
                    },
                    child: const Text('Search'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Posts'),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          FutureBuilder<List<Post>>(
            future: _postsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No posts found.'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: PostCard(post: snapshot.data![index]),
                    );
                  },
                );
              }
            },
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton.extended(
              onPressed: _openSearchModal,
              label: const Text('Filter Posts'),
              backgroundColor: notYellow,
              foregroundColor: notBlack,
              icon: const Icon(Icons.filter_alt),
            ),
          ),
        ],
      ),
    );
  }
}
