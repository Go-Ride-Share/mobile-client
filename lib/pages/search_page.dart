import 'package:flutter/material.dart';
import 'package:go_ride_sharing/pages/map_page.dart';
import 'package:go_ride_sharing/services/post_service.dart';
import 'package:go_ride_sharing/theme.dart';
import 'package:go_ride_sharing/widgets/map_window.dart';
import 'package:go_ride_sharing/widgets/post_card.dart';
import 'package:go_ride_sharing/models/post.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_ride_sharing/models/search_filter.dart';
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
      print("Date selected: ${_departureDateController.text}");
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

  void _searchWithFilters() {
    // Get the values from the controllers
    final departureDate = _departureDateController.text;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final seatsAvailable = int.tryParse(_seatsAvailableController.text) ?? 0;

    // Call the service to fetch posts with filters
    Future<List<Post>> filteredPostsFuture = PostService().fetchPostsByFilters(
      Searchfilter(
        originLat: origin!.latitude,
        originLng: origin!.longitude,
        destinationLat: destination!.latitude,
        destinationLng: destination!.longitude,
        seatsAvailable: seatsAvailable,
        departureDate: DateTime.parse(departureDate).toUtc(),
        price: price,
      )
    );

    // print('Searching with filters...');
    // _postsFuture?.then((posts) {
    //   for (var post in posts) {
    //   print('Post: $post');
    //   }
    // });
    setState(() {
      _postsFuture = filteredPostsFuture;
    });
  }

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
                    'Filter Posts',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _departureDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Departure Date',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: notYellow, width: 3.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a departure date';
                      }
                      return null;
                    },
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
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      MapWindow(markers: markers),
                      Positioned(
                        top: 20,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            backgroundColor: notYellow,
                            foregroundColor: notBlack,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadowColor: notBlack,
                            elevation:
                                10, // Increase elevation for a more prominent shadow
                          ),
                          icon: const Icon(Icons.pin_drop),
                          label: const Text("Choose Locations"),
                          onPressed: () {
                            _navigateAndDisplayMap(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: FilledButton.styleFrom(
                    backgroundColor: notYellow,
                    foregroundColor: notBlack,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: notBlack),
                    onPressed: () {
                      Navigator.pop(context); // Close the modal
                      _searchWithFilters();
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
